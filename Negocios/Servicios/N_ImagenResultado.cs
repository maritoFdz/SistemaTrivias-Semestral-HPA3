using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_ImagenResultado : IImagenResultadoService
    {
        private const string RutaVirtual = "~/Uploads/resultados/";
        private readonly D_ImagenResultado _datos;

        public N_ImagenResultado() : this(new D_ImagenResultado()) { }

        public N_ImagenResultado(D_ImagenResultado datos) { _datos = datos; }

        public List<E_ImagenResultado> Listar() { return _datos.Listar(); }

        public E_ImagenResultado ObtenerPorId(int id) { return _datos.ObtenerPorId(id); }

        public void Registrar(E_Usuario actual, E_ImagenResultado nueva, byte[] imagen, string carpetaFisica)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar imágenes de resultado");
            Validar(nueva);
            if (imagen == null || imagen.Length == 0) throw new ArgumentException("Seleccione una imagen");

            nueva.DsRutaImagen = ImagenArchivo.Guardar(imagen, carpetaFisica, RutaVirtual, 3); // los gif pesan mas asi que 3 mb
            try { _datos.Registrar(nueva); }
            catch { ImagenArchivo.Borrar(nueva.DsRutaImagen, carpetaFisica); throw; }
        }

        public void Actualizar(E_Usuario actual, E_ImagenResultado editada, byte[] imagenNueva, string carpetaFisica)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar imágenes de resultado");
            E_ImagenResultado original = _datos.ObtenerPorId(editada.Id);
            if (original == null) throw new InvalidOperationException("La imagen no existe");
            Validar(editada);

            string ruta = null; // null = no se cambia la imagen
            if (imagenNueva != null && imagenNueva.Length > 0) ruta = ImagenArchivo.Guardar(imagenNueva, carpetaFisica, RutaVirtual, 3);
            try { _datos.Actualizar(editada, ruta); }
            catch { if (ruta != null) ImagenArchivo.Borrar(ruta, carpetaFisica); throw; }
            if (ruta != null) ImagenArchivo.Borrar(original.DsRutaImagen, carpetaFisica);
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar imágenes de resultado");
            E_ImagenResultado i = _datos.ObtenerPorId(id);
            if (i == null) throw new InvalidOperationException("La imagen no existe");
            _datos.CambiarEstado(id, i.DsEstado == "1" ? "0" : "1");
        }

        private static bool PuedeAdministrar(E_Usuario actual) { return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo); }

        private static void Validar(E_ImagenResultado i)
        {
            i.DsMensaje = Validador.Sanitizar(i.DsMensaje);
            if (i.NuPorcentajeMinimo < 0 || i.NuPorcentajeMinimo > 100) throw new ArgumentException("El porcentaje debe estar entre 0 y 100");
            if (!Validador.LargoEntre(i.DsMensaje, 2, 120)) throw new ArgumentException("El mensaje debe tener entre 2 y 120 caracteres");
        }
    }
}