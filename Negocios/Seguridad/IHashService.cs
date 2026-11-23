namespace Negocios.Seguridad
{
    public interface IHashService
    {
        string GenerarHash(string textoPlano);
    }
}