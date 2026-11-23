using System;

namespace Presentacion
{
    public partial class Publica : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool haySesion = Session["Usuario"] != null; // si ya entro se cambia crear cuenta e iniciar sesion por ir al panel
            lnkRegistro.Visible = !haySesion;
            lnkLogin.Visible = !haySesion;
            lnkPanel.Visible = haySesion;
        }
    }
}