using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface IPremioService
    {
        List<E_Premio> Listar();
        E_Premio ObtenerPorId(int id);
        void Registrar(E_Usuario actual, E_Premio nuevo, byte[] imagen, string carpetaFisica);
        void Actualizar(E_Usuario actual, E_Premio editado, byte[] imagenNueva, string carpetaFisica);
        void CambiarEstado(E_Usuario actual, int id);
    }
}