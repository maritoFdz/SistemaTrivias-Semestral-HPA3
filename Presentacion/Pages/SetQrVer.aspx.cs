using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class SetQrVer : PaginaBase
    {
        private readonly ISetQrService _servicio = new N_SetQr();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        private int IdSet { get { int id; return int.TryParse(Request.QueryString["id"], out id) ? id : 0; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            txtBase.Text = (Request.QueryString["base"] ?? Request.Url.GetLeftPart(UriPartial.Authority) + Request.ApplicationPath.TrimEnd('/')).Trim(); // por defecto la direccion desde donde entra el admin
            Mostrar();
        }

        protected void btnActualizar_Click(object sender, EventArgs e) { Mostrar(); }

        private void Mostrar()
        {
            E_SetQr set;
            try { set = _servicio.ObtenerPorId(UsuarioActual, IdSet); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("SetQrVer.Mostrar", ex, UsuarioActual.DsCorreo);
                Aviso("No se pudo cargar el set");
                return;
            }
            if (set == null) { Aviso("El set no existe"); return; }

            try
            {
                string enlace = _servicio.ConstruirEnlace(txtBase.Text, set.DsCodigo); // valida la direccion
                string baseCodificada = Server.UrlEncode(txtBase.Text.Trim());
                litNombre.Text = Validador.CodificarHtml(set.DsNombre);
                litDetalle.Text = Validador.CodificarHtml(set.DsNombreTema + " · " + set.DsNombreNivel + " · " + set.NuCantidadPreguntas + " preguntas" + (set.DsEstado == "1" ? "" : " · INACTIVO"));
                litEnlace.Text = Validador.CodificarHtml(enlace);
                imgQr.ImageUrl = "~/Pages/QrImagen.ashx?id=" + set.Id + "&base=" + baseCodificada;
                lnkDescargar.NavigateUrl = "~/Pages/QrImagen.ashx?id=" + set.Id + "&descargar=1&base=" + baseCodificada;
                pnlQr.Visible = true;
            }
            catch (ArgumentException ex) { Aviso(ex.Message); pnlQr.Visible = true; imgQr.Visible = false; lnkDescargar.Visible = false; }
        }

        private void Aviso(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = "alert alert-danger d-block";
            lblMensaje.Visible = true;
            pnlQr.Visible = false;
        }
    }
}