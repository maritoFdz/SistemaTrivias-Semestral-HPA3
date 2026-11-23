using System;
using System.Collections.Generic;
using System.Linq;
using Datos;
using Entidades;

namespace Negocios.Servicios
{
    public class N_Juego : IJuegoService
    {
        private const int PreguntasPorPartida = 5;
        private const int SegundosDeGracia = 3; // margen por lo que tarda la red
        private readonly D_Juego _datos;
        private readonly IPreguntaService _preguntas;
        private readonly ISetQrService _sets;

        public N_Juego() : this(new D_Juego(), new N_Pregunta(), new N_SetQr()) { }

        public N_Juego(D_Juego datos, IPreguntaService preguntas, ISetQrService sets)
        {
            _datos = datos;
            _preguntas = preguntas;
            _sets = sets;
        }

        public List<E_TemaProgreso> ListarTemas(E_Usuario actual)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            return _datos.ListarTemas(actual.Id);
        }

        // cada nivel se desbloquea cuando el anterior esta aprobado
        public List<E_NivelJuego> ListarNiveles(E_Usuario actual, int idTema)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            List<E_NivelJuego> niveles = _datos.ListarNiveles(actual.Id, idTema);
            bool anteriorAprobado = true;
            foreach (E_NivelJuego n in niveles.OrderBy(x => x.NuOrden))
            {
                n.Desbloqueado = anteriorAprobado;
                anteriorAprobado = n.Aprobado;
            }
            return niveles;
        }

        public E_PartidaEnCurso Iniciar(E_Usuario actual, int idTema, int idNivel)
        {
            return Comenzar(actual, idTema, idNivel, PreguntasPorPartida);
        }

        // partida desde un qr: usa el tema nivel y cantidad del set y las mismas reglas de siempre
        public E_PartidaEnCurso IniciarSet(E_Usuario actual, string codigo)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            E_SetQr set = _sets.ObtenerPorCodigo(codigo);
            if (set == null || set.DsEstado != "1") throw new InvalidOperationException("El set no está disponible");
            E_PartidaEnCurso partida = Comenzar(actual, set.IdTema, set.IdNivel, set.NuCantidadPreguntas);
            _datos.AsignarSetQr(partida.IdPartida, actual.Id, set.Id);
            return partida;
        }

        private E_PartidaEnCurso Comenzar(E_Usuario actual, int idTema, int idNivel, int cantidad)
        {
            if (!ListarTemas(actual).Exists(t => t.Id == idTema)) throw new InvalidOperationException("El tema no está disponible");
            E_NivelJuego nivel = ListarNiveles(actual, idTema).Find(n => n.IdNivel == idNivel) ?? throw new InvalidOperationException("El nivel no existe");
            if (!nivel.Desbloqueado) throw new InvalidOperationException("Debes aprobar el nivel anterior para jugar este");
            if (nivel.NuPreguntas == 0) throw new InvalidOperationException("Este nivel todavía no tiene preguntas");

            List<int> ids = _datos.SortearPreguntas(idTema, idNivel, Math.Min(cantidad, nivel.NuPreguntas));
            int idPartida = _datos.IniciarPartida(actual.Id, idTema, idNivel, ids.Count);
            return new E_PartidaEnCurso { IdPartida = idPartida, IdUsuario = actual.Id, IdTema = idTema, IdNivel = idNivel, IdsPreguntas = ids };
        }

        // devuelve la pregunta sin decir cual opcion es la correcta
        public E_Pregunta ObtenerPregunta(E_Usuario actual, E_PartidaEnCurso partida)
        {
            Verificar(actual, partida);
            E_Pregunta q = _preguntas.ObtenerPorId(partida.IdsPreguntas[partida.Indice]);
            if (partida.InicioPregunta == default) partida.InicioPregunta = DateTime.Now; // el reloj arranca la primera vez que se muestra

            var opciones = q.Opciones.Select(o => new E_Opcion { Id = o.Id, IdPregunta = o.IdPregunta, DsTexto = o.DsTexto, NuEsCorrecta = false }).ToList();
            if (q.DsTipo == TiposPregunta.OpcionMultiple)
            {
                var azar = new Random(partida.IdPartida * 1000 + q.Id); // misma semilla para que no cambie el orden al refrescar
                opciones = opciones.OrderBy(o => azar.Next()).ToList();
            }
            return new E_Pregunta { Id = q.Id, DsTipo = q.DsTipo, DsEnunciado = q.DsEnunciado, NuPuntos = q.NuPuntos, NuSegundos = q.NuSegundos, Opciones = opciones };
        }

        // el tiempo restante lo manda el servidor y asi refrescar la pagina no lo reinicia
        public int SegundosRestantes(E_PartidaEnCurso partida, E_Pregunta pregunta)
        {
            int pasados = (int)(DateTime.Now - partida.InicioPregunta).TotalSeconds;
            return Math.Max(0, pregunta.NuSegundos - pasados);
        }

        public E_RespuestaResultado Responder(E_Usuario actual, E_PartidaEnCurso partida, int? idOpcion)
        {
            Verificar(actual, partida);
            if (partida.EsperandoSiguiente) throw new InvalidOperationException("Esta pregunta ya fue respondida");
            if (partida.InicioPregunta == default) throw new InvalidOperationException("La pregunta no se ha mostrado");

            E_Pregunta q = _preguntas.ObtenerPorId(partida.IdsPreguntas[partida.Indice]);
            double pasados = (DateTime.Now - partida.InicioPregunta).TotalSeconds;
            bool agotado = !idOpcion.HasValue || pasados > q.NuSegundos + SegundosDeGracia; // llegar tarde cuenta como tiempo agotado

            E_Opcion elegida = null;
            if (idOpcion.HasValue)
            {
                elegida = q.Opciones.Find(o => o.Id == idOpcion.Value);
                if (elegida == null) throw new ArgumentException("La opción no es válida");
            }

            bool correcta = !agotado && elegida.NuEsCorrecta;
            int segundos = (int)Math.Min(Math.Ceiling(pasados), q.NuSegundos);
            E_Opcion buena = q.Opciones.Find(o => o.NuEsCorrecta);
            _datos.RegistrarRespuesta(partida.IdPartida, q.Id, agotado ? (int?)null : idOpcion, correcta, segundos);

            var resultado = new E_RespuestaResultado { Correcta = correcta, TiempoAgotado = agotado, IdOpcionCorrecta = buena.Id, TextoCorrecta = buena.DsTexto, PuntosGanados = correcta ? q.NuPuntos : 0, Segundos = segundos };
            partida.Ultima = resultado;
            partida.EsperandoSiguiente = true;
            return resultado;
        }

        // pasa a la siguiente pregunta y devuelve true si la partida ya termino
        public bool Avanzar(E_Usuario actual, E_PartidaEnCurso partida)
        {
            Verificar(actual, partida);
            if (!partida.EsperandoSiguiente) throw new InvalidOperationException("Primero responde la pregunta");

            bool ultima = partida.Indice + 1 >= partida.Total;
            if (ultima) _datos.FinalizarPartida(partida.IdPartida); // si falla no se cambia nada y puede reintentar
            partida.Indice++;
            partida.EsperandoSiguiente = false;
            partida.Ultima = null;
            partida.InicioPregunta = default;
            return ultima;
        }

        public E_ResultadoPartida ObtenerResultado(E_Usuario actual, int idPartida)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            return _datos.ObtenerResultado(idPartida, actual.Id); // el sp solo devuelve partidas de ese usuario
        }

        public List<E_RankingItem> Ranking(E_Usuario actual, int? idTema)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            List<E_RankingItem> lista = _datos.Ranking(idTema);
            for (int i = 0; i < lista.Count; i++) lista[i].Posicion = i + 1;
            return lista;
        }

        public E_ResumenJugador ObtenerResumen(E_Usuario actual)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            return _datos.ObtenerResumen(actual.Id);
        }

        public List<E_Premio> ListarPremiosGanados(E_Usuario actual)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            return _datos.ListarPremiosGanados(actual.Id);
        }

        // la partida de la sesion tiene que ser del usuario que la usa
        private static void Verificar(E_Usuario actual, E_PartidaEnCurso partida)
        {
            if (actual == null || partida == null || partida.IdUsuario != actual.Id) throw new UnauthorizedAccessException("La partida no es válida");
            if (partida.Indice >= partida.Total) throw new InvalidOperationException("La partida ya terminó");
        }
    }
}