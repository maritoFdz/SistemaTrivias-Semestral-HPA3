using System;

namespace Entidades
{
    public class E_Avatar
    {
        public int Id { get; set; }
        public int IdUsuario { get; set; }
        public string DsNombre { get; set; }
        public string DsRutaImagen { get; set; }
        public string DsEstado { get; set; }
        public string DsNombreUsuario { get; set; } // nombre del dueño solo para mostrar
    }
}