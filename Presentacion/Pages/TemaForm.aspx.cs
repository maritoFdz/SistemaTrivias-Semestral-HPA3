using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class TemaForm : PaginaBase
    {
        private readonly ITemaService _servicio = new N_Tema();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        private int IdEdicion { get { return int.TryParse(Request.QueryString["id"], out int id) ? id : 0; } } // 0 es tema nuevo

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            if (IdEdicion == 0) { litTitulo.Text = "Nuevo tema"; return; }
            CargarTema();
        }

        private void CargarTema()
        {
            E_Tema t;
            try { t = _servicio.ObtenerPorId(IdEdicion); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("TemaForm.CargarTema", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar el tema");
                return;
            }

            if (t == null) { Response.Redirect("~/Pages/Temas.aspx"); return; } // va fuera del try por el threadabort
            litTitulo.Text = "Editar tema";
            txtNombre.Text = t.DsNombre;
            txtDescripcion.Text = t.DsDescripcion;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            var t = new E_Tema { Id = IdEdicion, DsNombre = txtNombre.Text, DsDescripcion = txtDescripcion.Text };
            try
            {
                if (IdEdicion == 0) _servicio.Registrar(UsuarioActual, t);
                else _servicio.Actualizar(UsuarioActual, t);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); return; }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("TemaForm.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar el tema");
                return;
            }
            Response.Redirect("~/Pages/Temas.aspx"); // todo bien vuelve a la lista
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}