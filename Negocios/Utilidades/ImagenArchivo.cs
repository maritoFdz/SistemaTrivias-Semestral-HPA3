using System;
using System.IO;

namespace Negocios.Utilidades
{
    // guarda y borra imagenes subidas y la usan premios e imagenes de resultado
    public static class ImagenArchivo
    {
        // el tipo se saca de los bytes del archivo y no del nombre porque el nombre lo puede falsear cualquiera
        private static string DetectarExtension(byte[] b)
        {
            if (b.Length > 8 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) return ".png";
            if (b.Length > 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) return ".jpg";
            if (b.Length > 6 && b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x38) return ".gif";
            if (b.Length > 12 && b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46 && b[8] == 0x57 && b[9] == 0x45 && b[10] == 0x42 && b[11] == 0x50) return ".webp";
            return null;
        }

        public static string Guardar(byte[] imagen, string carpetaFisica, string rutaVirtual, int maxMb)
        {
            if (imagen.Length > maxMb * 1024 * 1024) throw new ArgumentException("La imagen no puede pasar de " + maxMb + " MB");
            string ext = DetectarExtension(imagen);
            if (ext == null) throw new ArgumentException("La imagen debe ser PNG, JPG, GIF o WEBP");

            string archivo = Guid.NewGuid().ToString("N") + ext; // nombre propio para que nadie elija la ruta
            Directory.CreateDirectory(carpetaFisica);
            File.WriteAllBytes(Path.Combine(carpetaFisica, archivo), imagen);
            return rutaVirtual + archivo;
        }

        public static void Borrar(string rutaVirtual, string carpetaFisica)
        {
            try { File.Delete(Path.Combine(carpetaFisica, Path.GetFileName(rutaVirtual))); }
            catch { } // si no se puede borrar no pasa nada
        }
    }
}