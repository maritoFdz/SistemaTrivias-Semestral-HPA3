using System;

namespace Entidades
{
    public class E_SetQr
    {
        public int Id { get; set; }
        public string DsCodigo { get; set; }
        public string DsNombre { get; set; }
        public int IdTema { get; set; }
        public int IdNivel { get; set; }
        public int NuCantidadPreguntas { get; set; }
        public string DsEstado { get; set; }
        public string DsNombreTema { get; set; } // solo para mostrar
        public string DsNombreNivel { get; set; } // solo para mostrar
        public int NuPartidas { get; set; } // cuantas veces se ha jugado por este qr
    }
}