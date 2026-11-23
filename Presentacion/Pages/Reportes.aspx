<%@ Page Title="Reportes" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="Presentacion.Pages.Reportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h3 mb-0">Reportes</h1>
        <asp:Button ID="btnExcel" runat="server" Text="Descargar Excel" CssClass="btn btn-success" OnClick="btnExcel_Click" />
    </div>
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:Panel ID="pnlReporte" runat="server">
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3"><div class="card text-center shadow-sm"><div class="card-body"><div class="h3 mb-0"><asp:Literal ID="litJugadores" runat="server" /></div><small class="text-muted">Jugadores que han jugado</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card text-center shadow-sm"><div class="card-body"><div class="h3 mb-0"><asp:Literal ID="litPartidas" runat="server" /></div><small class="text-muted">Partidas jugadas</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card text-center shadow-sm"><div class="card-body"><div class="h3 mb-0"><asp:Literal ID="litPromedio" runat="server" /></div><small class="text-muted">Puntos promedio por partida</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card text-center shadow-sm"><div class="card-body"><div class="h5 mb-0"><asp:Literal ID="litPopular" runat="server" /></div><small class="text-muted">Tema más popular</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card text-center shadow-sm"><div class="card-body"><div class="h3 mb-0"><asp:Literal ID="litSegResp" runat="server" /></div><small class="text-muted">Segundos promedio por respuesta</small></div></div></div>
            <div class="col-6 col-md-3"><div class="card text-center shadow-sm"><div class="card-body"><div class="h3 mb-0"><asp:Literal ID="litQr" runat="server" /></div><small class="text-muted">Partidas jugadas por QR</small></div></div></div>
        </div>

        <h2 class="h5">Jugadores por nivel</h2>
        <div class="card shadow-sm mb-4"><div class="card-body">
            <asp:Repeater ID="rpDistribucion" runat="server">
                <ItemTemplate>
                    <div class="d-flex align-items-center mb-2">
                        <div style="width:140px;"><%# Eval("DsNombre") %></div>
                        <div class="progress flex-grow-1" style="height:22px;"><div class="progress-bar" style='width:<%# Porcentaje(Eval("NuJugadores")) %>%'><%# Eval("NuJugadores") %></div></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <small class="text-muted">El nivel de cada jugador es el más alto en el que ha jugado. Sin jugar: <asp:Literal ID="litSinJugar" runat="server" /></small>
        </div></div>

        <h2 class="h5">Avance por jugador</h2>
        <asp:GridView ID="gvAvance" runat="server" AutoGenerateColumns="false" CssClass="table table-striped align-middle">
            <Columns>
                <asp:BoundField DataField="DsNombre" HeaderText="Jugador" HtmlEncode="true" />
                <asp:BoundField DataField="DsNombreTema" HeaderText="Tema" HtmlEncode="true" />
                <asp:BoundField DataField="DsNivelMaximo" HeaderText="Nivel más alto" HtmlEncode="true" />
                <asp:TemplateField HeaderText="Avance">
                    <ItemTemplate>
                        <div class="progress" style="height:18px;min-width:90px;"><div class="progress-bar bg-success" style='width:<%# Eval("NuAvance") %>%'><%# Eval("NuAvance") %>%</div></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="NuPuntos" HeaderText="Puntos" />
                <asp:BoundField DataField="NuPartidas" HeaderText="Partidas" />
                <asp:BoundField DataField="NuSegPromRespuesta" HeaderText="Seg. por respuesta" DataFormatString="{0:0.0}" />
                <asp:BoundField DataField="NuSegEntreNiveles" HeaderText="Seg. entre niveles" DataFormatString="{0:0}" NullDisplayText="-" />
            </Columns>
        </asp:GridView>
    </asp:Panel>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.min.js"></script>
    <script>
        if (document.getElementById('<%= gvAvance.ClientID %>')) new DataTable('#<%= gvAvance.ClientID %>', { language: { url: 'https://cdn.datatables.net/plug-ins/2.1.8/i18n/es-ES.json' } });
    </script>
</asp:Content>