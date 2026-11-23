using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class JugarQr : PaginaBase
    {
        private readonly ISetQrService _sets = new N_SetQr();
        private readonly IJuegoService _juego = new N_Juego();

        // el codigo viene del qr y se valida como guid en negocios
        private string Codigo { get { return Request.QueryString["c"]; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            try
            {
                E_SetQr set = _sets.ObtenerPorCodigo(Codigo);
                if (set == null || set.DsEstado != "1") { Aviso("Este QR no está disponible"); return; }
                litNombre.Text = Validador.CodificarHtml(set.DsNombre);
                litDetalle.Text = Validador.CodificarHtml(set.DsNombreTema + " · " + set.DsNombreNivel + " · " + set.NuCantidadPreguntas + " preguntas");
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("JugarQr.Page_Load", ex, UsuarioActual.DsCorreo);
                Aviso("No se pudo cargar el set");
            }
        }

        protected void btnComenzar_Click(object sender, EventArgs e)
        {
            bool iniciada = false;
            try
            {
                Session["Partida"] = _juego.IniciarSet(UsuarioActual, Codigo);
                iniciada = true;
            }
            catch (InvalidOperationException ex) { Aviso(ex.Message); } // nivel bloqueado o set apagado
            catch (UnauthorizedAccessException ex) { Aviso(ex.Message); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("JugarQr.btnComenzar_Click", ex, UsuarioActual.DsCorreo);
                Aviso("No se pudo iniciar la partida");
            }
            if (iniciada) Response.Redirect("~/Pages/Partida.aspx"); // fuera del try por el threadabort
        }

        private void Aviso(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = "alert alert-danger d-block";
            lblMensaje.Visible = true;
            pnlSet.Visible = false;
        }
    }
}