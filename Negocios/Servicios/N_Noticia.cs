using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Noticia : INoticiaService
    {
        private const string RutaVirtual = "~/Uploads/noticias/";
        private readonly D_Noticia _datos;

        public N_Noticia() : this(new D_Noticia()) { }

        public N_Noticia(D_Noticia datos) { _datos = datos; }

        public List<E_Noticia> Listar(E_Usuario actual)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar noticias");
            return _datos.Listar();
        }

        // la pagina publica no pide sesion y solo recibe las activas
        public List<E_Noticia> ListarPublicas(int cantidad)
        {
            if (cantidad < 1 || cantidad > 20) cantidad = 6;
            return _datos.ListarPublicas(cantidad);
        }

        public E_Noticia ObtenerPorId(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar noticias");
            return _datos.ObtenerPorId(id);
        }

        public void Registrar(E_Usuario actual, E_Noticia nueva, byte[] imagen, string carpetaFisica)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar noticias");
            Validar(nueva);
            if (imagen != null && imagen.Length > 0) nueva.DsRutaImagen = ImagenArchivo.Guardar(imagen, carpetaFisica, RutaVirtual, 2); // la imagen es opcional
            try { _datos.Registrar(nueva, actual.DsCorreo); }
            catch { if (nueva.DsRutaImagen != null) ImagenArchivo.Borrar(nueva.DsRutaImagen, carpetaFisica); throw; }
        }

        public void Actualizar(E_Usuario actual, E_Noticia editada, byte[] imagenNueva, string carpetaFisica)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar noticias");
            E_Noticia original = _datos.ObtenerPorId(editada.Id);
            if (original == null) throw new InvalidOperationException("La noticia no existe");
            Validar(editada);

            string ruta = null; // null = no se cambia la imagen
            if (imagenNueva != null && imagenNueva.Length > 0) ruta = ImagenArchivo.Guardar(imagenNueva, carpetaFisica, RutaVirtual, 2);
            try { _datos.Actualizar(editada, ruta); }
            catch { if (ruta != null) ImagenArchivo.Borrar(ruta, carpetaFisica); throw; }
            if (ruta != null && original.DsRutaImagen != null) ImagenArchivo.Borrar(original.DsRutaImagen, carpetaFisica);
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar noticias");
            E_Noticia n = _datos.ObtenerPorId(id);
            if (n == null) throw new InvalidOperationException("La noticia no existe");
            _datos.CambiarEstado(id, n.DsEstado == "1" ? "0" : "1");
        }

        private static bool PuedeAdministrar(E_Usuario actual) { return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo); }

        private static void Validar(E_Noticia n)
        {
            n.DsTitulo = Validador.Sanitizar(n.DsTitulo);
            n.DsResumen = Validador.Sanitizar(n.DsResumen);
            n.DsContenido = Validador.Sanitizar(n.DsContenido);
            if (!Validador.LargoEntre(n.DsTitulo, 5, 150)) throw new ArgumentException("El título debe tener entre 5 y 150 caracteres");
            if (!Validador.LargoEntre(n.DsResumen, 10, 300)) throw new ArgumentException("El resumen debe tener entre 10 y 300 caracteres");
            if (!Validador.LargoEntre(n.DsContenido, 20, 4000)) throw new ArgumentException("El contenido debe tener entre 20 y 4000 caracteres");
        }
    }
}