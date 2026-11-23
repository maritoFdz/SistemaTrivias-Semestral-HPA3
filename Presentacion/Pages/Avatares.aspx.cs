using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Avatares : PaginaBase
    {
        private readonly IAvatarService _servicio = new N_Avatar();

        protected int AvatarActualId; // el .aspx lo usa para marcar el que esta puesto
        protected bool EsGestor { get { return UsuarioActual.DsRol == Roles.Admin || UsuarioActual.DsRol == Roles.Operativo; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Cargar();
        }

        private void Cargar()
        {
            try
            {
                E_Avatar actual = _servicio.ObtenerActual(UsuarioActual);
                AvatarActualId = actual == null ? 0 : actual.Id;
                var lista = _servicio.Listar(UsuarioActual);
                rpAvatares.DataSource = lista;
                rpAvatares.DataBind();
                lblVacio.Visible = lista.Count == 0;
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Avatares.Cargar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar la lista de avatares", false);
            }
        }

        protected void rpAvatares_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            try
            {
                if (e.CommandName == "Usar") { _servicio.Usar(UsuarioActual, id); Mostrar("Avatar actualizado", true); }
                else if (e.CommandName == "CambiarEstado") { _servicio.CambiarEstado(UsuarioActual, id); Mostrar("Estado actualizado", true); }
            }
            catch (InvalidOperationException ex) { Mostrar(ex.Message, false); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message, false); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Avatares.ItemCommand", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo completar la acción", false);
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