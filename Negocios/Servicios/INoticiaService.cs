using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface INoticiaService
    {
        List<E_Noticia> Listar(E_Usuario actual);
        List<E_Noticia> ListarPublicas(int cantidad);
        E_Noticia ObtenerPorId(E_Usuario actual, int id);
        void Registrar(E_Usuario actual, E_Noticia nueva, byte[] imagen, string carpetaFisica);
        void Actualizar(E_Usuario actual, E_Noticia editada, byte[] imagenNueva, string carpetaFisica);
        void CambiarEstado(E_Usuario actual, int id);
    }
}