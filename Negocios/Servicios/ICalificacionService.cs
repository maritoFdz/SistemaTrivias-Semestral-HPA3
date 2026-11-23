using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface ICalificacionService
    {
        void Guardar(E_Usuario actual, E_Calificacion calificacion);
        E_Calificacion Obtener(E_Usuario actual, int idTema);
        List<E_ResumenCalificacion> Resumen(E_Usuario actual);
        List<E_Calificacion> Listar(E_Usuario actual);
    }
}