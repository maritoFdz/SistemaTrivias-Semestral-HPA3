using System;

namespace Entidades
{
    public class E_NivelJuego
    {
        public int IdNivel { get; set; }
        public string DsNombre { get; set; }
        public int NuOrden { get; set; }
        public int NuPorcentajeAprobacion { get; set; }
        public int NuPreguntas { get; set; }
        public bool Aprobado { get; set; }
        public decimal NuMejorPorcentaje { get; set; }
        public int NuIntentos { get; set; }
        public bool Desbloqueado { get; set; } // lo calcula negocios
        public int IdPremio { get; set; }
        public string DsPremioNombre { get; set; }
        public string DsPremioImagen { get; set; }
        public int NuPremioPuntos { get; set; }
        public bool PremioGanado { get; set; }
    }
}