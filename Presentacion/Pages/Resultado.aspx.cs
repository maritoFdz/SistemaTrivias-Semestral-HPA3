using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Resultado : PaginaBase
    {
        private readonly IJuegoService _servicio = new N_Juego();
        protected E_ResultadoPartida Res;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out int id)) Response.Redirect("~/Pages/Jugar.aspx");
            try { Res = _servicio.ObtenerResultado(UsuarioActual, id); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Resultado.Cargar", ex, UsuarioActual.DsCorreo);
                Res = null;
                Mostrar("No se pudo cargar el resultado");
            }
            if (Res == null && !lblMensaje.Visible) Response.Redirect("~/Pages/Jugar.aspx"); // partida que no existe o de otro usuario
            pnlResultado.Visible = Res != null;
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = "alert alert-danger d-block";
            lblMensaje.Visible = true;
        }
    }
}