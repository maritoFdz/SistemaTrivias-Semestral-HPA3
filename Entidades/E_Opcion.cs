using System;

namespace Entidades
{
    public class E_Opcion
    {
        public int Id { get; set; }
        public int IdPregunta { get; set; }
        public string DsTexto { get; set; }
        public bool NuEsCorrecta { get; set; }
    }
}