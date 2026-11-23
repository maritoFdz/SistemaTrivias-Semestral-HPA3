using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;

namespace Presentacion.Pages
{
    // pagina publica: aqui se registran los jugadores por su cuenta y siempre entran como jugador
    public partial class Registro : System.Web.UI.Page
    {
        private const int MaximoRegistros = 3;
        private readonly IUsuarioService _servicio = new N_Usuario();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["Usuario"] != null) Response.Redirect("~/Pages/Jugar.aspx"); // ya tiene cuenta y sesion
            if (!IsPostBack) NuevoCaptcha();
        }

        // suma sencilla que se guarda en la sesion y asi la respuesta nunca viaja al navegador
        private void NuevoCaptcha()
        {
            var azar = new Random();
            int a = azar.Next(2, 10), b = azar.Next(2, 10);
            Session["Captcha"] = a + b;
            lblCaptcha.Text = a + " + " + b;
            txtCaptcha.Text = "";
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            int hechos = Session["Registros"] is int v ? v : 0;
            if (hechos >= MaximoRegistros) { Mostrar("Ya creaste varias cuentas desde este navegador. Intenta más tarde."); return; }
            if (txtWeb.Text.Length > 0) { Mostrar("No se pudo completar el registro"); NuevoCaptcha(); return; } // lo lleno un robot

            if (!int.TryParse(txtCaptcha.Text, out int respuesta) || !(Session["Captcha"] is int v1) || respuesta != v1)
            {
                Mostrar("La verificación no es correcta, intenta con esta nueva suma");
                NuevoCaptcha();
                return;
            }
            if (txtPassword.Text != txtConfirmar.Text) { Mostrar("Las contraseñas no coinciden"); NuevoCaptcha(); return; }

            E_Usuario usuario = null;
            try
            {
                var nuevo = new E_Usuario { DsNombre = txtNombre.Text, DsCedula = txtCedula.Text, DsCorreo = txtCorreo.Text };
                _servicio.RegistrarPublico(nuevo, txtPassword.Text);
                usuario = _servicio.Login(nuevo.DsCorreo, txtPassword.Text); // entra directo sin pasar por el login
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); NuevoCaptcha(); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); NuevoCaptcha(); return; } // cedula o correo repetidos
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Registro.btnRegistrar_Click", ex, txtCorreo.Text);
                Mostrar("No se pudo crear la cuenta en este momento. Intenta de nuevo más tarde.");
                NuevoCaptcha();
                return;
            }

            Session["Registros"] = hechos + 1;
            if (usuario == null) Response.Redirect("~/Pages/Login.aspx"); // se creo pero no pudo entrar solo
            Session["Usuario"] = usuario;
            Response.Redirect("~/Pages/Jugar.aspx"); // va fuera del try por el threadabort
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}