using System;
using System.IO;
using Datos;

namespace Negocios.Utilidades
{
    public static class ManejadorErrores // esto es para lo que dijo la profe de gurar los errores en la BD
    {
        public static void Registrar(string origen, Exception ex, string usuario = null)
        {
            if (ex == null) return;
            string quien = string.IsNullOrWhiteSpace(usuario) ? "anonimo" : usuario;
            try
            {
                new D_LogError().Insertar(
                    Cortar(origen, 100), Cortar(ex.Message, 500), ex.ToString(), Cortar(quien, 100));
            }
            catch
            {
                EscribirEnArchivo(origen, ex, quien);
            }
        }

        private static void EscribirEnArchivo(string origen, Exception ex, string usuario)
        {
            try
            {
                string carpeta = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data");
                Directory.CreateDirectory(carpeta);
                string linea = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " | " + origen + " | " + usuario + " | " + ex + Environment.NewLine;
                File.AppendAllText(Path.Combine(carpeta, "errores.log"), linea);
            }
            catch
            {
                // esto es el caso ya en el que lit no se puede hacer mas nada para que no de error asi que no se puede poner ninguna cosa para hacer
            }
        }

        private static string Cortar(string texto, int max)
        {
            if (string.IsNullOrEmpty(texto)) return string.Empty;
            return texto.Length <= max ? texto : texto.Substring(0, max);
        }
    }
}