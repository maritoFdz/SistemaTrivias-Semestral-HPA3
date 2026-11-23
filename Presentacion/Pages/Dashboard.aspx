<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Presentacion.Pages.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h3 mb-0">Bienvenido, <asp:Literal ID="litNombre" runat="server" Mode="Encode" /></h1>
            <p class="text-muted mb-0">Rol: <asp:Label ID="lblRol" runat="server" /></p>
        </div>
        <div class="d-flex gap-2">
            <a href="Jugar.aspx" class="btn btn-success">Jugar</a>
            <a href="Ranking.aspx" class="btn btn-outline-secondary">Ranking</a>
        </div>
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:Panel ID="pnlResumen" runat="server">
        <div class="row g-3 mb-4 text-center">
            <div class="col-6 col-md-3"><div class="card shadow-sm"><div class="card-body"><div class="h2 mb-0"><asp:Literal ID="litPuntos" runat="server" /></div><small class="text-muted">Puntos</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card shadow-sm"><div class="card-body"><div class="h2 mb-0"><asp:Literal ID="litPartidas" runat="server" /></div><small class="text-muted">Partidas jugadas</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card shadow-sm"><div class="card-body"><div class="h2 mb-0"><asp:Literal ID="litNiveles" runat="server" /></div><small class="text-muted">Niveles aprobados</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card shadow-sm"><div class="card-body"><div class="h2 mb-0"><asp:Literal ID="litPremios" runat="server" /></div><small class="text-muted">Premios</small></div></div></div>
        </div>

        <h2 class="h5">Mis premios</h2>
        <asp:Label ID="lblSinPremios" runat="server" CssClass="text-muted" Visible="false" Text="Todavía no has ganado premios. ¡Aprueba niveles para conseguirlos!" />
        <div class="row g-3">
            <asp:Repeater ID="rpPremios" runat="server">
                <ItemTemplate>
                    <div class="col-6 col-md-3 col-lg-2">
                        <div class="card h-100 text-center shadow-sm">
                            <img src='<%# ResolveUrl(Eval("DsRutaImagen").ToString()) %>' alt="premio" class="card-img-top" style="height:110px;object-fit:cover;" />
                            <div class="card-body p-2">
                                <div class="small fw-bold"><%#: Eval("DsNombre") %></div>
                                <div class="small text-muted"><%#: Eval("DsNombreTema") %> · <%#: Eval("DsNombreNivel") %></div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
</asp:Content>