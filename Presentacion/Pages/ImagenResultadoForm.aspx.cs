using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class ImagenResultadoForm : PaginaBase
    {
        private readonly IImagenResultadoService _servicio = new N_ImagenResultado();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        private int IdEdicion { get { int id; return int.TryParse(Request.QueryString["id"], out id) ? id : 0; } } // 0 es imagen nueva
        private string Carpeta { get { return Server.MapPath("~/Uploads/resultados"); } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            if (IdEdicion == 0) { litTitulo.Text = "Nueva imagen de resultado"; lblAyudaImagen.Text = "PNG JPG GIF o WEBP de hasta 3 MB"; return; }
            CargarImagen();
        }

        private void CargarImagen()
        {
            E_ImagenResultado i;
            try { i = _servicio.ObtenerPorId(IdEdicion); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("ImagenResultadoForm.CargarImagen", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar la imagen");
                return;
            }

            if (i == null) { Response.Redirect("~/Pages/ImagenesResultado.aspx"); return; } // va fuera del try por el threadabort
            litTitulo.Text = "Editar imagen de resultado";
            txtMinimo.Text = i.NuPorcentajeMinimo.ToString();
            txtMensaje.Text = i.DsMensaje;
            imgActual.ImageUrl = i.DsRutaImagen;
            imgActual.Visible = true;
            lblAyudaImagen.Text = "Si no eliges una imagen se queda la actual";
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            int minimo;
            if (!int.TryParse(txtMinimo.Text, out minimo)) minimo = -1; // negocios lo rechaza
            var i = new E_ImagenResultado { Id = IdEdicion, NuPorcentajeMinimo = minimo, DsMensaje = txtMensaje.Text };
            byte[] imagen = fuImagen.HasFile ? fuImagen.FileBytes : null;
            try
            {
                if (IdEdicion == 0) _servicio.Registrar(UsuarioActual, i, imagen, Carpeta);
                else _servicio.Actualizar(UsuarioActual, i, imagen, Carpeta);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); return; }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("ImagenResultadoForm.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar la imagen");
                return;
            }
            Response.Redirect("~/Pages/ImagenesResultado.aspx"); // todo bien vuelve a la lista
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}