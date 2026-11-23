using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Usuario
    {
        public E_Usuario ObtenerPorCorreo(string correo)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_login", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_correo", MySqlDbType.VarChar, 100).Value = correo;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return null;

                    return new E_Usuario { Id = r.GetInt32("id"), DsCedula = r.GetString("dsCedula"), DsNombre = r.GetString("dsNombre"), DsCorreo = r.GetString("dsCorreo"),
                        DsPassword = r.GetString("dsPassword"), DsRol = r.GetString("dsRol"), DsEstado = r.GetString("dsEstado"), IdAvatar = r.IsDBNull(r.GetOrdinal("idAvatar")) ? (int?)null : r.GetInt32("idAvatar") };
                }
            }
        }

        public List<E_Usuario> Listar()
        {
            var lista = new List<E_Usuario>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_usuario_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public E_Usuario ObtenerPorId(int id)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_usuario_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        public void Registrar(E_Usuario u, string hash, string creador)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_usuario_registrar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_cedula", MySqlDbType.VarChar, 20).Value = u.DsCedula;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 100).Value = u.DsNombre;
                    cmd.Parameters.Add("p_correo", MySqlDbType.VarChar, 100).Value = u.DsCorreo;
                    cmd.Parameters.Add("p_hash", MySqlDbType.VarChar, 255).Value = hash;
                    cmd.Parameters.Add("p_rol", MySqlDbType.VarChar, 10).Value = u.DsRol;
                    cmd.Parameters.Add("p_creador", MySqlDbType.VarChar, 100).Value = creador;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw Duplicado(ex); }
        }

        public void Actualizar(E_Usuario u, string hash, string modificador)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_usuario_actualizar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = u.Id;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 100).Value = u.DsNombre;
                    cmd.Parameters.Add("p_correo", MySqlDbType.VarChar, 100).Value = u.DsCorreo;
                    cmd.Parameters.Add("p_rol", MySqlDbType.VarChar, 10).Value = u.DsRol;
                    cmd.Parameters.Add("p_hash", MySqlDbType.VarChar, 255).Value = (object)hash ?? DBNull.Value;
                    cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw Duplicado(ex); }
        }

        public void CambiarEstado(int id, string estado, string modificador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_usuario_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // convierte una fila en un e usuario
        private static E_Usuario Leer(MySqlDataReader r)
        {
            return new E_Usuario { Id = r.GetInt32("id"), DsCedula = r.GetString("dsCedula"), DsNombre = r.GetString("dsNombre"),
                DsCorreo = r.GetString("dsCorreo"), DsRol = r.GetString("dsRol"), DsEstado = r.GetString("dsEstado"), IdAvatar = r.IsDBNull(r.GetOrdinal("idAvatar")) ? (int?)null : r.GetInt32("idAvatar")};
        }

        // el error 1062
        private static InvalidOperationException Duplicado(MySqlException ex)
        {
            return new InvalidOperationException(ex.Message.Contains("dsCedula") ? "Ya existe un usuario con esa cédula" : "Ya existe un usuario con ese correo", ex);
        }
    }
}