<%@ Page Title="Calificaciones" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Calificaciones.aspx.cs" Inherits="Presentacion.Pages.Calificaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="h3 mb-3">Calificaciones de los jugadores</h1>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <h2 class="h5">Promedio por tema <small class="text-muted">(1 regular, 2 medio, 3 bastante, 4 mucho)</small></h2>
    <asp:GridView ID="gvResumen" runat="server" AutoGenerateColumns="false" CssClass="table table-striped align-middle mb-4">
        <Columns>
            <asp:BoundField DataField="DsNombreTema" HeaderText="Tema" />
            <asp:BoundField DataField="NuCalificaciones" HeaderText="Calificaciones" />
            <asp:BoundField DataField="NuPromedioTema" HeaderText="Promedio del tema" DataFormatString="{0:0.00}" />
            <asp:BoundField DataField="NuPromedioApp" HeaderText="Promedio de la app" DataFormatString="{0:0.00}" />
        </Columns>
    </asp:GridView>

    <h2 class="h5">Comentarios y temas sugeridos</h2>
    <asp:GridView ID="gvLista" runat="server" AutoGenerateColumns="false" CssClass="table table-striped align-middle">
        <Columns>
            <asp:BoundField DataField="DtFecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="DsNombreUsuario" HeaderText="Jugador" />
            <asp:BoundField DataField="DsNombreTema" HeaderText="Tema" />
            <asp:TemplateField HeaderText="Tema">
                <ItemTemplate><%# NivelesTexto(Eval("NuCalifTema")) %></ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="App">
                <ItemTemplate><%# NivelesTexto(Eval("NuCalifApp")) %></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="DsTemaSugerido" HeaderText="Tema sugerido" />
            <asp:BoundField DataField="DsComentario" HeaderText="Comentario" />
        </Columns>
    </asp:GridView>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.min.js"></script>
    <script>
        new DataTable('#<%= gvLista.ClientID %>', { language: { url: 'https://cdn.datatables.net/plug-ins/2.1.8/i18n/es-ES.json' }, order: [[0, 'desc']] });
    </script>
</asp:Content>