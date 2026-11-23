using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class SetsQr : PaginaBase
    {
        private readonly ISetQrService _servicio = new N_SetQr();
        private readonly ITemaService _temas = new N_Tema();
        private readonly IPreguntaService _preguntas = new N_Pregunta();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            CargarCombos();
            Cargar();
        }

        private void CargarCombos()
        {
            try
            {
                ddlTema.DataSource = _temas.Listar().FindAll(t => t.DsEstado == "1");
                ddlTema.DataValueField = "Id";
                ddlTema.DataTextField = "DsNombre";
                ddlTema.DataBind();
                ddlNivel.DataSource = _preguntas.ListarNiveles();
                ddlNivel.DataValueField = "Id";
                ddlNivel.DataTextField = "DsNombre";
                ddlNivel.DataBind();
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("SetsQr.CargarCombos", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudieron cargar los temas y niveles", false);
            }
        }

        private void Cargar()
        {
            try
            {
                gvSets.DataSource = _servicio.Listar(UsuarioActual);
                gvSets.DataBind();
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("SetsQr.Cargar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar la lista de sets", false);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            int cantidad, idTema, idNivel, id;
            int.TryParse(txtCantidad.Text, out cantidad);
            int.TryParse(ddlTema.SelectedValue, out idTema);
            int.TryParse(ddlNivel.SelectedValue, out idNivel);
            int.TryParse(hfId.Value, out id);
            var set = new E_SetQr { Id = id, DsNombre = txtNombre.Text, IdTema = idTema, IdNivel = idNivel, NuCantidadPreguntas = cantidad };
            try
            {
                if (id == 0) _servicio.Registrar(UsuarioActual, set);
                else _servicio.Actualizar(UsuarioActual, set);
                Limpiar();
                Mostrar("Set guardado", true);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message, false); }
            catch (InvalidOperationException ex) { Mostrar(ex.Message, false); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message, false); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("SetsQr.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar el set", false);
            }
            Cargar();
        }

        protected void btnCancelar_Click(object sender, EventArgs e) { Limpiar(); }

        protected void gvSets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            try
            {
                if (e.CommandName == "CambiarEstado")
                {
                    _servicio.CambiarEstado(UsuarioActual, id);
                    Mostrar("Estado actualizado", true);
                }
                else if (e.CommandName == "Editar")
                {
                    E_SetQr s = _servicio.ObtenerPorId(UsuarioActual, id);
                    if (s != null)
                    {
                        hfId.Value = s.Id.ToString();
                        txtNombre.Text = s.DsNombre;
                        txtCantidad.Text = s.NuCantidadPreguntas.ToString();
                        if (ddlTema.Items.FindByValue(s.IdTema.ToString()) != null) ddlTema.SelectedValue = s.IdTema.ToString();
                        if (ddlNivel.Items.FindByValue(s.IdNivel.ToString()) != null) ddlNivel.SelectedValue = s.IdNivel.ToString();
                        litForm.Text = "Editar set";
                        btnCancelar.Visible = true;
                    }
                }
            }
            catch (InvalidOperationException ex) { Mostrar(ex.Message, false); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message, false); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("SetsQr.RowCommand", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo completar la acción", false);
            }
            Cargar();
        }

        private void Limpiar()
        {
            hfId.Value = "0";
            txtNombre.Text = "";
            txtCantidad.Text = "5";
            litForm.Text = "Nuevo set";
            btnCancelar.Visible = false;
        }

        private void Mostrar(string mensaje, bool ok)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = ok ? "alert alert-success d-block" : "alert alert-danger d-block";
            lblMensaje.Visible = true;
        }
    }
}