using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class NoticiaForm : PaginaBase
    {
        private readonly INoticiaService _servicio = new N_Noticia();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        private int IdEdicion { get { int id; return int.TryParse(Request.QueryString["id"], out id) ? id : 0; } } // 0 es noticia nueva
        private string Carpeta { get { return Server.MapPath("~/Uploads/noticias"); } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            lblAyudaImagen.Text = "PNG JPG GIF o WEBP de hasta 2 MB";
            if (IdEdicion == 0) { litTitulo.Text = "Nueva noticia"; return; }
            CargarNoticia();
        }

        private void CargarNoticia()
        {
            E_Noticia n;
            try { n = _servicio.ObtenerPorId(UsuarioActual, IdEdicion); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("NoticiaForm.CargarNoticia", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar la noticia");
                return;
            }

            if (n == null) { Response.Redirect("~/Pages/Noticias.aspx"); return; } // va fuera del try por el threadabort
            litTitulo.Text = "Editar noticia";
            txtTitulo.Text = n.DsTitulo;
            txtResumen.Text = n.DsResumen;
            txtContenido.Text = n.DsContenido;
            if (n.DsRutaImagen != null)
            {
                imgActual.ImageUrl = n.DsRutaImagen;
                imgActual.Visible = true;
                lblAyudaImagen.Text = "Si no eliges una imagen se queda la actual";
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            var n = new E_Noticia { Id = IdEdicion, DsTitulo = txtTitulo.Text, DsResumen = txtResumen.Text, DsContenido = txtContenido.Text };
            byte[] imagen = fuImagen.HasFile ? fuImagen.FileBytes : null;
            try
            {
                if (IdEdicion == 0) _servicio.Registrar(UsuarioActual, n, imagen, Carpeta);
                else _servicio.Actualizar(UsuarioActual, n, imagen, Carpeta);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); return; }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("NoticiaForm.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar la noticia");
                return;
            }
            Response.Redirect("~/Pages/Noticias.aspx"); // todo bien vuelve a la lista
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}