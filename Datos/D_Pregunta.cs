using System;
using System.Collections.Generic;
using System.Data;
using MySql.Data.MySqlClient;
using Entidades;

namespace Datos
{
    public class D_Pregunta
    {
        public List<E_Nivel> ListarNiveles()
        {
            var lista = new List<E_Nivel>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_nivel_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_Nivel { Id = r.GetInt32("id"), DsNombre = r.GetString("dsNombre"), NuOrden = r.GetInt32("nuOrden"), NuPorcentajeAprobacion = r.GetInt32("nuPorcentajeAprobacion") });
            }
            return lista;
        }

        public List<E_Pregunta> Listar(int? idTema, int? idNivel)
        {
            var lista = new List<E_Pregunta>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_pregunta_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = (object)idTema ?? DBNull.Value; // null trae todas
                cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = (object)idNivel ?? DBNull.Value;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) while (r.Read()) lista.Add(Leer(r));
            }
            return lista;
        }

        public E_Pregunta ObtenerPorId(int id)
        {
            E_Pregunta p;
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_pregunta_obtener", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader()) p = r.Read() ? Leer(r) : null;
            }
            if (p != null) p.Opciones = ListarOpciones(id);
            return p;
        }

        public void Registrar(E_Pregunta p, string creador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_pregunta_registrar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = p.IdTema;
                cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = p.IdNivel;
                cmd.Parameters.Add("p_tipo", MySqlDbType.VarChar, 20).Value = p.DsTipo;
                cmd.Parameters.Add("p_enunciado", MySqlDbType.VarChar, 500).Value = p.DsEnunciado;
                cmd.Parameters.Add("p_puntos", MySqlDbType.Int32).Value = p.NuPuntos;
                cmd.Parameters.Add("p_segundos", MySqlDbType.Int32).Value = p.NuSegundos;
                PonerOpciones(cmd, p);
                cmd.Parameters.Add("p_creador", MySqlDbType.VarChar, 100).Value = creador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void Actualizar(E_Pregunta p, string modificador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_pregunta_actualizar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = p.Id;
                cmd.Parameters.Add("p_idTema", MySqlDbType.Int32).Value = p.IdTema;
                cmd.Parameters.Add("p_idNivel", MySqlDbType.Int32).Value = p.IdNivel;
                cmd.Parameters.Add("p_enunciado", MySqlDbType.VarChar, 500).Value = p.DsEnunciado;
                cmd.Parameters.Add("p_puntos", MySqlDbType.Int32).Value = p.NuPuntos;
                cmd.Parameters.Add("p_segundos", MySqlDbType.Int32).Value = p.NuSegundos;
                PonerOpciones(cmd, p);
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void CambiarEstado(int id, string estado, string modificador)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_pregunta_cambiar_estado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_id", MySqlDbType.Int32).Value = id;
                cmd.Parameters.Add("p_estado", MySqlDbType.VarChar, 1).Value = estado;
                cmd.Parameters.Add("p_modificador", MySqlDbType.VarChar, 100).Value = modificador;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private List<E_Opcion> ListarOpciones(int idPregunta)
        {
            var lista = new List<E_Opcion>();
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_opcion_listar", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_idPregunta", MySqlDbType.Int32).Value = idPregunta;
                cn.Open();
                using (MySqlDataReader r = cmd.ExecuteReader())
                    while (r.Read()) lista.Add(new E_Opcion { Id = r.GetInt32("id"), IdPregunta = idPregunta, DsTexto = r.GetString("dsTexto"), NuEsCorrecta = Convert.ToBoolean(r["nuEsCorrecta"]) });
            }
            return lista;
        }

        // manda las opciones como op1 a op4 y la posicion de la correcta
        private static void PonerOpciones(MySqlCommand cmd, E_Pregunta p)
        {
            int correcta = 0;
            for (int i = 0; i < 4; i++)
            {
                string texto = i < p.Opciones.Count ? p.Opciones[i].DsTexto : null; // verdadero o falso solo usa 2
                if (i < p.Opciones.Count && p.Opciones[i].NuEsCorrecta) correcta = i + 1;
                cmd.Parameters.Add("p_op" + (i + 1), MySqlDbType.VarChar, 255).Value = (object)texto ?? DBNull.Value;
            }
            cmd.Parameters.Add("p_correcta", MySqlDbType.Int32).Value = correcta;
        }

        private static E_Pregunta Leer(MySqlDataReader r)
        {
            return new E_Pregunta
            {
                Id = r.GetInt32("id"),
                IdTema = r.GetInt32("idTema"),
                IdNivel = r.GetInt32("idNivel"),
                DsTipo = r.GetString("dsTipo"),
                DsEnunciado = r.GetString("dsEnunciado"),
                NuPuntos = r.GetInt32("nuPuntos"),
                NuSegundos = r.GetInt32("nuSegundos"),
                DsEstado = r.GetString("dsEstado"),
                DsNombreTema = r.GetString("dsNombreTema"),
                DsNombreNivel = r.GetString("dsNombreNivel")
            };
        }
    }
}