using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Noticia
    {
        public List<E_Noticia> Listar()
        {
            var lista = new List<E_Noticia>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_noticia_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public List<E_Noticia> ListarPublicas(int cantidad)
        {
            var lista = new List<E_Noticia>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_noticia_publicas", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_cantidad", MySqlDbType.Int32).Value = cantidad;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public E_Noticia ObtenerPorId(int id)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_noticia_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        public void Registrar(E_Noticia n, string creador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_noticia_registrar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_titulo", MySqlDbType.VarChar, 150).Value = n.DsTitulo;
                cmd.Parameters.Add("p_resumen", MySqlDbType.VarChar, 300).Value = n.DsResumen;
                cmd.Parameters.Add("p_contenido", MySqlDbType.Text).Value = n.DsContenido;
                cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = (object)n.DsRutaImagen ?? DBNull.Value;
                cmd.Parameters.Add("p_creador", MySqlDbType.VarChar, 100).Value = creador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void Actualizar(E_Noticia n, string ruta) // ruta null = misma imagen
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_noticia_actualizar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = n.Id;
                cmd.Parameters.Add("p_titulo", MySqlDbType.VarChar, 150).Value = n.DsTitulo;
                cmd.Parameters.Add("p_resumen", MySqlDbType.VarChar, 300).Value = n.DsResumen;
                cmd.Parameters.Add("p_contenido", MySqlDbType.Text).Value = n.DsContenido;
                cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = (object)ruta ?? DBNull.Value;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void CambiarEstado(int id, string estado)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_noticia_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static E_Noticia Leer(MySqlDataReader r)
        {
            return new E_Noticia
            {
                Id = r.GetInt32("id"),
                DsTitulo = r.GetString("dsTitulo"),
                DsResumen = r.GetString("dsResumen"),
                DsContenido = r.GetString("dsContenido"),
                DsRutaImagen = r.IsDBNull(r.GetOrdinal("dsRutaImagen")) ? null : r.GetString("dsRutaImagen"),
                DtPublicacion = r.GetDateTime("dtPublicacion"),
                DsEstado = r.GetString("dsEstado")
            };
        }
    }
}