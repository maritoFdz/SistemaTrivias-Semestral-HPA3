using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Calificacion : ICalificacionService
    {
        private readonly D_Calificacion _datos;

        public N_Calificacion() : this(new D_Calificacion()) { }

        public N_Calificacion(D_Calificacion datos) { _datos = datos; }

        public void Guardar(E_Usuario actual, E_Calificacion c)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            c.IdUsuario = actual.Id; // el usuario sale de la sesion y no del formulario
            if (c.IdTema <= 0) throw new ArgumentException("El tema no es válido");
            if (c.NuCalifTema < 1 || c.NuCalifTema > 4) throw new ArgumentException("Elige cómo calificas el tema");
            if (c.NuCalifApp < 1 || c.NuCalifApp > 4) throw new ArgumentException("Elige cómo calificas la aplicación");

            c.DsTemaSugerido = Validador.Sanitizar(c.DsTemaSugerido);
            c.DsComentario = Validador.Sanitizar(c.DsComentario);
            if (c.DsTemaSugerido.Length > 200) throw new ArgumentException("El tema sugerido no puede pasar de 200 caracteres");
            if (c.DsComentario.Length > 500) throw new ArgumentException("El comentario no puede pasar de 500 caracteres");
            if (c.DsTemaSugerido.Length == 0) c.DsTemaSugerido = null; // vacio se guarda como null
            if (c.DsComentario.Length == 0) c.DsComentario = null;

            _datos.Guardar(c);
        }

        public E_Calificacion Obtener(E_Usuario actual, int idTema)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            return _datos.Obtener(actual.Id, idTema);
        }

        public List<E_ResumenCalificacion> Resumen(E_Usuario actual)
        {
            if (!PuedeVer(actual)) throw new UnauthorizedAccessException("No tiene permiso para ver las calificaciones");
            return _datos.Resumen();
        }

        public List<E_Calificacion> Listar(E_Usuario actual)
        {
            if (!PuedeVer(actual)) throw new UnauthorizedAccessException("No tiene permiso para ver las calificaciones");
            return _datos.Listar();
        }

        private static bool PuedeVer(E_Usuario actual) { return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo); }
    }
}