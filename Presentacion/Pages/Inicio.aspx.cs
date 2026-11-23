using System;
using System.Linq;
using System.Web;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;

namespace Presentacion.Pages
{
    // pagina publica: no hereda de paginabase porque no pide sesion
    public partial class Inicio : System.Web.UI.Page
    {
        private readonly ITemaService _temas = new N_Tema();
        private readonly INoticiaService _noticias = new N_Noticia();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            try
            {
                var temas = _temas.Listar().Where(t => t.DsEstado == "1").ToList(); // solo los activos
                rpTemas.DataSource = temas;
                rpTemas.DataBind();
                lblSinTemas.Visible = temas.Count == 0;
            }
            catch (Exception ex) { ManejadorErrores.Registrar("Inicio.Temas", ex, "publico"); lblSinTemas.Visible = true; } // la portada no se cae si falla una parte

            try
            {
                var noticias = _noticias.ListarPublicas(6);
                rpNoticias.DataSource = noticias;
                rpNoticias.DataBind();
                lblSinNoticias.Visible = noticias.Count == 0;
            }
            catch (Exception ex) { ManejadorErrores.Registrar("Inicio.Noticias", ex, "publico"); lblSinNoticias.Visible = true; }
        }

        protected string ImagenNoticia(object ruta)
        {
            if (ruta == null || ruta == DBNull.Value) return "";
            return "<img src='" + HttpUtility.HtmlAttributeEncode(ResolveUrl(Convert.ToString(ruta))) + "' class='card-img-top' style='height:180px;object-fit:cover;' alt='noticia' />";
        }
    }
}