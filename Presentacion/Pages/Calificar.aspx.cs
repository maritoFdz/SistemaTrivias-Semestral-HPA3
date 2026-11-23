using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Calificar : PaginaBase
    {
        private readonly ICalificacionService _servicio = new N_Calificacion();
        private readonly IJuegoService _juego = new N_Juego();

        private int IdTema { get { int id; return int.TryParse(Request.QueryString["tema"], out id) ? id : 0; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            if (IdTema == 0) Response.Redirect("~/Pages/Jugar.aspx"); // sin tema no hay que calificar
            for (int i = 1; i <= 4; i++) // las dos listas tienen las mismas 4 opciones
            {
                rblTema.Items.Add(new ListItem(NivelesCalificacion.Texto(i), i.ToString()));
                rblApp.Items.Add(new ListItem(NivelesCalificacion.Texto(i), i.ToString()));
            }
            Cargar();
        }

        private void Cargar()
        {
            try
            {
                E_TemaProgreso tema = _juego.ListarTemas(UsuarioActual).Find(t => t.Id == IdTema);
                if (tema == null) { pnlForm.Visible = false; Mostrar("El tema no está disponible", false); return; }
                litTema.Text = tema.DsNombre;

                E_Calificacion previa = _servicio.Obtener(UsuarioActual, IdTema); // si ya califico se rellena para que pueda cambiarla
                if (previa == null) return;
                rblTema.SelectedValue = previa.NuCalifTema.ToString();
                rblApp.SelectedValue = previa.NuCalifApp.ToString();
                txtSugerido.Text = previa.DsTemaSugerido;
                txtComentario.Text = previa.DsComentario;
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Calificar.Cargar", ex, UsuarioActual.DsCorreo);
                pnlForm.Visible = false;
                Mostrar("No se pudo cargar el formulario", false);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            int tema, app;
            int.TryParse(rblTema.SelectedValue, out tema); // sin elegir queda en 0 y negocios lo rechaza
            int.TryParse(rblApp.SelectedValue, out app);
            var c = new E_Calificacion { IdTema = IdTema, NuCalifTema = tema, NuCalifApp = app, DsTemaSugerido = txtSugerido.Text, DsComentario = txtComentario.Text };
            try
            {
                _servicio.Guardar(UsuarioActual, c);
                pnlForm.Visible = false;
                Mostrar("¡Gracias por tu opinión!", true);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message, false); }
            catch (InvalidOperationException ex) { Mostrar(ex.Message, false); }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message, false); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Calificar.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar la calificación", false);
            }
        }

        private void Mostrar(string mensaje, bool ok)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = ok ? "alert alert-success d-block" : "alert alert-danger d-block";
            lblMensaje.Visible = true;
        }
    }
}