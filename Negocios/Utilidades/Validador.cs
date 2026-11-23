using System.Net;
using System.Text;
using System.Text.RegularExpressions;

namespace Negocios.Utilidades
{
    public static class Validador
    {
        private const int LargoMinimoPassword = 6;

        private static readonly Regex RxCorreo = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$", RegexOptions.Compiled);

        // esto es lo de las expre regu para que guarde las cedulas con el formato de panama ahi metimos las cedulas E tb para que alejadnro participe XD
        private static readonly Regex RxCedula = new Regex(@"^(?:\d{1,2}|PE|E|N|PI|AV)-\d{1,4}-\d{1,6}$", RegexOptions.Compiled | RegexOptions.IgnoreCase);

        // limpia lo que escribe el usuario
        public static string Sanitizar(string texto)
        {
            if (string.IsNullOrWhiteSpace(texto))
                return string.Empty;
            var sb = new StringBuilder(texto.Length);
            foreach (char c in texto)
                if (!char.IsControl(c))
                    sb.Append(c);
            return Regex.Replace(sb.ToString().Trim(), @"\s{2,}", " ");
        }

        // esto es pa parsear las peguntas a html
        public static string CodificarHtml(string texto)
        {
            return WebUtility.HtmlEncode(texto ?? string.Empty);
        }

        public static bool EsCorreoValido(string correo)
        {
            return !string.IsNullOrEmpty(correo) && correo.Length <= 100 && RxCorreo.IsMatch(correo);
        }

        public static bool EsCedulaValida(string cedula)
        {
            return !string.IsNullOrEmpty(cedula) && cedula.Length <= 20 && RxCedula.IsMatch(cedula);
        }

        public static bool EsPasswordValida(string password)
        {
            return !string.IsNullOrEmpty(password) && password.Length >= LargoMinimoPassword;
        }

        public static bool LargoEntre(string texto, int minimo, int maximo)
        {
            int largo = texto == null ? 0 : texto.Length;
            return largo >= minimo && largo <= maximo;
        }
    }
}