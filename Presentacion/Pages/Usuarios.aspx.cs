using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Usuarios : PaginaBase
    {
        private readonly IUsuarioService _servicio = new N_Usuario();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } } // solo admin y operativo entran

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Cargar();
        }

        private void Cargar()
        {
            try
            {
                gvUsuarios.DataSource = _servicio.Listar();
                gvUsuarios.DataBind();
                if (gvUsuarios.Rows.Count > 0) gvUsuarios.HeaderRow.TableSection = TableRowSection.TableHeader; // datatables necesita el thead
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Usuarios.Cargar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar la lista de usuarios", false);
            }
        }

        protected void gvUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
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
                ManejadorErrores.Registrar("Usuarios.RowCommand", ex, UsuarioActual.DsCorreo);
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