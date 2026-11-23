using System;

namespace Entidades
{
    public class E_Noticia
    {
        public int Id { get; set; }
        public string DsTitulo { get; set; }
        public string DsResumen { get; set; }
        public string DsContenido { get; set; }
        public string DsRutaImagen { get; set; } // puede ser null
        public DateTime DtPublicacion { get; set; }
        public string DsEstado { get; set; }
    }
}