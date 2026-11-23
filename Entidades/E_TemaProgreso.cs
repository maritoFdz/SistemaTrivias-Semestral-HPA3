using System;

namespace Entidades
{
    public class E_TemaProgreso
    {
        public int Id { get; set; }
        public string DsNombre { get; set; }
        public string DsDescripcion { get; set; }
        public int NuNiveles { get; set; }
        public int NuAprobados { get; set; }
        public int NuPuntos { get; set; }
        public int NuPreguntas { get; set; }
        public int Porcentaje { get { return NuNiveles == 0 ? 0 : NuAprobados * 100 / NuNiveles; } } // avance del tema para la barra
    }
}