using System;

namespace Entidades
{
    public class E_RankingItem
    {
        public int Posicion { get; set; }
        public int IdUsuario { get; set; }
        public string DsNombre { get; set; }
        public string DsRutaAvatar { get; set; }
        public int NuPuntos { get; set; }
        public int NuNivelesAprobados { get; set; }
        public int NuPremios { get; set; }
    }

    public class E_ResumenJugador
    {
        public int NuPuntos { get; set; }
        public int NuPartidas { get; set; }
        public int NuNivelesAprobados { get; set; }
        public int NuPremios { get; set; }
    }
}