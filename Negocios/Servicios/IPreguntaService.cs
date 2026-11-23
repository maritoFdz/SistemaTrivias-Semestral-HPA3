using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface IPreguntaService
    {
        List<E_Nivel> ListarNiveles();
        List<E_Pregunta> Listar();
        E_Pregunta ObtenerPorId(int id);
        void Registrar(E_Usuario actual, E_Pregunta nueva);
        void Actualizar(E_Usuario actual, E_Pregunta editada);
        void CambiarEstado(E_Usuario actual, int id);
    }
}