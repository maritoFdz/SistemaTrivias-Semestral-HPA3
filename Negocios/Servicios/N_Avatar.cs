using System;
using System.Collections.Generic;
using System.IO;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Avatar : IAvatarService
    {
        private const int MaxBytes = 2 * 1024 * 1024; // 2 mb
        private const string RutaVirtual = "~/Uploads/avatares/";
        private readonly D_Avatar _datos;

        public N_Avatar() : this(new D_Avatar()) { }

        public N_Avatar(D_Avatar datos) { _datos = datos; }

        // admin y operativo ven todos y los demas solo los suyos
        public List<E_Avatar> Listar(E_Usuario actual)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            return _datos.Listar(EsGestor(actual) ? (int?)null : actual.Id);
        }

        public E_Avatar ObtenerPorId(E_Usuario actual, int id)
        {
            E_Avatar a = _datos.ObtenerPorId(id);
            if (a != null) VerificarDueno(actual, a);
            return a;
        }

        public E_Avatar ObtenerActual(E_Usuario actual) { return actual == null ? null : _datos.ObtenerActual(actual.Id); }

        public void Registrar(E_Usuario actual, E_Avatar nuevo, byte[] imagen, string carpetaFisica)
        {
            if (actual == null) throw new UnauthorizedAccessException("Debe iniciar sesión");
            nuevo.DsNombre = ValidarNombre(nuevo.DsNombre);
            if (imagen == null || imagen.Length == 0) throw new ArgumentException("Seleccione una imagen");

            nuevo.IdUsuario = actual.Id;
            nuevo.DsRutaImagen = GuardarImagen(imagen, carpetaFisica);
            try { _datos.Registrar(nuevo, actual.DsCorreo); }
            catch { BorrarArchivo(nuevo.DsRutaImagen, carpetaFisica); throw; } // si falla la bd no deja el archivo huerfano
        }

        public void Actualizar(E_Usuario actual, E_Avatar editado, byte[] imagenNueva, string carpetaFisica)
        {
            E_Avatar original = _datos.ObtenerPorId(editado.Id);
            if (original == null) throw new InvalidOperationException("El avatar no existe");
            VerificarDueno(actual, original);
            editado.DsNombre = ValidarNombre(editado.DsNombre);

            string ruta = null; // null = no se cambia la imagen
            if (imagenNueva != null && imagenNueva.Length > 0) ruta = GuardarImagen(imagenNueva, carpetaFisica);
            try { _datos.Actualizar(editado, ruta, actual.DsCorreo); }
            catch { if (ruta != null) BorrarArchivo(ruta, carpetaFisica); throw; }
            if (ruta != null) BorrarArchivo(original.DsRutaImagen, carpetaFisica); // la imagen vieja ya no se usa
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            E_Avatar a = _datos.ObtenerPorId(id);
            if (a == null) throw new InvalidOperationException("El avatar no existe");
            VerificarDueno(actual, a);
            _datos.CambiarEstado(id, a.DsEstado == "1" ? "0" : "1", actual.DsCorreo);
        }

        public void Usar(E_Usuario actual, int id)
        {
            E_Avatar a = _datos.ObtenerPorId(id);
            if (a == null) throw new InvalidOperationException("El avatar no existe");
            if (a.IdUsuario != actual.Id) throw new UnauthorizedAccessException("Solo puedes usar tus propios avatares"); // ni el admin usa los ajenos
            if (a.DsEstado != "1") throw new InvalidOperationException("El avatar está desactivado");
            _datos.Usar(actual.Id, id, actual.DsCorreo);
        }

        private static bool EsGestor(E_Usuario u) { return u != null && (u.DsRol == Roles.Admin || u.DsRol == Roles.Operativo); }

        private static void VerificarDueno(E_Usuario actual, E_Avatar a)
        {
            if (actual == null || (a.IdUsuario != actual.Id && !EsGestor(actual))) throw new UnauthorizedAccessException("No tiene permiso sobre este avatar");
        }

        private static string ValidarNombre(string nombre)
        {
            nombre = Validador.Sanitizar(nombre);
            if (!Validador.LargoEntre(nombre, 2, 60)) throw new ArgumentException("El nombre debe tener entre 2 y 60 caracteres");
            return nombre;
        }

        // el tipo se saca de los bytes del archivo y no del nombre porque el nombre lo puede falsear cualquiera
        private static string DetectarExtension(byte[] b)
        {
            if (b.Length > 8 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) return ".png";
            if (b.Length > 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) return ".jpg";
            if (b.Length > 6 && b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x38) return ".gif";
            if (b.Length > 12 && b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46 && b[8] == 0x57 && b[9] == 0x45 && b[10] == 0x42 && b[11] == 0x50) return ".webp";
            return null;
        }

        private static string GuardarImagen(byte[] imagen, string carpetaFisica)
        {
            if (imagen.Length > MaxBytes) throw new ArgumentException("La imagen no puede pasar de 2 MB");
            string ext = DetectarExtension(imagen);
            if (ext == null) throw new ArgumentException("La imagen debe ser PNG, JPG, GIF o WEBP");

            string archivo = Guid.NewGuid().ToString("N") + ext; // nombre propio para que nadie elija la ruta
            Directory.CreateDirectory(carpetaFisica);
            File.WriteAllBytes(Path.Combine(carpetaFisica, archivo), imagen);
            return RutaVirtual + archivo;
        }

        private static void BorrarArchivo(string rutaVirtual, string carpetaFisica)
        {
            try { File.Delete(Path.Combine(carpetaFisica, Path.GetFileName(rutaVirtual))); }
            catch { } // si no se puede borrar no pasa nada
        }
    }
}