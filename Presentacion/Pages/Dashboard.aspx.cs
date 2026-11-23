using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    // hereda de paginabase y si no hay sesion ni llega al page_load
    public partial class Dashboard : PaginaBase
    {
        private readonly IJuegoService _servicio = new N_Juego();

        protected void Page_Load(object sender, EventArgs e)
        {
            litNombre.Text = UsuarioActual.DsNombre; // literal con mode encode ya codifica el html
            lblRol.Text = UsuarioActual.DsRol;
            if (!IsPostBack) CargarResumen();
        }

        private void CargarResumen()
        {
            try
            {
                E_ResumenJugador r = _servicio.ObtenerResumen(UsuarioActual);
                litPuntos.Text = r.NuPuntos.ToString();
                litPartidas.Text = r.NuPartidas.ToString();
                litNiveles.Text = r.NuNivelesAprobados.ToString();
                litPremios.Text = r.NuPremios.ToString();
                var premios = _servicio.ListarPremiosGanados(UsuarioActual);
                rpPremios.DataSource = premios;
                rpPremios.DataBind();
                lblSinPremios.Visible = premios.Count == 0;
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Dashboard.Resumen", ex, UsuarioActual.DsCorreo);
                pnlResumen.Visible = false;
                lblMensaje.Text = "No se pudo cargar tu resumen";
                lblMensaje.CssClass = "alert alert-danger d-block";
                lblMensaje.Visible = true;
            }
        }
    }
}