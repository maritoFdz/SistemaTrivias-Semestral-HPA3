using System;

namespace Entidades
{
    public class E_Premio
    {
        public int Id { get; set; }
        public int IdTema { get; set; }
        public int IdNivel { get; set; }
        public string DsNombre { get; set; }
        public string DsDescripcion { get; set; }
        public string DsRutaImagen { get; set; }
        public int NuPuntos { get; set; }
        public string DsEstado { get; set; }
        public string DsNombreTema { get; set; } // solo para mostrar
        public string DsNombreNivel { get; set; } // solo para mostrar
    }
}