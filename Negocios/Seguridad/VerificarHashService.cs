using System;
using System.Security.Cryptography;

namespace Negocios.Seguridad
{
    public sealed class VerificarHashService : IVerificarHashService
    {
        public bool Verificar(string textoPlano, string hashAlmacenado)
        {
            if (string.IsNullOrEmpty(textoPlano) || string.IsNullOrEmpty(hashAlmacenado)) return false;

            string[] partes = hashAlmacenado.Split('$');
            if (partes.Length != 4 || partes[0] != ParametrosHash.Prefijo) return false;
            if (!int.TryParse(partes[1], out int iteraciones) || iteraciones <= 0) return false;
            byte[] salt, esperado;
            try
            {
                salt = Convert.FromBase64String(partes[2]);
                esperado = Convert.FromBase64String(partes[3]);
            }
            catch (FormatException)
            {
                return false; // por si no pncha
            }

            byte[] calculado;
            using (var kdf = new Rfc2898DeriveBytes(textoPlano, salt, iteraciones, HashAlgorithmName.SHA256))
                calculado = kdf.GetBytes(esperado.Length);
            return IgualesEnTiempoConstante(calculado, esperado);
        }

        // la func constante que explicaba mateo en la charla
        private static bool IgualesEnTiempoConstante(byte[] a, byte[] b)
        {
            if (a.Length != b.Length) return false;
            int diferencia = 0;
            for (int i = 0; i < a.Length; i++) diferencia |= a[i] ^ b[i];
            return diferencia == 0;
        }
    }
}