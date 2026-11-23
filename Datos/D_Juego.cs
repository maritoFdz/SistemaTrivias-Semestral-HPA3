using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    // los metodos son virtual para poder probar negocios con datos falsos
    public class D_Juego
    {
        public virtual List<E_TemaProgreso> ListarTemas(int idUsuario)
        {
            var lista = new List<E_TemaProgreso>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_juego_temas", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_TemaProgreso
                    {
                        Id = Num(r, "id"),
                        DsNombre = r.GetString("dsNombre"),
                        DsDescripcion = Texto(r, "dsDescripcion"),
                        NuNiveles = Num(r, "nuNiveles"),
                        NuAprobados = Num(r, "nuAprobados"),
                        NuPuntos = Num(r, "nuPuntos"),
                        NuPreguntas = Num(r, "nuPreguntas")
                    });
            }
            return lista;
        }

        public virtual List<E_NivelJuego> ListarNiveles(int idUsuario, int idTema)
        {
            var lista = new List<E_NivelJuego>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_juego_niveles", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = idTema;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_NivelJuego
                    {
                        IdNivel = Num(r, "id"),
                        DsNombre = r.GetString("dsNombre"),
                        NuOrden = Num(r, "nuOrden"),
                        NuPorcentajeAprobacion = Num(r, "nuPorcentajeAprobacion"),
                        NuPreguntas = Num(r, "nuPreguntas"),
                        Aprobado = Num(r, "nuAprobado") == 1,
                        NuMejorPorcentaje = Convert.ToDecimal(r["nuMejorPorcentaje"]),
                        NuIntentos = Num(r, "nuIntentos"),
                        IdPremio = Num(r, "idPremio"),
                        DsPremioNombre = Texto(r, "dsPremioNombre"),
                        DsPremioImagen = Texto(r, "dsPremioImagen"),
                        NuPremioPuntos = Num(r, "nuPremioPuntos"),
                        PremioGanado = Num(r, "nuPremioGanado") == 1
                    });
            }
            return lista;
        }

        public virtual List<int> SortearPreguntas(int idTema, int idNivel, int cantidad)
        {
            var ids = new List<int>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_juego_sortear", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = idTema;
                cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = idNivel;
                cmd.Parameters.Add("p_cantidad", MySqlDbType.Int32).Value = cantidad;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) ids.Add(r.GetInt32("id"));
            }
            return ids;
        }

        public virtual int IniciarPartida(int idUsuario, int idTema, int idNivel, int total)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_partida_iniciar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                    cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = idTema;
                    cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = idNivel;
                    cmd.Parameters.Add("p_total", MySqlDbType.Int32).Value = total;
                    cn.Open();
                    using (MySqlDataReader r = cmd.ExecuteReader()) { r.Read(); return r.GetInt32("id"); }
                }
            }
            catch (MySqlException ex) when (ex.Number == 1644) { throw new InvalidOperationException("Debes aprobar el nivel anterior para jugar este"); } // el signal del sp
        }

        // marca la partida como jugada por qr
        public virtual void AsignarSetQr(int idPartida, int idUsuario, int idSetQr)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_setqr_asignar_partida", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idPartida", MySqlDbType.Int32).Value = idPartida;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cmd.Parameters.Add("p_idSetQr", MySqlDbType.Int32).Value = idSetQr;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public virtual void RegistrarRespuesta(int idPartida, int idPregunta, int? idOpcion, bool correcta, int segundos)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_respuesta_registrar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idPartida", MySqlDbType.Int32).Value = idPartida;
                cmd.Parameters.Add("p_idPregunta", MySqlDbType.Int32).Value = idPregunta;
                cmd.Parameters.Add("p_idOpcion", MySqlDbType.Int32).Value = (object)idOpcion ?? DBNull.Value; // null si se acabo el tiempo
                cmd.Parameters.Add("p_correcta", MySqlDbType.Int32).Value = correcta ? 1 : 0;
                cmd.Parameters.Add("p_segundos", MySqlDbType.Int32).Value = segundos;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public virtual void FinalizarPartida(int idPartida)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_partida_finalizar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_idPartida", MySqlDbType.Int32).Value = idPartida;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1644) { throw new InvalidOperationException("La partida no se puede cerrar"); }
        }

        public virtual E_ResultadoPartida ObtenerResultado(int idPartida, int idUsuario)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_partida_resultado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idPartida", MySqlDbType.Int32).Value = idPartida;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return null;
                    return new E_ResultadoPartida
                    {
                        Id = Num(r, "id"),
                        IdTema = Num(r, "idTema"),
                        IdNivel = Num(r, "idNivel"),
                        DsNombreTema = r.GetString("dsNombreTema"),
                        DsNombreNivel = r.GetString("dsNombreNivel"),
                        NuTotalPreguntas = Num(r, "nuTotalPreguntas"),
                        NuAciertos = Num(r, "nuAciertos"),
                        NuPuntos = Num(r, "nuPuntos"),
                        NuPorcentaje = Convert.ToDecimal(r["nuPorcentaje"]),
                        Aprobado = Num(r, "nuAprobado") == 1,
                        NuSegundosTotal = Num(r, "nuSegundosTotal"),
                        NuPorcentajeAprobacion = Num(r, "nuPorcentajeAprobacion"),
                        IdSiguienteNivel = Num(r, "idSiguienteNivel"),
                        DsMensajeResultado = Texto(r, "dsMensajeResultado"),
                        DsImagenResultado = Texto(r, "dsImagenResultado"),
                        IdPremio = Num(r, "idPremio"),
                        DsPremioNombre = Texto(r, "dsPremioNombre"),
                        DsPremioImagen = Texto(r, "dsPremioImagen"),
                        NuPremioPuntos = Num(r, "nuPremioPuntos")
                    };
                }
            }
        }

        public virtual List<E_RankingItem> Ranking(int? idTema)
        {
            var lista = new List<E_RankingItem>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_ranking", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = (object)idTema ?? DBNull.Value; // null cuenta todos los temas
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_RankingItem
                    {
                        IdUsuario = Num(r, "idUsuario"),
                        DsNombre = r.GetString("dsNombre"),
                        DsRutaAvatar = Texto(r, "dsRutaAvatar"),
                        NuPuntos = Num(r, "nuPuntos"),
                        NuNivelesAprobados = Num(r, "nuNivelesAprobados"),
                        NuPremios = Num(r, "nuPremios")
                    });
            }
            return lista;
        }

        public virtual E_ResumenJugador ObtenerResumen(int idUsuario)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_juego_resumen", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return new E_ResumenJugador();
                    return new E_ResumenJugador { NuPuntos = Num(r, "nuPuntos"), NuPartidas = Num(r, "nuPartidas"), NuNivelesAprobados = Num(r, "nuNivelesAprobados"), NuPremios = Num(r, "nuPremios") };
                }
            }
        }

        public virtual List<E_Premio> ListarPremiosGanados(int idUsuario)
        {
            var lista = new List<E_Premio>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_premios_usuario", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_Premio
                    {
                        Id = Num(r, "id"),
                        IdTema = Num(r, "idTema"),
                        IdNivel = Num(r, "idNivel"),
                        DsNombre = r.GetString("dsNombre"),
                        DsDescripcion = Texto(r, "dsDescripcion"),
                        DsRutaImagen = r.GetString("dsRutaImagen"),
                        NuPuntos = Num(r, "nuPuntos"),
                        DsEstado = r.GetString("dsEstado"),
                        DsNombreTema = r.GetString("dsNombreTema"),
                        DsNombreNivel = r.GetString("dsNombreNivel")
                    });
            }
            return lista;
        }

        // los exists y sum de mysql llegan como long o decimal y asi se leen todos igual
        private static int Num(MySqlDataReader r, string col) { return Convert.ToInt32(r[col]); }

        private static string Texto(MySqlDataReader r, string col) { return r.IsDBNull(r.GetOrdinal(col)) ? null : r.GetString(col); }
    }
}