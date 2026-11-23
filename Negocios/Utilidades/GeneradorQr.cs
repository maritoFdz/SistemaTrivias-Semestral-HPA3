using System;
using QRCoder;

namespace Negocios.Utilidades
{
    // arma la imagen del qr con la libreria qrcoder
    public static class GeneradorQr
    {
        public static byte[] Png(string texto)
        {
            if (string.IsNullOrWhiteSpace(texto) || texto.Length > 500) throw new ArgumentException("El enlace del QR no es válido");
            var generador = new QRCodeGenerator();
            QRCodeData datos = generador.CreateQrCode(texto, QRCodeGenerator.ECCLevel.Q); // nivel q aguanta que se ensucie un poco al imprimir
            return new PngByteQRCode(datos).GetGraphic(12);
        }
    }
}