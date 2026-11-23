using System;
using System.Collections.Generic;

namespace Entidades
{
    public class E_Pregunta
    {
        public int Id { get; set; }
        public int IdTema { get; set; }
        public int IdNivel { get; set; }
        public string DsTipo { get; set; }
        public string DsEnunciado { get; set; }
        public int NuPuntos { get; set; }
        public int NuSegundos { get; set; }
        public string DsEstado { get; set; }
        public string DsNombreTema { get; set; } // solo para mostrar
        public string DsNombreNivel { get; set; } // solo para mostrar
        public List<E_Opcion> Opciones { get; set; } = new List<E_Opcion>();
    }

    public static class TiposPregunta
    {
        public const string OpcionMultiple = "OPCION_MULTIPLE";
        public const string VerdaderoFalso = "VERDADERO_FALSO";
    }
}