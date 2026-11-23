using System;
using System.Web.UI.WebControls;
using Entidades;
using Negocios.Servicios;
using Negocios.Utilidades;
using Presentacion.Clases;

namespace Presentacion.Pages
{
    public partial class Calificaciones : PaginaBase
    {
        private readonly ICalificacionService _servicio = new N_Calificacion();

        protected override string[] RolesPermitidos { get { return new[] { Roles.Admin, Roles.Operativo }; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Cargar();
        }

        private void Cargar()
        {
            try
            {
                gvResumen.DataSource = _servicio.Resumen(UsuarioActual);
                gvResumen.DataBind();
                gvLista.DataSource = _servicio.Listar(UsuarioActual);
                gvLista.DataBind();
                if (gvLista.Rows.Count > 0) gvLista.HeaderRow.TableSection = TableRowSection.TableHeader; // datatables necesita el thead
            }
            catch (Exception ex)
            {
                ManejadorErrores.Registrar("Calificaciones.Cargar", ex, UsuarioActual.DsCorreo);
                lblMensaje.Text = "No se pudieron cargar las calificaciones";
                lblMensaje.CssClass = "alert alert-danger d-block";
                lblMensaje.Visible = true;
            }
        }

        protected string NivelesTexto(object valor)
        {
            return NivelesCalificacion.Texto(Convert.ToInt32(valor));
        }
    }
}