using System;
using System.Collections.Generic;
using System.Linq;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Pregunta : IPreguntaService
    {
        private readonly D_Pregunta _datos;

        public N_Pregunta() : this(new D_Pregunta()) { }

        public N_Pregunta(D_Pregunta datos) { _datos = datos; }

        public List<E_Nivel> ListarNiveles() { return _datos.ListarNiveles(); }

        public List<E_Pregunta> Listar() { return _datos.Listar(null, null); }

        public E_Pregunta ObtenerPorId(int id) { return _datos.ObtenerPorId(id); }

        public void Registrar(E_Usuario actual, E_Pregunta nueva)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar preguntas");
            if (nueva.DsTipo != TiposPregunta.OpcionMultiple && nueva.DsTipo != TiposPregunta.VerdaderoFalso) throw new ArgumentException("El tipo de pregunta no es válido");
            Validar(nueva);
            _datos.Registrar(nueva, actual.DsCorreo);
        }

        public void Actualizar(E_Usuario actual, E_Pregunta editada)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar preguntas");
            E_Pregunta original = _datos.ObtenerPorId(editada.Id);
            if (original == null) throw new InvalidOperationException("La pregunta no existe");
            editada.DsTipo = original.DsTipo; // el tipo no se cambia porque cambia la cantidad de opciones
            Validar(editada);
            _datos.Actualizar(editada, actual.DsCorreo);
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar preguntas");
            E_Pregunta p = _datos.ObtenerPorId(id);
            if (p == null) throw new InvalidOperationException("La pregunta no existe");
            _datos.CambiarEstado(id, p.DsEstado == "1" ? "0" : "1", actual.DsCorreo);
        }

        private static bool PuedeAdministrar(E_Usuario actual) { return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo); }

        private static void Validar(E_Pregunta p)
        {
            p.DsEnunciado = Validador.Sanitizar(p.DsEnunciado);
            if (p.IdTema <= 0) throw new ArgumentException("Seleccione un tema");
            if (p.IdNivel <= 0) throw new ArgumentException("Seleccione un nivel");
            if (!Validador.LargoEntre(p.DsEnunciado, 5, 500)) throw new ArgumentException("El enunciado debe tener entre 5 y 500 caracteres");
            if (p.NuPuntos < 1 || p.NuPuntos > 1000) throw new ArgumentException("Los puntos deben estar entre 1 y 1000");
            if (p.NuSegundos < 5 || p.NuSegundos > 300) throw new ArgumentException("El tiempo debe estar entre 5 y 300 segundos");
            if (p.Opciones == null || p.Opciones.Count(o => o.NuEsCorrecta) != 1) throw new ArgumentException("Marque una sola opción como correcta");

            if (p.DsTipo == TiposPregunta.VerdaderoFalso)
            {
                if (p.Opciones.Count != 2) throw new ArgumentException("Verdadero o falso lleva dos opciones");
                p.Opciones[0].DsTexto = "Verdadero"; // los textos son fijos
                p.Opciones[1].DsTexto = "Falso";
                return;
            }

            if (p.Opciones.Count != 4) throw new ArgumentException("La pregunta lleva cuatro opciones");
            foreach (E_Opcion o in p.Opciones)
            {
                o.DsTexto = Validador.Sanitizar(o.DsTexto);
                if (!Validador.LargoEntre(o.DsTexto, 1, 255)) throw new ArgumentException("Cada opción debe tener entre 1 y 255 caracteres");
            }
            if (p.Opciones.Select(o => o.DsTexto.ToLower()).Distinct().Count() != 4) throw new ArgumentException("Las opciones no pueden repetirse");
        }
    }
}