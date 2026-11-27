<%@ Page Title="Resultado" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Resultado.aspx.cs" Inherits="Presentacion.Pages.Resultado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:Panel ID="pnlResultado" runat="server">
        <div class="card shadow-sm text-center">
            <div class="card-body p-4">
                <p class="text-muted mb-1"><%: Res.DsNombreTema %> · <%: Res.DsNombreNivel %></p>
                <% if (!string.IsNullOrEmpty(Res.DsImagenResultado)) { %>
                <img src="<%: ResolveUrl(Res.DsImagenResultado) %>" alt="resultado" class="img-fluid rounded mb-3" style="max-height:260px;" />
                <% } %>
                <h1 class="h3"><%: Res.DsMensajeResultado %></h1>
                <p class="display-5 mb-1"><%: Res.NuPorcentaje.ToString("0") %>%</p>
                <span class='badge fs-6 <%= Res.Aprobado ? "bg-success" : "bg-danger" %>'><%= Res.Aprobado ? "Nivel aprobado" : "Nivel no aprobado" %></span>
                <p class="text-muted mt-2">Se necesita <%: Res.NuPorcentajeAprobacion %>% para aprobar</p>

                <div class="row g-3 my-3 justify-content-center">
                    <div class="col-6 col-md-3"><div class="border rounded p-2"><div class="h4 mb-0"><%: Res.NuAciertos %> / <%: Res.NuTotalPreguntas %></div><small class="text-muted">Aciertos</small></div></div>
                    <div class="col-6 col-md-3"><div class="border rounded p-2"><div class="h4 mb-0"><%: Res.NuPuntos %></div><small class="text-muted">Puntos</small></div></div>
                    <div class="col-6 col-md-3"><div class="border rounded p-2"><div class="h4 mb-0"><%: Res.NuSegundosTotal %> s</div><small class="text-muted">Tiempo total</small></div></div>
                </div>

                <% if (Res.IdPremio > 0) { %>
                <div class="alert alert-warning d-inline-flex align-items-center gap-3 text-start">
                    <img src="<%: ResolveUrl(Res.DsPremioImagen) %>" alt="premio" style="width:64px;height:64px;object-fit:cover;" class="rounded" />
                    <div><strong>¡Ganaste un premio!</strong><br /><%: Res.DsPremioNombre %> · +<%: Res.NuPremioPuntos %> pts</div>
                </div>
                <% } %>
                <% if (Res.Aprobado && Res.IdSiguienteNivel > 0) { %>
                <p class="text-success">Desbloqueaste el siguiente nivel</p>
                <% } %>

                <div class="d-flex gap-2 justify-content-center mt-3">
                    <a href='Jugar.aspx?tema=<%: Res.IdTema %>' class="btn btn-primary">Volver a los niveles</a>
                    <a href="Ranking.aspx" class="btn btn-outline-secondary">Ver ranking</a>
                    <a href='Calificar.aspx?tema=<%: Res.IdTema %>' class="btn btn-outline-success">Calificar este tema</a>
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <% if (Res != null) { %>
    <audio id="sfxFinal" src="<%= ResolveUrl(Res.Aprobado ? "~/Audio/victoria.wav" : "~/Audio/derrota.wav") %>" preload="auto"></audio>
    <% } %>
    <script>
        sessionStorage.removeItem('musicaPos'); // la proxima partida empieza la cancion desde cero
        (function () {
            var a = document.getElementById('sfxFinal');
            if (!a || sessionStorage.getItem('mute') === '1') return; // respeta el boton de silencio
            a.volume = 0.6;
            a.play().catch(function () { });
        })();
    </script>
</asp:Content>