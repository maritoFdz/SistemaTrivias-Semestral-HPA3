using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;
using System;

namespace Presentacion.Pages
{
    public partial class Login : System.Web.UI.Page
    {
        private const int MaximoIntentos = 3;
        private readonly IUsuarioService _servicio = new N_Usuario(); // la pagina no sabe nada de la bd ni el hash

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["Usuario"] != null) Response.Redirect(Navegacion.UrlSegura(Request.QueryString["ReturnUrl"], "~/Pages/Dashboard.aspx")); // si ya hay sesion no tiene sentido ver el login
        }

        protected void btnIngresar_Click(object sender, EventArgs e)
        {
            int intentos = Session["Intentos"] is int v ? v : 0;
            if (intentos >= MaximoIntentos) { Mostrar("Demasiados intentos fallidos. Cierre el navegador e intente más tarde"); return; }

            E_Usuario usuario;
            try { usuario = _servicio.Login(txtCorreo.Text, txtPassword.Text); }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; } // error de valid
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Login.btnIngresar_Click", ex, txtCorreo.Text); // el detalle se guarda en el log
                Mostrar("No se pudo iniciar sesión en este momento. Intente de nuevo más tarde");
                return;
            }

            if (usuario == null)
            {
                Session["Intentos"] = ++intentos;
                Mostrar("Correo o contraseña incorrectos. Intento " + intentos + " de " + MaximoIntentos);
                return;
            }

            Session["Intentos"] = 0;
            Session["Usuario"] = usuario;
            Response.Redirect(Navegacion.UrlSegura(Request.QueryString["ReturnUrl"], "~/Pages/Dashboard.aspx")); // vuelve a donde iba si venia de otra pagina // va fuera del try porque el redirect lanza el aborto ese
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}