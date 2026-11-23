using System;

namespace Entidades
{
    public class E_ResultadoPartida
    {
        public int Id { get; set; }
        public int IdTema { get; set; }
        public int IdNivel { get; set; }
        public string DsNombreTema { get; set; }
        public string DsNombreNivel { get; set; }
        public int NuTotalPreguntas { get; set; }
        public int NuAciertos { get; set; }
        public int NuPuntos { get; set; }
        public decimal NuPorcentaje { get; set; }
        public bool Aprobado { get; set; }
        public int NuSegundosTotal { get; set; }
        public int NuPorcentajeAprobacion { get; set; }
        public int IdSiguienteNivel { get; set; } // 0 si ya era el ultimo
        public string DsMensajeResultado { get; set; }
        public string DsImagenResultado { get; set; }
        public int IdPremio { get; set; } // 0 si no gano premio en esta partida
        public string DsPremioNombre { get; set; }
        public string DsPremioImagen { get; set; }
        public int NuPremioPuntos { get; set; }
    }
}