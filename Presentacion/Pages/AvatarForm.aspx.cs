using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class AvatarForm : PaginaBase
    {
        private readonly IAvatarService _servicio = new N_Avatar();

        private int IdEdicion { get { int id; return int.TryParse(Request.QueryString["id"], out id) ? id : 0; } } // 0 es avatar nuevo
        private string Carpeta { get { return Server.MapPath("~/Uploads/avatares"); } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            if (IdEdicion == 0) { litTitulo.Text = "Nuevo avatar"; lblAyudaImagen.Text = "PNG JPG GIF o WEBP de hasta 2 MB"; return; }
            CargarAvatar();
        }

        private void CargarAvatar()
        {
            E_Avatar a;
            try { a = _servicio.ObtenerPorId(UsuarioActual, IdEdicion); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("AvatarForm.CargarAvatar", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar el avatar");
                return;
            }

            if (a == null) { Response.Redirect("~/Pages/Avatares.aspx"); return; } // va fuera del try por el threadabort
            litTitulo.Text = "Editar avatar";
            txtNombre.Text = a.DsNombre;
            imgActual.ImageUrl = a.DsRutaImagen;
            imgActual.Visible = true;
            lblAyudaImagen.Text = "Si no eliges una imagen se queda la actual";
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            var a = new E_Avatar { Id = IdEdicion, DsNombre = txtNombre.Text };
            byte[] imagen = fuImagen.HasFile ? fuImagen.FileBytes : null;
            try
            {
                if (IdEdicion == 0) _servicio.Registrar(UsuarioActual, a, imagen, Carpeta);
                else _servicio.Actualizar(UsuarioActual, a, imagen, Carpeta);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); return; }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("AvatarForm.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar el avatar");
                return;
            }
            Response.Redirect("~/Pages/Avatares.aspx"); // todo bien vuelve a la lista
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}