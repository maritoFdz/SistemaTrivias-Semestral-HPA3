using System;

namespace Entidades
{
    public class E_Calificacion
    {
        public int Id { get; set; }
        public int IdUsuario { get; set; }
        public int IdTema { get; set; }
        public int NuCalifTema { get; set; } // 1 regular, 2 medio, 3 bastante, 4 mucho
        public int NuCalifApp { get; set; }
        public string DsTemaSugerido { get; set; }
        public string DsComentario { get; set; }
        public DateTime DtFecha { get; set; }
        public string DsNombreUsuario { get; set; } // solo para mostrar
        public string DsNombreTema { get; set; } // solo para mostrar
    }

    public class E_ResumenCalificacion
    {
        public int IdTema { get; set; }
        public string DsNombreTema { get; set; }
        public int NuCalificaciones { get; set; }
        public decimal NuPromedioTema { get; set; }
        public decimal NuPromedioApp { get; set; }
    }

    // las 4 opciones que ve el jugador
    public static class NivelesCalificacion
    {
        public static string Texto(int valor)
        {
            switch (valor)
            {
                case 1: return "Regular";
                case 2: return "Medio";
                case 3: return "Bastante";
                case 4: return "Mucho";
                default: return "";
            }
        }
    }
}