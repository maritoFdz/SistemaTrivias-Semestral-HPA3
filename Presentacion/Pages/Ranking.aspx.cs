using System;
using System.Web;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Ranking : PaginaBase
    {
        private readonly IJuegoService _servicio = new N_Juego();

        protected int MiId { get { return UsuarioActual.Id; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            try
            {
                ddlTema.Items.Add(new ListItem("Todos los temas", ""));
                foreach (E_TemaProgreso t in _servicio.ListarTemas(UsuarioActual)) ddlTema.Items.Add(new ListItem(t.DsNombre, t.Id.ToString())); // el listitem codifica el texto solo
            }
            catch (Exception ex) { ManejadorErrores.Registrar("Ranking.Temas", ex, UsuarioActual.DsCorreo); }
            Cargar();
        }

        protected void ddlTema_SelectedIndexChanged(object sender, EventArgs e)
        {
            Cargar();
        }

        private void Cargar()
        {
            try
            {
                int? idTema = int.TryParse(ddlTema.SelectedValue, out int id) ? (int?)id : null; // vacio es todos los temas
                var lista = _servicio.Ranking(UsuarioActual, idTema);
                rpRanking.DataSource = lista;
                rpRanking.DataBind();
                lblVacio.Visible = lista.Count == 0;
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Ranking.Cargar", ex, UsuarioActual.DsCorreo);
                lblMensaje.Text = "No se pudo cargar el ranking";
                lblMensaje.CssClass = "alert alert-danger d-block";
                lblMensaje.Visible = true;
            }
        }

        protected string Medalla(int posicion)
        {
            if (posicion == 1) return "🥇";
            if (posicion == 2) return "🥈";
            if (posicion == 3) return "🥉";
            return posicion.ToString();
        }

        protected string Avatar(object ruta)
        {
            string r = Convert.ToString(ruta);
            if (string.IsNullOrEmpty(r)) return "<span class='d-inline-block rounded-circle bg-secondary align-middle' style='width:32px;height:32px;'></span>";
            return "<img src='" + HttpUtility.HtmlAttributeEncode(ResolveUrl(r)) + "' alt='avatar' class='rounded-circle align-middle' style='width:32px;height:32px;object-fit:cover;' />";
        }
    }
}