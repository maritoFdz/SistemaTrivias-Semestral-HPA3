using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Reporte
    {
        public virtual E_ReporteResumen ObtenerResumen()
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_reporte_resumen", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return new E_ReporteResumen();
                    return new E_ReporteResumen
                    {
                        NuJugadoresRegistrados = Num(r, "nuJugadoresRegistrados"),
                        NuJugadoresActivos = Num(r, "nuJugadoresActivos"),
                        NuJugadoresSinJugar = Num(r, "nuJugadoresSinJugar"),
                        NuPartidas = Num(r, "nuPartidas"),
                        NuPartidasQr = Num(r, "nuPartidasQr"),
                        NuPromedioPuntos = Convert.ToDecimal(r["nuPromedioPuntos"]),
                        DsTemaPopular = r.IsDBNull(r.GetOrdinal("dsTemaPopular")) ? null : r.GetString("dsTemaPopular"),
                        NuPartidasTemaPopular = Num(r, "nuPartidasTemaPopular"),
                        NuSegPromRespuesta = Convert.ToDecimal(r["nuSegPromRespuesta"])
                    };
                }
            }
        }

        public virtual List<E_DistribucionNivel> ObtenerDistribucion()
        {
            var lista = new List<E_DistribucionNivel>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_reporte_distribucion", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_DistribucionNivel { IdNivel = Num(r, "idNivel"), DsNombre = r.GetString("dsNombre"), NuOrden = Num(r, "nuOrden"), NuJugadores = Num(r, "nuJugadores") });
            }
            return lista;
        }

        public virtual List<E_AvanceJugador> ObtenerAvance()
        {
            var lista = new List<E_AvanceJugador>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_reporte_avance", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_AvanceJugador
                    {
                        IdUsuario = Num(r, "idUsuario"),
                        DsNombre = r.GetString("dsNombre"),
                        DsCorreo = r.GetString("dsCorreo"),
                        IdTema = Num(r, "idTema"),
                        DsNombreTema = r.GetString("dsNombreTema"),
                        NuPartidas = Num(r, "nuPartidas"),
                        NuNivelesAprobados = Num(r, "nuNivelesAprobados"),
                        NuTotalNiveles = Num(r, "nuTotalNiveles"),
                        DsNivelMaximo = r.IsDBNull(r.GetOrdinal("dsNivelMaximo")) ? "" : r.GetString("dsNivelMaximo"),
                        NuPuntos = Num(r, "nuPuntos"),
                        NuSegPromRespuesta = Convert.ToDecimal(r["nuSegPromRespuesta"]),
                        NuSegTotal = Num(r, "nuSegTotal"),
                        NuSegEntreNiveles = r.IsDBNull(r.GetOrdinal("nuSegEntreNiveles")) ? (decimal?)null : Convert.ToDecimal(r["nuSegEntreNiveles"])
                    });
            }
            return lista;
        }

        // los count y avg de mysql llegan como long o decimal y asi se leen todos igual
        private static int Num(MySqlDataReader r, string col) { return Convert.ToInt32(r[col]); }
    }
}