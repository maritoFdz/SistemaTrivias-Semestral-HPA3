<%@ Page Title="Jugar" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Jugar.aspx.cs" Inherits="Presentacion.Pages.Jugar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <%-- paso 1: elegir tema --%>
    <asp:Panel ID="pnlTemas" runat="server">
        <h1 class="h3 mb-3">Elige un tema</h1>
        <asp:Label ID="lblSinTemas" runat="server" CssClass="alert alert-info d-block" Visible="false" Text="Todavía no hay temas con preguntas disponibles" />
        <div class="row g-3">
            <asp:Repeater ID="rpTemas" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <h2 class="h5"><%#: Eval("DsNombre") %></h2>
                                <p class="text-muted small flex-grow-1"><%#: Eval("DsDescripcion") %></p>
                                <div class="progress mb-1" style="height:8px;">
                                    <div class="progress-bar bg-success" style="width:<%# Eval("Porcentaje") %>%"></div>
                                </div>
                                <small class="text-muted mb-3"><%# Eval("NuAprobados") %> de <%# Eval("NuNiveles") %> niveles aprobados · <%# Eval("NuPuntos") %> pts</small>
                                <a href='Jugar.aspx?tema=<%# Eval("Id") %>' class="btn btn-primary">Ver niveles</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>

    <%-- paso 2: elegir nivel del tema --%>
    <asp:Panel ID="pnlNiveles" runat="server" Visible="false">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="h3 mb-0"><asp:Literal ID="litTema" runat="server" Mode="Encode" /></h1>
            <div class="d-flex gap-2">
                <a href='Calificar.aspx?tema=<%: Request.QueryString["tema"] %>' class="btn btn-outline-success">Calificar este tema</a>
                <a href="Jugar.aspx" class="btn btn-outline-secondary">Cambiar tema</a>
        </div>
        </div>
        <div class="list-group">
            <asp:Repeater ID="rpNiveles" runat="server" OnItemCommand="rpNiveles_ItemCommand">
                <ItemTemplate>
                    <div class="list-group-item p-3">
                        <div class="row align-items-center g-3">
                            <div class="col-md-5">
                                <h2 class="h5 mb-1"><%#: Eval("DsNombre") %>
                                    <span class='badge <%# (bool)Eval("Aprobado") ? "bg-success" : ((bool)Eval("Desbloqueado") ? "bg-primary" : "bg-secondary") %>'>
                                        <%# (bool)Eval("Aprobado") ? "Aprobado" : ((bool)Eval("Desbloqueado") ? "Disponible" : "Bloqueado") %>
                                    </span>
                                </h2>
                                <small class="text-muted"><%# Eval("NuPreguntas") %> preguntas en total · se aprueba con <%# Eval("NuPorcentajeAprobacion") %>%<br />
                                    Mejor resultado: <%# Eval("NuMejorPorcentaje", "{0:0}") %>% · Intentos: <%# Eval("NuIntentos") %></small>
                            </div>
                            <div class="col-md-4">
                                <%# (int)Eval("IdPremio") > 0 ? PremioHtml(Eval("DsPremioImagen"), Eval("DsPremioNombre"), (int)Eval("NuPremioPuntos"), (bool)Eval("PremioGanado")) : "" %>
                            </div>
                            <div class="col-md-3 text-md-end">
                                <asp:LinkButton runat="server" CommandName="Jugar" CommandArgument='<%# Eval("IdNivel") %>' CssClass="btn btn-success" Visible='<%# (bool)Eval("Desbloqueado") %>'>Jugar</asp:LinkButton>
                                <span class="text-muted small" <%# (bool)Eval("Desbloqueado") ? "style='display:none'" : "" %>>Aprueba el nivel anterior</span>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
</asp:Content>