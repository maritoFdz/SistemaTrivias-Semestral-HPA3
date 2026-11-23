using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface IReporteService
    {
        E_ReporteResumen ObtenerResumen(E_Usuario actual);
        List<E_DistribucionNivel> ObtenerDistribucion(E_Usuario actual);
        List<E_AvanceJugador> ObtenerAvance(E_Usuario actual);
        byte[] ExportarExcel(E_Usuario actual);
    }
}