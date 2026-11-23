using System;

namespace Entidades
{
    public class E_ReporteResumen
    {
        public int NuJugadoresRegistrados { get; set; }
        public int NuJugadoresActivos { get; set; }
        public int NuJugadoresSinJugar { get; set; }
        public int NuPartidas { get; set; }
        public int NuPartidasQr { get; set; }
        public decimal NuPromedioPuntos { get; set; }
        public string DsTemaPopular { get; set; } // null si nadie ha jugado
        public int NuPartidasTemaPopular { get; set; }
        public decimal NuSegPromRespuesta { get; set; }
    }

    public class E_DistribucionNivel
    {
        public int IdNivel { get; set; }
        public string DsNombre { get; set; }
        public int NuOrden { get; set; }
        public int NuJugadores { get; set; }
    }

    public class E_AvanceJugador
    {
        public int IdUsuario { get; set; }
        public string DsNombre { get; set; }
        public string DsCorreo { get; set; }
        public int IdTema { get; set; }
        public string DsNombreTema { get; set; }
        public int NuPartidas { get; set; }
        public int NuNivelesAprobados { get; set; }
        public int NuTotalNiveles { get; set; }
        public string DsNivelMaximo { get; set; }
        public int NuPuntos { get; set; }
        public decimal NuSegPromRespuesta { get; set; }
        public int NuSegTotal { get; set; }
        public decimal? NuSegEntreNiveles { get; set; } // null si no ha pasado de un nivel a otro
        public int NuAvance { get { return NuTotalNiveles == 0 ? 0 : NuNivelesAprobados * 100 / NuTotalNiveles; } } // % del tema
    }
}