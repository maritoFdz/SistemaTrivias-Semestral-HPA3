using System.Collections.Generic;
using Entidades;

namespace Negocios.Servicios
{
    public interface IJuegoService
    {
        List<E_TemaProgreso> ListarTemas(E_Usuario actual);
        List<E_NivelJuego> ListarNiveles(E_Usuario actual, int idTema);
        E_PartidaEnCurso Iniciar(E_Usuario actual, int idTema, int idNivel);
        E_PartidaEnCurso IniciarSet(E_Usuario actual, string codigo);
        E_Pregunta ObtenerPregunta(E_Usuario actual, E_PartidaEnCurso partida);
        int SegundosRestantes(E_PartidaEnCurso partida, E_Pregunta pregunta);
        E_RespuestaResultado Responder(E_Usuario actual, E_PartidaEnCurso partida, int? idOpcion);
        bool Avanzar(E_Usuario actual, E_PartidaEnCurso partida);
        E_ResultadoPartida ObtenerResultado(E_Usuario actual, int idPartida);
        List<E_RankingItem> Ranking(E_Usuario actual, int? idTema);
        E_ResumenJugador ObtenerResumen(E_Usuario actual);
        List<E_Premio> ListarPremiosGanados(E_Usuario actual);
    }
}