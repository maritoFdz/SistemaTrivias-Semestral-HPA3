using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Calificacion
    {
        public virtual void Guardar(E_Calificacion c)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_calif_guardar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = c.IdUsuario;
                    cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = c.IdTema;
                    cmd.Parameters.Add("p_califTema", MySqlDbType.Int32).Value = c.NuCalifTema;
                    cmd.Parameters.Add("p_califApp", MySqlDbType.Int32).Value = c.NuCalifApp;
                    cmd.Parameters.Add("p_sugerido", MySqlDbType.VarChar, 200).Value = (object)c.DsTemaSugerido ?? DBNull.Value;
                    cmd.Parameters.Add("p_comentario", MySqlDbType.VarChar, 500).Value = (object)c.DsComentario ?? DBNull.Value;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1644) { throw new InvalidOperationException(ex.Message); } // los signal del sp traen el mensaje listo
        }

        public virtual E_Calificacion Obtener(int idUsuario, int idTema)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_calif_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = idTema;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return null;
                    return new E_Calificacion
                    {
                        Id = r.GetInt32("id"),
                        IdUsuario = r.GetInt32("idUsuario"),
                        IdTema = r.GetInt32("idTema"),
                        DsNombreTema = r.GetString("dsNombreTema"),
                        NuCalifTema = Convert.ToInt32(r["nuCalifTema"]),
                        NuCalifApp = Convert.ToInt32(r["nuCalifApp"]),
                        DsTemaSugerido = Texto(r, "dsTemaSugerido"),
                        DsComentario = Texto(r, "dsComentario"),
                        DtFecha = r.GetDateTime("dtFecha")
                    };
                }
            }
        }

        public virtual List<E_ResumenCalificacion> Resumen()
        {
            var lista = new List<E_ResumenCalificacion>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_calif_resumen", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_ResumenCalificacion
                    {
                        IdTema = r.GetInt32("idTema"),
                        DsNombreTema = r.GetString("dsNombreTema"),
                        NuCalificaciones = Convert.ToInt32(r["nuCalificaciones"]),
                        NuPromedioTema = Convert.ToDecimal(r["nuPromedioTema"]),
                        NuPromedioApp = Convert.ToDecimal(r["nuPromedioApp"])
                    });
            }
            return lista;
        }

        public virtual List<E_Calificacion> Listar()
        {
            var lista = new List<E_Calificacion>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_calif_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_Calificacion
                    {
                        Id = r.GetInt32("id"),
                        IdUsuario = r.GetInt32("idUsuario"),
                        DsNombreUsuario = r.GetString("dsNombreUsuario"),
                        IdTema = r.GetInt32("idTema"),
                        DsNombreTema = r.GetString("dsNombreTema"),
                        NuCalifTema = Convert.ToInt32(r["nuCalifTema"]),
                        NuCalifApp = Convert.ToInt32(r["nuCalifApp"]),
                        DsTemaSugerido = Texto(r, "dsTemaSugerido"),
                        DsComentario = Texto(r, "dsComentario"),
                        DtFecha = r.GetDateTime("dtFecha")
                    });
            }
            return lista;
        }

        private static string Texto(MySqlDataReader r, string col) { return r.IsDBNull(r.GetOrdinal(col)) ? null : r.GetString(col); }
    }
}