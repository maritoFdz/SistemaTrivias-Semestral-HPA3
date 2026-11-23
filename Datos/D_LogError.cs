using System.Data;
using MySql.Data.MySqlClient;

namespace Datos
{
    public class D_LogError
    {
        public void Insertar(string origen, string mensaje, string detalle, string usuario)
        {
            using (MySqlConnection cn = ConexionBD.Crear())
            using (var cmd = new MySqlCommand("sp_log_error", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("p_origen", MySqlDbType.VarChar, 100).Value = origen;
                cmd.Parameters.Add("p_mensaje", MySqlDbType.VarChar, 500).Value = mensaje;
                cmd.Parameters.Add("p_detalle", MySqlDbType.Text).Value = detalle;
                cmd.Parameters.Add("p_usuario", MySqlDbType.VarChar, 100).Value = usuario;
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}