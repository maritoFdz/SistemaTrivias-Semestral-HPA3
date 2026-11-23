using System;
using System.Collections.Generic;

namespace Entidades
{
    // lo que se guarda en la sesion mientras se juega
    [Serializable]
    public class E_PartidaEnCurso
    {
        public int IdPartida { get; set; }
        public int IdUsuario { get; set; }
        public int IdTema { get; set; }
        public int IdNivel { get; set; }
        public List<int> IdsPreguntas { get; set; } = new List<int>();
        public int Indice { get; set; }
        public DateTime InicioPregunta { get; set; }
        public bool EsperandoSiguiente { get; set; } // true cuando ya respondio y ve si acerto
        public E_RespuestaResultado Ultima { get; set; }
        public int Total { get { return IdsPreguntas.Count; } }
    }

    [Serializable]
    public class E_RespuestaResultado
    {
        public bool Correcta { get; set; }
        public bool TiempoAgotado { get; set; }
        public int IdOpcionCorrecta { get; set; }
        public string TextoCorrecta { get; set; }
        public int PuntosGanados { get; set; }
        public int Segundos { get; set; }
    }
}