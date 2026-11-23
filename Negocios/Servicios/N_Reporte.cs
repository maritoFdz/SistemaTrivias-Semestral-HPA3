using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Reporte : IReporteService
    {
        private readonly D_Reporte _datos;

        public N_Reporte() : this(new D_Reporte()) { }

        public N_Reporte(D_Reporte datos) { _datos = datos; }

        public E_ReporteResumen ObtenerResumen(E_Usuario actual)
        {
            Verificar(actual);
            return _datos.ObtenerResumen();
        }

        public List<E_DistribucionNivel> ObtenerDistribucion(E_Usuario actual)
        {
            Verificar(actual);
            return _datos.ObtenerDistribucion();
        }

        public List<E_AvanceJugador> ObtenerAvance(E_Usuario actual)
        {
            Verificar(actual);
            return _datos.ObtenerAvance();
        }

        // arma las tres hojas del reporte: resumen, distribucion por nivel y avance de cada jugador
        public byte[] ExportarExcel(E_Usuario actual)
        {
            E_ReporteResumen r = ObtenerResumen(actual);
            List<E_DistribucionNivel> dist = ObtenerDistribucion(actual);
            List<E_AvanceJugador> avance = ObtenerAvance(actual);

            var resumen = new HojaExcel { Nombre = "Resumen", PrimeraColumnaNegrita = true, Anchos = new[] { 38.0, 22.0 } };
            resumen.Filas.Add(new object[] { "Jugadores registrados", r.NuJugadoresRegistrados });
            resumen.Filas.Add(new object[] { "Jugadores que han jugado", r.NuJugadoresActivos });
            resumen.Filas.Add(new object[] { "Total de partidas", r.NuPartidas });
            resumen.Filas.Add(new object[] { "Partidas jugadas por QR", r.NuPartidasQr });
            resumen.Filas.Add(new object[] { "Promedio de puntuación por partida", r.NuPromedioPuntos });
            resumen.Filas.Add(new object[] { "Tema más popular", r.DsTemaPopular == null ? "Sin partidas" : r.DsTemaPopular + " (" + r.NuPartidasTemaPopular + " partidas)" });
            resumen.Filas.Add(new object[] { "Tiempo promedio por respuesta (s)", r.NuSegPromRespuesta });

            var distribucion = new HojaExcel { Nombre = "Distribución por nivel", Encabezados = new[] { "Nivel", "Jugadores" }, Anchos = new[] { 24.0, 14.0 } };
            foreach (E_DistribucionNivel d in dist) distribucion.Filas.Add(new object[] { d.DsNombre, d.NuJugadores });
            distribucion.Filas.Add(new object[] { "Sin jugar", r.NuJugadoresSinJugar });

            var hojaAvance = new HojaExcel
            {
                Nombre = "Avance por jugador",
                Anchos = new[] { 26.0, 30.0, 18.0, 16.0, 12.0, 11.0, 10.0, 10.0, 18.0, 16.0, 18.0 },
                Encabezados = new[] { "Jugador", "Correo", "Tema", "Nivel más alto", "Niveles aprobados", "Avance %", "Puntos", "Partidas", "Tiempo promedio por respuesta (s)", "Tiempo total jugado (s)", "Tiempo entre niveles (s)" }
            };
            foreach (E_AvanceJugador a in avance)
                hojaAvance.Filas.Add(new object[] { a.DsNombre, a.DsCorreo, a.DsNombreTema, a.DsNivelMaximo, a.NuNivelesAprobados + " de " + a.NuTotalNiveles, a.NuAvance, a.NuPuntos, a.NuPartidas, a.NuSegPromRespuesta, a.NuSegTotal, a.NuSegEntreNiveles });

            return ExcelSimple.Crear(new List<HojaExcel> { resumen, distribucion, hojaAvance });
        }

        private static void Verificar(E_Usuario actual)
        {
            if (actual == null || (actual.DsRol != Roles.Admin && actual.DsRol != Roles.Operativo)) throw new UnauthorizedAccessException("No tiene permiso para ver los reportes");
        }
    }
}