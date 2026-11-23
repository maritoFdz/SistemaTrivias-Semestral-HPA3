using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;

namespace Presentacion
{
    public partial class Principal : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            E_Usuario usuario = Session["Usuario"] as E_Usuario;
            bool haySesion = usuario != null;
            lblUsuario.Visible = haySesion;
            lnkSalir.Visible = haySesion;
            lnkAvatares.Visible = haySesion;
            lnkJugar.Visible = haySesion;
            lnkRanking.Visible = haySesion;
            phAdmin.Visible = haySesion && (usuario.DsRol == Roles.Admin || usuario.DsRol == Roles.Operativo); // solo admin y operativo ven el menu administrar
            if (!haySesion) return;
            lblUsuario.Text = Validador.CodificarHtml(usuario.DsNombre) + " (" + usuario.DsRol + ")"; // el Label no codifica el html solo
            CargarAvatar(usuario);
        }

        private void CargarAvatar(E_Usuario usuario)
        {
            try
            {
                E_Avatar av = new N_Avatar().ObtenerActual(usuario);
                imgAvatar.Visible = av != null;
                if (av != null) imgAvatar.ImageUrl = av.DsRutaImagen;
            }
            catch { imgAvatar.Visible = false; } // el avatar no debe tumbar toda la pagina
        }

        protected void lnkSalir_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("~/Pages/Login.aspx");
        }
    }
}