using System;
using System.Configuration;
using MySql.Data.MySqlClient;

namespace Datos
{
    public static class ConexionBD
    {
        private const string NombreCadena = "TriviasDB";

        public static string CadenaConexion
        {
            get
            {
                ConnectionStringSettings cfg = ConfigurationManager.ConnectionStrings[NombreCadena];
                if (cfg == null || string.IsNullOrWhiteSpace(cfg.ConnectionString))
                    throw new InvalidOperationException("Falta la cadena de conexión '" + NombreCadena + "' en el Web.config.");
                return cfg.ConnectionString;
            }
        }

        public static MySqlConnection Crear()
        {
            return new MySqlConnection(CadenaConexion);
        }
    }
}