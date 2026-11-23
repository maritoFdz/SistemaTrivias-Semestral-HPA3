using System;
using System.Web;
using System.Web.SessionState;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;

namespace Presentacion.Pages
{
    // entrega el png del qr, solo para admin y operativo
    public class QrImagen : IHttpHandler, IReadOnlySessionState
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext context)
        {
            var actual = context.Session["Usuario"] as E_Usuario;
            if (actual == null || (actual.DsRol != Roles.Admin && actual.DsRol != Roles.Operativo)) { context.Response.StatusCode = 403; return; }

            int id;
            if (!int.TryParse(context.Request.QueryString["id"], out id)) { context.Response.StatusCode = 400; return; }
            try
            {
                ISetQrService servicio = new N_SetQr();
                E_SetQr set = servicio.ObtenerPorId(actual, id);
                if (set == null) { context.Response.StatusCode = 404; return; }
                string enlace = servicio.ConstruirEnlace(context.Request.QueryString["base"], set.DsCodigo);
                byte[] png = servicio.GenerarQr(actual, enlace);
                context.Response.Clear();
                context.Response.ContentType = "image/png";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                if (context.Request.QueryString["descargar"] == "1")
                    context.Response.AddHeader("Content-Disposition", "attachment; filename=qr-set-" + set.Id + ".png");
                context.Response.BinaryWrite(png);
            }
            catch (ArgumentException) { context.Response.StatusCode = 400; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("QrImagen.ProcessRequest", ex, actual.DsCorreo);
                context.Response.StatusCode = 500;
            }
        }
    }
}