using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface IAvatarService
    {
        List<E_Avatar> Listar(E_Usuario actual);
        E_Avatar ObtenerPorId(E_Usuario actual, int id);
        E_Avatar ObtenerActual(E_Usuario actual);
        void Registrar(E_Usuario actual, E_Avatar nuevo, byte[] imagen, string carpetaFisica);
        void Actualizar(E_Usuario actual, E_Avatar editado, byte[] imagenNueva, string carpetaFisica);
        void CambiarEstado(E_Usuario actual, int id);
        void Usar(E_Usuario actual, int id);
    }
}