namespace Negocios.Seguridad
{
    public interface IVerificarHashService
    {
        bool Verificar(string textoPlano, string hashAlmacenado);
    }
}