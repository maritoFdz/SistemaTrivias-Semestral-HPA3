using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_ImagenResultado
    {
        public List<E_ImagenResultado> Listar()
        {
            var lista = new List<E_ImagenResultado>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_imgres_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public E_ImagenResultado ObtenerPorId(int id)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_imgres_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        public void Registrar(E_ImagenResultado i)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_imgres_registrar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_minimo", MySqlDbType.Int32).Value = i.NuPorcentajeMinimo;
                    cmd.Parameters.Add("p_mensaje", MySqlDbType.VarChar, 120).Value = i.DsMensaje;
                    cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = i.DsRutaImagen;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw new InvalidOperationException("Ya existe una imagen para ese porcentaje"); }
        }

        public void Actualizar(E_ImagenResultado i, string ruta) // ruta null = misma imagen
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_imgres_actualizar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = i.Id;
                    cmd.Parameters.Add("p_minimo", MySqlDbType.Int32).Value = i.NuPorcentajeMinimo;
                    cmd.Parameters.Add("p_mensaje", MySqlDbType.VarChar, 120).Value = i.DsMensaje;
                    cmd.Parameters.Add("p_ruta", MySqlDbType.VarChar, 255).Value = (object)ruta ?? DBNull.Value;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1062) { throw new InvalidOperationException("Ya existe una imagen para ese porcentaje"); }
        }

        public void CambiarEstado(int id, string estado)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_imgres_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static E_ImagenResultado Leer(MySqlDataReader r)
        {
            return new E_ImagenResultado
            {
                Id = r.GetInt32("id"),
                NuPorcentajeMinimo = r.GetInt32("nuPorcentajeMinimo"),
                DsMensaje = r.GetString("dsMensaje"),
                DsRutaImagen = r.GetString("dsRutaImagen"),
                DsEstado = r.GetString("dsEstado")
            };
        }
    }
}