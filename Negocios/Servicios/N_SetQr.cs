using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_SetQr : ISetQrService
    {
        private readonly D_SetQr _datos;

        public N_SetQr() : this(new D_SetQr()) { }

        public N_SetQr(D_SetQr datos) { _datos = datos; }

        public List<E_SetQr> Listar(E_Usuario actual)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar los sets QR");
            return _datos.Listar();
        }

        public E_SetQr ObtenerPorId(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar los sets QR");
            return _datos.ObtenerPorId(id);
        }

        // lo usa quien escanea el qr y no pide ser administrador
        public E_SetQr ObtenerPorCodigo(string codigo)
        {
            if (!Guid.TryParse(codigo, out Guid g)) return null; // lo que no es un codigo valido ni llega a la base
            return _datos.ObtenerPorCodigo(g.ToString());
        }

        public void Registrar(E_Usuario actual, E_SetQr nuevo)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar los sets QR");
            Validar(nuevo);
            nuevo.DsCodigo = Guid.NewGuid().ToString(); // el codigo lo pone el sistema y no se puede adivinar
            _datos.Registrar(nuevo, actual.DsCorreo);
        }

        public void Actualizar(E_Usuario actual, E_SetQr editado)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar los sets QR");
            if (_datos.ObtenerPorId(editado.Id) == null) throw new InvalidOperationException("El set no existe");
            Validar(editado);
            _datos.Actualizar(editado);
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar los sets QR");
            E_SetQr s = _datos.ObtenerPorId(id) ?? throw new InvalidOperationException("El set no existe");
            _datos.CambiarEstado(id, s.DsEstado == "1" ? "0" : "1");
        }

        // el enlace que va dentro del qr: direccion base mas la pagina publica del set
        public string ConstruirEnlace(string urlBase, string codigo)
        {
            urlBase = Validador.Sanitizar(urlBase);
            if (!Uri.TryCreate(urlBase, UriKind.Absolute, out Uri uri) || (uri.Scheme != Uri.UriSchemeHttp && uri.Scheme != Uri.UriSchemeHttps) || uri.UserInfo.Length > 0 || uri.Query.Length > 0)
                throw new ArgumentException("La dirección base no es válida (ej. http://192.168.1.10:8080)");
            if (!Guid.TryParse(codigo, out Guid g)) throw new ArgumentException("El código del set no es válido");
            return urlBase.TrimEnd('/') + "/Pages/JugarQr.aspx?c=" + g;
        }

        public byte[] GenerarQr(E_Usuario actual, string enlace)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar los sets QR");
            return GeneradorQr.Png(enlace);
        }

        private static bool PuedeAdministrar(E_Usuario actual) { return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo); }

        private static void Validar(E_SetQr s)
        {
            s.DsNombre = Validador.Sanitizar(s.DsNombre);
            if (!Validador.LargoEntre(s.DsNombre, 3, 100)) throw new ArgumentException("El nombre debe tener entre 3 y 100 caracteres");
            if (s.IdTema <= 0) throw new ArgumentException("Seleccione un tema");
            if (s.IdNivel <= 0) throw new ArgumentException("Seleccione un nivel");
            if (s.NuCantidadPreguntas < 3 || s.NuCantidadPreguntas > 10) throw new ArgumentException("El set debe tener entre 3 y 10 preguntas");
        }
    }
}