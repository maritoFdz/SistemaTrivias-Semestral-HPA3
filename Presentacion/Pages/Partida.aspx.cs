using System;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Partida : PaginaBase
    {
        private readonly IJuegoService _servicio = new N_Juego();
        private E_PartidaEnCurso _partida;
        protected int SegundosTotales;
        protected int SegundosRestantes;

        protected void Page_Load(object sender, EventArgs e)
        {
            _partida = Session["Partida"] as E_PartidaEnCurso;
            if (_partida == null || _partida.IdUsuario != UsuarioActual.Id) Response.Redirect("~/Pages/Jugar.aspx"); // sin partida no hay nada que mostrar
            if (!IsPostBack) MostrarPregunta();
        }

        private void MostrarPregunta()
        {
            try
            {
                E_Pregunta q = _servicio.ObtenerPregunta(UsuarioActual, _partida);
                Session["Partida"] = _partida;
                litNumero.Text = "Pregunta " + (_partida.Indice + 1) + " de " + _partida.Total;
                litPuntos.Text = q.NuPuntos.ToString();
                litEnunciado.Text = q.DsEnunciado;
                SegundosTotales = q.NuSegundos;
                SegundosRestantes = _servicio.SegundosRestantes(_partida, q);
                pnlPregunta.Visible = !_partida.EsperandoSiguiente;
                pnlFeedback.Visible = _partida.EsperandoSiguiente;
                if (_partida.EsperandoSiguiente) MostrarFeedback();
                else
                {
                    rpOpciones.DataSource = q.Opciones;
                    rpOpciones.DataBind();
                }
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Partida.MostrarPregunta", ex, UsuarioActual.DsCorreo);
                pnlJuego.Visible = false;
                Mostrar("No se pudo cargar la pregunta", false);
            }
        }

        private void MostrarFeedback()
        {
            E_RespuestaResultado r = _partida.Ultima;
            if (r.Correcta)
            {
                lblFeedback.CssClass = "alert alert-success d-block";
                lblFeedback.Text = "¡Correcto! Ganaste " + r.PuntosGanados + " puntos";
            }
            else
            {
                lblFeedback.CssClass = "alert alert-danger d-block";
                lblFeedback.Text = (r.TiempoAgotado ? "Se acabó el tiempo. " : "Incorrecto. ") + "La respuesta correcta era: " + Validador.CodificarHtml(r.TextoCorrecta); // el label no codifica solo
            }
            btnSiguiente.Text = _partida.Indice + 1 >= _partida.Total ? "Ver resultado" : "Siguiente pregunta";
        }

        protected void btnResponder_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.Form["opcion"], out int id)) // el radio se lee directo del form
            {
                MostrarPregunta();
                Mostrar("Elige una opción antes de responder", false);
                return;
            }
            Responder(id);
        }

        protected void btnTiempo_Click(object sender, EventArgs e)
        {
            Responder(null);
        }

        private void Responder(int? idOpcion)
        {
            if (_partida.EsperandoSiguiente) { MostrarPregunta(); return; } // ya estaba respondida
            string error = null;
            try
            {
                _servicio.Responder(UsuarioActual, _partida, idOpcion);
                Session["Partida"] = _partida;
            }
            catch (ArgumentException ex) { error = ex.Message; }
            catch (InvalidOperationException ex) { error = ex.Message; }
            catch (UnauthorizedAccessException ex) { error = ex.Message; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Partida.Responder", ex, UsuarioActual.DsCorreo);
                error = "No se pudo registrar la respuesta";
            }
            MostrarPregunta();
            if (error != null) Mostrar(error, false);
        }

        protected void btnSiguiente_Click(object sender, EventArgs e)
        {
            bool termino = false;
            string error = null;
            try
            {
                termino = _servicio.Avanzar(UsuarioActual, _partida);
                Session["Partida"] = _partida;
            }
            catch (InvalidOperationException ex) { error = ex.Message; }
            catch (UnauthorizedAccessException ex) { error = ex.Message; }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Partida.Avanzar", ex, UsuarioActual.DsCorreo);
                error = "No se pudo continuar";
            }
            if (termino)
            {
                int id = _partida.IdPartida;
                Session.Remove("Partida");
                Response.Redirect("~/Pages/Resultado.aspx?id=" + id); // va fuera del try por el threadabort
                return;
            }
            MostrarPregunta();
            if (error != null) Mostrar(error, false);
        }

        private void Mostrar(string mensaje, bool ok)
        {
            lblMensaje.Text = Validador.CodificarHtml(mensaje);
            lblMensaje.CssClass = ok ? "alert alert-success d-block" : "alert alert-danger d-block";
            lblMensaje.Visible = true;
        }
    }
}