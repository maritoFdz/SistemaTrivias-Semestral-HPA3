using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Tema : ITemaService
    {
        private readonly D_Tema _datos;

        public N_Tema() : this(new D_Tema()) { }

        public N_Tema(D_Tema datos) { _datos = datos; }

        public List<E_Tema> Listar() { return _datos.Listar(); }

        public E_Tema ObtenerPorId(int id) { return _datos.ObtenerPorId(id); }

        public void Registrar(E_Usuario actual, E_Tema nuevo)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar temas");
            Validar(nuevo);
            _datos.Registrar(nuevo, actual.DsCorreo);
        }

        public void Actualizar(E_Usuario actual, E_Tema editado)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar temas");
            if (editado.Id <= 0) throw new ArgumentException("Tema no válido");
            Validar(editado);
            _datos.Actualizar(editado, actual.DsCorreo);
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar temas");
            E_Tema t = _datos.ObtenerPorId(id);
            if (t == null) throw new InvalidOperationException("El tema no existe");
            _datos.CambiarEstado(id, t.DsEstado == "1" ? "0" : "1", actual.DsCorreo);
        }

        private static bool PuedeAdministrar(E_Usuario actual) { return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo); }

        private static void Validar(E_Tema t)
        {
            t.DsNombre = Validador.Sanitizar(t.DsNombre);
            t.DsDescripcion = Validador.Sanitizar(t.DsDescripcion);
            if (!Validador.LargoEntre(t.DsNombre, 2, 60)) throw new ArgumentException("El nombre debe tener entre 2 y 60 caracteres");
            if (t.DsDescripcion.Length > 255) throw new ArgumentException("La descripción no puede pasar de 255 caracteres");
            if (t.DsDescripcion.Length == 0) t.DsDescripcion = null; // vacia se guarda como null
        }
    }
}