using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Premio
    {
        public List<E_Premio> Listar()
        {
            var lista = new List<E_Premio>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_premio_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public E_Premio ObtenerPorId(int id)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_premio_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        public void Registrar(E_Premio p, string creador)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_premio_registrar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = p.IdTema;
                    cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = p.IdNivel;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 80).Value = p.DsNombre;
                    cmd.Parameters.Add("p_descripcion", MySqlDbType.VarChar, 255).Value = (object)p.DsDescripcion ?? DBNull.Value;
                    cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = p.DsRutaImagen;
                    cmd.Parameters.Add("p_puntos", MySqlDbType.Int32).Value = p.NuPuntos;
                    cmd.Parameters.Add("p_creador", MySqlDbType.VarChar, 100).Value = creador;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw new InvalidOperationException("Ya existe un premio para ese tema y nivel"); }
        }

        public void Actualizar(E_Premio p, string ruta, string modificador) // ruta null = misma imagen
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_premio_actualizar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = p.Id;
                    cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = p.IdTema;
                    cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = p.IdNivel;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 80).Value = p.DsNombre;
                    cmd.Parameters.Add("p_descripcion", MySqlDbType.VarChar, 255).Value = (object)p.DsDescripcion ?? DBNull.Value;
                    cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = (object)ruta ?? DBNull.Value;
                    cmd.Parameters.Add("p_puntos", MySqlDbType.Int32).Value = p.NuPuntos;
                    cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw new InvalidOperationException("Ya existe un premio para ese tema y nivel"); }
        }

        public void CambiarEstado(int id, string estado, string modificador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_premio_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static E_Premio Leer(MySqlDataReader r)
        {
            return new E_Premio
            {
                Id = r.GetInt32("id"),
                IdTema = r.GetInt32("idTema"),
                IdNivel = r.GetInt32("idNivel"),
                DsNombre = r.GetString("dsNombre"),
                DsDescripcion = r.IsDBNull(r.GetOrdinal("dsDescripcion")) ? null : r.GetString("dsDescripcion"),
                DsRutaImagen = r.GetString("dsRutaImagen"),
                NuPuntos = r.GetInt32("nuPuntos"),
                DsEstado = r.GetString("dsEstado"),
                DsNombreTema = r.GetString("dsNombreTema"),
                DsNombreNivel = r.GetString("dsNombreNivel")
            };
        }
    }
}