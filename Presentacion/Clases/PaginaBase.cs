using System;
using System.Web.UI;
using Entidades;

namespace Presentacion.Clases
{
    public class PaginaBase : Page
    {
        protected virtual string[] RolesPermitidos { get { return null; } } // si es null deja pasar a cualquiera con sesion
        protected E_Usuario UsuarioActual { get { return Session["Usuario"] as E_Usuario; } }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (UsuarioActual == null) Response.Redirect("~/Pages/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl), true); // sin sesion pa fuera pero guarda a donde iba para volver despues de entrar
            if (RolesPermitidos != null && Array.IndexOf(RolesPermitidos, UsuarioActual.DsRol) < 0) Response.Redirect("~/Pages/Dashboard.aspx", true);
        }
    }
}