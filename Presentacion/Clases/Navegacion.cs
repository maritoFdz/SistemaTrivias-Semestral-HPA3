using System;
using System.Linq;

namespace Presentacion.Clases
{
    public static class Navegacion
    {
        // solo deja pasar rutas internas de la app para que nadie use el returnurl y mande al usuario a otro sitio
        public static string UrlSegura(string url, string porDefecto)
        {
            if (string.IsNullOrEmpty(url) || url.Length > 200) return porDefecto;
            if (!url.StartsWith("/") || url.StartsWith("//") || url.Contains("\\") || url.Contains(":") || url.Any(char.IsControl)) return porDefecto;
            string ruta = url.Split('?')[0];
            if (!ruta.EndsWith(".aspx", StringComparison.OrdinalIgnoreCase)) return porDefecto;
            if (ruta.EndsWith("Login.aspx", StringComparison.OrdinalIgnoreCase)) return porDefecto; // para no dar vueltas en el login
            return url;
        }
    }
}