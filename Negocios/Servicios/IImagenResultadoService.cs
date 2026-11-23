using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface IImagenResultadoService
    {
        List<E_ImagenResultado> Listar();
        E_ImagenResultado ObtenerPorId(int id);
        void Registrar(E_Usuario actual, E_ImagenResultado nueva, byte[] imagen, string carpetaFisica);
        void Actualizar(E_Usuario actual, E_ImagenResultado editada, byte[] imagenNueva, string carpetaFisica);
        void CambiarEstado(E_Usuario actual, int id);
    }
}