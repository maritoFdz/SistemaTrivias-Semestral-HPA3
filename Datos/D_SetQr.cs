using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_SetQr
    {
        public virtual List<E_SetQr> Listar()
        {
            var lista = new List<E_SetQr>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_setqr_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public virtual E_SetQr ObtenerPorId(int id)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_setqr_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        public virtual E_SetQr ObtenerPorCodigo(string codigo)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_setqr_por_codigo", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_codigo", MySqlDbType.VarChar, 36).Value = codigo;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) return r.Read() ? Leer(r) : null;
            }
        }

        public virtual void Registrar(E_SetQr s, string creador)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_setqr_registrar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_codigo", MySqlDbType.VarChar, 36).Value = s.DsCodigo;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 100).Value = s.DsNombre;
                    cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = s.IdTema;
                    cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = s.IdNivel;
                    cmd.Parameters.Add("p_cantidad", MySqlDbType.Int32).Value = s.NuCantidadPreguntas;
                    cmd.Parameters.Add("p_creador", MySqlDbType.VarChar, 100).Value = creador;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1452) { throw new InvalidOperationException("El tema o el nivel no existe"); } // llave foranea
        }

        public virtual void Actualizar(E_SetQr s)
        {
            try
            {
                using (MySqlConnection cn = ConexionBD.Crear())
                using (var cmd = new MySqlCommand("sp_setqr_actualizar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = s.Id;
                    cmd.Parameters.Add("p_nombre", MySqlDbType.VarChar, 100).Value = s.DsNombre;
                    cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = s.IdTema;
                    cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = s.IdNivel;
                    cmd.Parameters.Add("p_cantidad", MySqlDbType.Int32).Value = s.NuCantidadPreguntas;
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException ex) when (ex.Number == 1452) { throw new InvalidOperationException("El tema o el nivel no existe"); }
        }

        public virtual void CambiarEstado(int id, string estado)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_setqr_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static E_SetQr Leer(MySqlDataReader r)
        {
            return new E_SetQr
            {
                Id = r.GetInt32("id"),
                DsCodigo = r.GetString("dsCodigo"),
                DsNombre = r.GetString("dsNombre"),
                IdTema = r.GetInt32("idTema"),
                IdNivel = r.GetInt32("idNivel"),
                NuCantidadPreguntas = Convert.ToInt32(r["nuCantidadPreguntas"]),
                DsEstado = r.GetString("dsEstado"),
                DsNombreTema = r.GetString("dsNombreTema"),
                DsNombreNivel = r.GetString("dsNombreNivel"),
                NuPartidas = Convert.ToInt32(r["nuPartidas"])
            };
        }
    }
}