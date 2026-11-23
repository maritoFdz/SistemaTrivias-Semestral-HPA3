using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class PremioForm : PaginaBase
    {
        private readonly IPremioService _servicio = new N_Premio();
        private readonly ITemaService _temas = new N_Tema();
        private readonly IPreguntaService _preguntas = new N_Pregunta(); // de aqui salen los niveles

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        private int IdEdicion { get { int id; return int.TryParse(Request.QueryString["id"], out id) ? id : 0; } } // 0 es premio nuevo
        private string Carpeta { get { return Server.MapPath("~/Uploads/premios"); } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            try
            {
                foreach (E_Tema t in _temas.Listar()) ddlTema.Items.Add(new ListItem(t.DsNombre + (t.DsEstado == "1" ? "" : " (inactivo)"), t.Id.ToString()));
                foreach (E_Nivel n in _preguntas.ListarNiveles()) ddlNivel.Items.Add(new ListItem(n.DsNombre, n.Id.ToString()));
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("PremioForm.LlenarListas", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudieron cargar los temas y niveles");
                return;
            }

            if (IdEdicion == 0) { litTitulo.Text = "Nuevo premio"; lblAyudaImagen.Text = "PNG JPG GIF o WEBP de hasta 2 MB"; return; }
            CargarPremio();
        }

        private void CargarPremio()
        {
            E_Premio p;
            try { p = _servicio.ObtenerPorId(IdEdicion); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("PremioForm.CargarPremio", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar el premio");
                return;
            }

            if (p == null) { Response.Redirect("~/Pages/Premios.aspx"); return; } // va fuera del try por el threadabort
            litTitulo.Text = "Editar premio";
            ddlTema.SelectedValue = p.IdTema.ToString();
            ddlNivel.SelectedValue = p.IdNivel.ToString();
            txtNombre.Text = p.DsNombre;
            txtDescripcion.Text = p.DsDescripcion;
            txtPuntos.Text = p.NuPuntos.ToString();
            imgActual.ImageUrl = p.DsRutaImagen;
            imgActual.Visible = true;
            lblAyudaImagen.Text = "Si no eliges una imagen se queda la actual";
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            int idTema, idNivel, puntos;
            int.TryParse(ddlTema.SelectedValue, out idTema);
            int.TryParse(ddlNivel.SelectedValue, out idNivel);
            int.TryParse(txtPuntos.Text, out puntos); // si no es numero queda en 0 y negocios lo rechaza
            var p = new E_Premio { Id = IdEdicion, IdTema = idTema, IdNivel = idNivel, DsNombre = txtNombre.Text, DsDescripcion = txtDescripcion.Text, NuPuntos = puntos };
            byte[] imagen = fuImagen.HasFile ? fuImagen.FileBytes : null;
            try
            {
                if (IdEdicion == 0) _servicio.Registrar(UsuarioActual, p, imagen, Carpeta);
                else _servicio.Actualizar(UsuarioActual, p, imagen, Carpeta);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); return; }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("PremioForm.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar el premio");
                return;
            }
            Response.Redirect("~/Pages/Premios.aspx"); // todo bien vuelve a la lista
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}