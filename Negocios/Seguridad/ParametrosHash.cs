namespace Negocios.Seguridad
{
    internal static class ParametrosHash // esto son constantes pq ya varias veces he escrito mal el cosito a mano
    {
        public const string Prefijo = "PBKDF2";
        public const int TamanoSalt = 16;
        public const int TamanoHash = 32;
        public const int Iteraciones = 100000;
    }
}