using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface ITemaService
    {
        List<E_Tema> Listar();
        E_Tema ObtenerPorId(int id);
        void Registrar(E_Usuario actual, E_Tema nuevo);
        void Actualizar(E_Usuario actual, E_Tema editado);
        void CambiarEstado(E_Usuario actual, int id);
    }
}