using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Reportes : PaginaBase
    {
        private readonly IReporteService _servicio = new N_Reporte();
        private int _maximo = 1; // el mayor de la distribucion para dibujar las barras

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Cargar();
        }

        private void Cargar()
        {
            try
            {
                E_ReporteResumen r = _servicio.ObtenerResumen(UsuarioActual);
                litJugadores.Text = r.NuJugadoresActivos + " de " + r.NuJugadoresRegistrados;
                litPartidas.Text = r.NuPartidas.ToString();
                litPromedio.Text = r.NuPromedioPuntos.ToString("0.0");
                litPopular.Text = r.DsTemaPopular == null ? "Sin partidas" : Validador.CodificarHtml(r.DsTemaPopular) + " (" + r.NuPartidasTemaPopular + ")";
                litSegResp.Text = r.NuSegPromRespuesta.ToString("0.0");
                litQr.Text = r.NuPartidasQr.ToString();
                litSinJugar.Text = r.NuJugadoresSinJugar.ToString();

                List<E_DistribucionNivel> dist = _servicio.ObtenerDistribucion(UsuarioActual);
                _maximo = Math.Max(1, dist.Count == 0 ? 1 : dist.Max(d => d.NuJugadores));
                rpDistribucion.DataSource = dist;
                rpDistribucion.DataBind();

                gvAvance.DataSource = _servicio.ObtenerAvance(UsuarioActual);
                gvAvance.DataBind();
                if (gvAvance.Rows.Count > 0) gvAvance.HeaderRow.TableSection = TableRowSection.TableHeader; // datatables necesita el thead
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Reportes.Cargar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar el reporte");
                pnlReporte.Visible = false;
            }
        }

        // ancho de la barra en porcentaje
        protected string Porcentaje(object jugadores)
        {
            return (Convert.ToInt32(jugadores) * 100 / _maximo).ToString();
        }

        protected void btnExcel_Click(object sender, EventArgs e)
        {
            byte[] archivo = null;
            try { archivo = _servicio.ExportarExcel(UsuarioActual); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Reportes.btnExcel_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo generar el Excel");
            }
            if (archivo == null) { Cargar(); return; }

            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("Content-Disposition", "attachment; filename=reporte-trivias-" + DateTime.Now.ToString("yyyyMMdd-HHmm") + ".xlsx");
            Response.BinaryWrite(archivo);
            Response.Flush();
            Response.SuppressContent = true;
            Context.ApplicationInstance.CompleteRequest(); // sin Response.End para no lanzar el threadabort
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = "alert alert-danger d-block";
            lblMensaje.Visible = true;
        }
    }
}