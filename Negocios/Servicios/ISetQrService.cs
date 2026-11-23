using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface ISetQrService
    {
        List<E_SetQr> Listar(E_Usuario actual);
        E_SetQr ObtenerPorId(E_Usuario actual, int id);
        E_SetQr ObtenerPorCodigo(string codigo);
        void Registrar(E_Usuario actual, E_SetQr nuevo);
        void Actualizar(E_Usuario actual, E_SetQr editado);
        void CambiarEstado(E_Usuario actual, int id);
        string ConstruirEnlace(string urlBase, string codigo);
        byte[] GenerarQr(E_Usuario actual, string enlace);
    }
}