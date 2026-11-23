using System;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Jugar : PaginaBase
    {
        private readonly IJuegoService _servicio = new N_Juego();

        // el tema viene en la url y asi sobrevive a los postbacks
        private int IdTemaActual
        {
            get { return int.TryParse(Request.QueryString["tema"], out int id) ? id : 0; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Cargar();
        }

        private void Cargar()
        {
            try
            {
                var temas = _servicio.ListarTemas(UsuarioActual);
                E_TemaProgreso tema = temas.Find(t => t.Id == IdTemaActual);
                if (tema == null) // sin tema o tema que no existe muestra la lista
                {
                    pnlTemas.Visible = true;
                    pnlNiveles.Visible = false;
                    rpTemas.DataSource = temas;
                    rpTemas.DataBind();
                    lblSinTemas.Visible = temas.Count == 0;
                    return;
                }
                pnlTemas.Visible = false;
                pnlNiveles.Visible = true;
                litTema.Text = tema.DsNombre;
                rpNiveles.DataSource = _servicio.ListarNiveles(UsuarioActual, tema.Id).OrderBy(n => n.NuOrden).ToList();
                rpNiveles.DataBind();
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Jugar.Cargar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudieron cargar los temas", false);
            }
        }

        protected void rpNiveles_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Jugar") return;
            bool iniciada = false;
            try
            {
                E_PartidaEnCurso partida = _servicio.Iniciar(UsuarioActual, IdTemaActual, Convert.ToInt32(e.CommandArgument));
                Session["Partida"] = partida; // la partida vive en la sesion
                iniciada = true;
            }
            catch (InvalidOperationException ex) { Mostrar(ex.Message, false); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message, false); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Jugar.Iniciar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo iniciar la partida", false);
            }
            if (iniciada) Response.Redirect("~/Pages/Partida.aspx"); // va fuera del try por el threadabort
            Cargar();
        }

        // arma la tarjetita del premio de cada nivel
        protected string PremioHtml(object imagen, object nombre, int puntos, bool ganado)
        {
            string img = HttpUtility.HtmlAttributeEncode(ResolveUrl(Convert.ToString(imagen)));
            string estado = ganado ? "<span class='badge bg-warning text-dark'>Ganado</span>" : "<span class='text-muted'>Por ganar</span>";
            return "<div class='d-flex align-items-center gap-2'><img src='" + img + "' alt='premio' style='width:48px;height:48px;object-fit:cover;' class='rounded" + (ganado ? "" : " opacity-50") + "' />"
                + "<div class='small'><strong>" + Validador.CodificarHtml(Convert.ToString(nombre)) + "</strong><br />+" + puntos + " pts · " + estado + "</div></div>";
        }

        private void Mostrar(string mensaje, bool ok)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = ok ? "alert alert-success d-block" : "alert alert-danger d-block";
            lblMensaje.Visible = true;
        }
    }
}