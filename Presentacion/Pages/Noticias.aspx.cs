using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Noticias : PaginaBase
    {
        private readonly INoticiaService _servicio = new N_Noticia();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Cargar();
        }

        private void Cargar()
        {
            try
            {
                gvNoticias.DataSource = _servicio.Listar(UsuarioActual);
                gvNoticias.DataBind();
                if (gvNoticias.Rows.Count > 0) gvNoticias.HeaderRow.TableSection = TableRowSection.TableHeader; // datatables necesita el thead
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Noticias.Cargar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar la lista de noticias", false);
            }
        }

        protected void gvNoticias_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "CambiarEstado") return;
            try
            {
                _servicio.CambiarEstado(UsuarioActual, Convert.ToInt32(e.CommandArgument));
                Mostrar("Estado actualizado", true);
            }
            catch (InvalidOperationException ex) { Mostrar(ex.Message, false); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message, false); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Noticias.RowCommand", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cambiar el estado", false);
            }
            Cargar();
        }

        private void Mostrar(string mensaje, bool ok)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = ok ? "alert alert-success d-block" : "alert alert-danger d-block";
            lblMensaje.Visible = true;
        }
    }
}