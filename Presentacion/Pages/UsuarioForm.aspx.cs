using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class UsuarioForm : PaginaBase
    {
        private readonly IUsuarioService _servicio = new N_Usuario();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        private int IdEdicion { get { int id; return int.TryParse(Request.QueryString["id"], out id) ? id : 0; } } // 0 es usuario nuevo

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            ddlRol.Items.Add(Roles.Admin);
            ddlRol.Items.Add(Roles.Operativo);
            ddlRol.Items.Add(Roles.Jugador);

            if (IdEdicion == 0) { litTitulo.Text = "Nuevo usuario"; lblAyudaPassword.Text = "Minimo 6 caracteres"; return; }
            CargarUsuario();
        }

        private void CargarUsuario()
        {
            E_Usuario u;
            try { u = _servicio.ObtenerPorId(IdEdicion); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("UsuarioForm.CargarUsuario", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar el usuario");
                return;
            }

            if (u == null) { Response.Redirect("~/Pages/Usuarios.aspx"); return; } // va fuera del try por el threadabort
            litTitulo.Text = "Editar usuario";
            txtCedula.Text = u.DsCedula;
            txtCedula.ReadOnly = true; // la cedula no se edita
            txtNombre.Text = u.DsNombre;
            txtCorreo.Text = u.DsCorreo;
            ddlRol.SelectedValue = u.DsRol;
            lblAyudaPassword.Text = "Dejala vacia para no cambiarla";
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            var u = new E_Usuario { Id = IdEdicion, DsCedula = txtCedula.Text, DsNombre = txtNombre.Text, DsCorreo = txtCorreo.Text, DsRol = ddlRol.SelectedValue };
            try
            {
                if (IdEdicion == 0) _servicio.Registrar(UsuarioActual, u, txtPassword.Text);
                else _servicio.Actualizar(UsuarioActual, u, txtPassword.Text);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); return; }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("UsuarioForm.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar el usuario");
                return;
            }
            Response.Redirect("~/Pages/Usuarios.aspx"); // todo bien vuelve a la lista
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}