using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface IUsuarioService
    {
        E_Usuario Login(string correo, string password);
        void RegistrarPublico(E_Usuario nuevo, string password);
        List<E_Usuario> Listar();
        E_Usuario ObtenerPorId(int id);
        void Registrar(E_Usuario actual, E_Usuario nuevo, string password);
        void Actualizar(E_Usuario actual, E_Usuario editado, string passwordNuevo);
        void CambiarEstado(E_Usuario actual, int id);
    }
}