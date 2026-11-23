using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class PreguntaForm : PaginaBase
    {
        private readonly IPreguntaService _servicio = new N_Pregunta();
        private readonly ITemaService _temas = new N_Tema();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        private int IdEdicion { get { return int.TryParse(Request.QueryString["id"], out int id) ? id : 0; } } // 0 es pregunta nueva
        private string TipoActual { get { return IdEdicion == 0 ? ddlTipo.SelectedValue : (string)ViewState["Tipo"]; } } // al editar el tipo queda fijo

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            try { LlenarListas(); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("PreguntaForm.LlenarListas", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudieron cargar los temas y niveles");
                return;
            }

            if (IdEdicion == 0) { litTitulo.Text = "Nueva pregunta"; return; }
            CargarPregunta();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            pnlMultiple.Visible = TipoActual == TiposPregunta.OpcionMultiple;
            pnlVF.Visible = TipoActual == TiposPregunta.VerdaderoFalso;
        }

        protected void ddlTipo_SelectedIndexChanged(object sender, EventArgs e) { } // el prerender cambia los paneles

        private void LlenarListas()
        {
            foreach (E_Tema t in _temas.Listar()) ddlTema.Items.Add(new ListItem(t.DsNombre + (t.DsEstado == "1" ? "" : " (inactivo)"), t.Id.ToString()));
            foreach (E_Nivel n in _servicio.ListarNiveles()) ddlNivel.Items.Add(new ListItem(n.DsNombre, n.Id.ToString()));
            ddlTipo.Items.Add(new ListItem("Opción múltiple", TiposPregunta.OpcionMultiple));
            ddlTipo.Items.Add(new ListItem("Verdadero / Falso", TiposPregunta.VerdaderoFalso));
            foreach (string letra in new[] { "A", "B", "C", "D" }) ddlCorrecta.Items.Add(letra);
            rblVF.Items.Add("Verdadero");
            rblVF.Items.Add("Falso");
            rblVF.SelectedIndex = 0;
        }

        private void CargarPregunta()
        {
            E_Pregunta p;
            try { p = _servicio.ObtenerPorId(IdEdicion); }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("PreguntaForm.CargarPregunta", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo cargar la pregunta");
                return;
            }

            if (p == null) { Response.Redirect("~/Pages/Preguntas.aspx"); return; } // va fuera del try por el threadabort
            litTitulo.Text = "Editar pregunta";
            ViewState["Tipo"] = p.DsTipo;
            ddlTipo.SelectedValue = p.DsTipo;
            ddlTipo.Enabled = false;
            ddlTema.SelectedValue = p.IdTema.ToString();
            ddlNivel.SelectedValue = p.IdNivel.ToString();
            txtEnunciado.Text = p.DsEnunciado;
            txtPuntos.Text = p.NuPuntos.ToString();
            txtSegundos.Text = p.NuSegundos.ToString();

            int correcta = p.Opciones.FindIndex(o => o.NuEsCorrecta);
            if (p.DsTipo == TiposPregunta.VerdaderoFalso) { rblVF.SelectedIndex = correcta; return; }
            txtOp1.Text = p.Opciones[0].DsTexto;
            txtOp2.Text = p.Opciones[1].DsTexto;
            txtOp3.Text = p.Opciones[2].DsTexto;
            txtOp4.Text = p.Opciones[3].DsTexto;
            ddlCorrecta.SelectedIndex = correcta;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            int.TryParse(txtPuntos.Text, out int puntos); // si no es numero queda en 0 y negocios lo rechaza
            int.TryParse(txtSegundos.Text, out int segundos);
            var p = new E_Pregunta { Id = IdEdicion, DsTipo = TipoActual, DsEnunciado = txtEnunciado.Text, NuPuntos = puntos, NuSegundos = segundos };
            int.TryParse(ddlTema.SelectedValue, out int idTema);
            int.TryParse(ddlNivel.SelectedValue, out int idNivel);
            p.IdTema = idTema;
            p.IdNivel = idNivel;

            if (p.DsTipo == TiposPregunta.VerdaderoFalso)
            {
                p.Opciones.Add(new E_Opcion { DsTexto = "Verdadero", NuEsCorrecta = rblVF.SelectedIndex == 0 });
                p.Opciones.Add(new E_Opcion { DsTexto = "Falso", NuEsCorrecta = rblVF.SelectedIndex == 1 });
            }
            else
            {
                string[] textos = { txtOp1.Text, txtOp2.Text, txtOp3.Text, txtOp4.Text };
                for (int i = 0; i < 4; i++) p.Opciones.Add(new E_Opcion { DsTexto = textos[i], NuEsCorrecta = ddlCorrecta.SelectedIndex == i });
            }

            try
            {
                if (IdEdicion == 0) _servicio.Registrar(UsuarioActual, p);
                else _servicio.Actualizar(UsuarioActual, p);
            }
            catch (ArgumentException ex) { Mostrar(ex.Message); return; }
            catch (InvalidOperationException ex) { Mostrar(ex.Message); return; }
            catch (UnauthorizedAccessException ex) { Mostrar(ex.Message); return; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("PreguntaForm.btnGuardar_Click", ex, UsuarioActual.DsCorreo);
                Mostrar("No se pudo guardar la pregunta");
                return;
            }
            Response.Redirect("~/Pages/Preguntas.aspx"); // todo bien vuelve a la lista
        }

        private void Mostrar(string mensaje)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.Visible = true;
        }
    }
}