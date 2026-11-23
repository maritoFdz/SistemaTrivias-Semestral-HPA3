using System;

namespace Entidades
{
    public class E_Usuario
    {
        public int Id { get; set; }
        public string DsCedula { get; set; }      // no se puede editar una vez registrada
        public string DsNombre { get; set; }
        public string DsCorreo { get; set; }
        public string DsPassword { get; set; }    // hasheao papo
        public string DsRol { get; set; }         // ADMIN, OPERATIVO o JUGADOR
        public string DsEstado { get; set; }      // 1/0
        public int? IdAvatar { get; set; }
        public string DsUsuarioCreacion { get; set; }
        public DateTime DtFechaCreacion { get; set; }
        public string DsUsuarioModificacion { get; set; }
        public DateTime DtFechaModificacion { get; set; }
    }
}