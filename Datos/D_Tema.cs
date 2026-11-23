using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Tema
    {
        public List<E_Tema> Listar()
        {
            var lista = new List<E_Tema>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_tema_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public E_Tema ObtenerPorId(int id)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_tema_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        public void Registrar(E_Tema t, string creador)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_tema_registrar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 60).Value = t.DsNombre;
                    cmd.Parameters.Add("p_descripcion", MySqlDbType.VarChar, 255).Value = (object)t.DsDescripcion ?? DBNull.Value;
                    cmd.Parameters.Add("p_creador", MySqlDbType.VarChar, 100).Value = creador;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw new InvalidOperationException("Ya existe un tema con ese nombre"); }
        }

        public void Actualizar(E_Tema t, string modificador)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_tema_actualizar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = t.Id;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 60).Value = t.DsNombre;
                    cmd.Parameters.Add("p_descripcion", MySqlDbType.VarChar, 255).Value = (object)t.DsDescripcion ?? DBNull.Value;
                    cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw new InvalidOperationException("Ya existe un tema con ese nombre"); }
        }

        public void CambiarEstado(int id, string estado, string modificador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_tema_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static E_Tema Leer(MySqlDataReader r)
        {
            return new E_Tema
            {
                Id = r.GetInt32("id"),
                DsNombre = r.GetString("dsNombre"),
                DsEstado = r.GetString("dsEstado"),
                DsDescripcion = r.IsDBNull(r.GetOrdinal("dsDescripcion")) ? null : r.GetString("dsDescripcion")
            };
        }
    }
}