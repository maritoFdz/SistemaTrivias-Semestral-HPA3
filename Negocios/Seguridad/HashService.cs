using System;
using System.Security.Cryptography;

namespace Negocios.Seguridad
{
    public sealed class HashService : IHashService
    {
        public string GenerarHash(string textoPlano)
        {
            if (string.IsNullOrEmpty(textoPlano))
                throw new ArgumentException("La contraseña no puede estar vacía");

            // esto es imp que se ponga para cada contrasena NO LO BORREN PREGUNTEN CUALQUIE DUDA
            byte[] salt = new byte[ParametrosHash.TamanoSalt];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(salt);
            byte[] hash;
            using (var kdf = new Rfc2898DeriveBytes(textoPlano, salt, ParametrosHash.Iteraciones, HashAlgorithmName.SHA256))
                hash = kdf.GetBytes(ParametrosHash.TamanoHash);
            // esto yo lo puese para guardar PBKDF2$iteraciones$salt$hash
            return string.Join("$", ParametrosHash.Prefijo, ParametrosHash.Iteraciones, Convert.ToBase64String(salt), Convert.ToBase64String(hash));
        }
    }
}