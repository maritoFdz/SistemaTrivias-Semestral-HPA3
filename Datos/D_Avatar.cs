using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Avatar
    {
        public List<E_Avatar> Listar(int? idUsuario)
        {
            var lista = new List<E_Avatar>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_avatar_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = (object)idUsuario ?? DBNull.Value; // null trae todos
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public E_Avatar ObtenerPorId(int id) { return UnoPorId("sp_avatar_obtener", "p_id", id); }

        public E_Avatar ObtenerActual(int idUsuario) { return UnoPorId("sp_avatar_actual", "p_idUsuario", idUsuario); }

        public void Registrar(E_Avatar a, string creador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_avatar_registrar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = a.IdUsuario;
                cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 60).Value = a.DsNombre;
                cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = a.DsRutaImagen;
                cmd.Parameters.Add("p_creador", MySqlDbType.VarChar, 100).Value = creador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void Actualizar(E_Avatar a, string ruta, string modificador) // ruta null = misma imagen
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_avatar_actualizar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = a.Id;
                cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 60).Value = a.DsNombre;
                cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = (object)ruta ?? DBNull.Value;
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void CambiarEstado(int id, string estado, string modificador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_avatar_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void Usar(int idUsuario, int idAvatar, string modificador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_avatar_usar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idUsuario", MySqlDbType.Int32).Value = idUsuario;
                cmd.Parameters.Add("p_idAvatar", MySqlDbType.Int32).Value = idAvatar;
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // los de obtener y actual devuelven las mismas columnas
        private E_Avatar UnoPorId(string sp, string parametro, int id)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand(sp, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(parametro, MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        private static E_Avatar Leer(MySqlDataReader r)
        {
            return new E_Avatar
            {
                Id = r.GetInt32("id"),
                IdUsuario = r.GetInt32("idUsuario"),
                DsNombre = r.GetString("dsNombre"),
                DsRutaImagen = r.GetString("dsRutaImagen"),
                DsEstado = r.GetString("dsEstado"),
                DsNombreUsuario = r.GetString("dsNombreUsuario")
            };
        }
    }
}