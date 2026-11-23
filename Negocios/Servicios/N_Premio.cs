using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Premio : IPremioService
    {
        private const string RutaVirtual = "~/Uploads/premios/";
        private readonly D_Premio _datos;

        public N_Premio() : this(new D_Premio()) { }

        public N_Premio(D_Premio datos) { _datos = datos; }

        public List<E_Premio> Listar() { return _datos.Listar(); }

        public E_Premio ObtenerPorId(int id) { return _datos.ObtenerPorId(id); }

        public void Registrar(E_Usuario actual, E_Premio nuevo, byte[] imagen, string carpetaFisica)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar premios");
            Validar(nuevo);
            if (imagen == null || imagen.Length == 0) throw new ArgumentException("Seleccione una imagen");

            nuevo.DsRutaImagen = ImagenArchivo.Guardar(imagen, carpetaFisica, RutaVirtual, 2);
            try { _datos.Registrar(nuevo, actual.DsCorreo); }
            catch { ImagenArchivo.Borrar(nuevo.DsRutaImagen, carpetaFisica); throw; } // si falla la bd no deja el archivo huerfano
        }

        public void Actualizar(E_Usuario actual, E_Premio editado, byte[] imagenNueva, string carpetaFisica)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar premios");
            E_Premio original = _datos.ObtenerPorId(editado.Id);
            if (original == null) throw new InvalidOperationException("El premio no existe");
            Validar(editado);

            string ruta = null; // null = no se cambia la imagen
            if (imagenNueva != null && imagenNueva.Length > 0) ruta = ImagenArchivo.Guardar(imagenNueva, carpetaFisica, RutaVirtual, 2);
            try { _datos.Actualizar(editado, ruta, actual.DsCorreo); }
            catch { if (ruta != null) ImagenArchivo.Borrar(ruta, carpetaFisica); throw; }
            if (ruta != null) ImagenArchivo.Borrar(original.DsRutaImagen, carpetaFisica); // la imagen vieja ya no se usa
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar premios");
            E_Premio p = _datos.ObtenerPorId(id);
            if (p == null) throw new InvalidOperationException("El premio no existe");
            _datos.CambiarEstado(id, p.DsEstado == "1" ? "0" : "1", actual.DsCorreo);
        }

        private static bool PuedeAdministrar(E_Usuario actual) { return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo); }

        private static void Validar(E_Premio p)
        {
            p.DsNombre = Validador.Sanitizar(p.DsNombre);
            p.DsDescripcion = Validador.Sanitizar(p.DsDescripcion);
            if (p.IdTema <= 0) throw new ArgumentException("Seleccione un tema");
            if (p.IdNivel <= 0) throw new ArgumentException("Seleccione un nivel");
            if (!Validador.LargoEntre(p.DsNombre, 2, 80)) throw new ArgumentException("El nombre debe tener entre 2 y 80 caracteres");
            if (p.DsDescripcion.Length > 255) throw new ArgumentException("La descripción no puede pasar de 255 caracteres");
            if (p.NuPuntos < 1 || p.NuPuntos > 1000) throw new ArgumentException("Los puntos deben estar entre 1 y 1000");
            if (p.DsDescripcion.Length == 0) p.DsDescripcion = null; // vacia se guarda como null
        }
    }
}