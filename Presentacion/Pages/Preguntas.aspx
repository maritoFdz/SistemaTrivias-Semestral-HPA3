<%@ Page Title="Preguntas" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Preguntas.aspx.cs" Inherits="Presentacion.Pages.Preguntas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h3 mb-0">Preguntas</h1>
        <asp:HyperLink runat="server" NavigateUrl="~/Pages/PreguntaForm.aspx" CssClass="btn btn-primary">Nueva pregunta</asp:HyperLink>
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:GridView ID="gvPreguntas" runat="server" AutoGenerateColumns="false" CssClass="table table-striped" OnRowCommand="gvPreguntas_RowCommand">
        <Columns>
            <asp:BoundField DataField="DsNombreTema" HeaderText="Tema" />
            <asp:BoundField DataField="DsNombreNivel" HeaderText="Nivel" />
            <asp:TemplateField HeaderText="Tipo">
                <ItemTemplate><%# Eval("DsTipo").ToString() == "VERDADERO_FALSO" ? "Verdadero / Falso" : "Opción múltiple" %></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="DsEnunciado" HeaderText="Pregunta" />
            <asp:BoundField DataField="NuPuntos" HeaderText="Puntos" />
            <asp:BoundField DataField="NuSegundos" HeaderText="Seg." />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='badge <%# Eval("DsEstado").ToString() == "1" ? "bg-success" : "bg-secondary" %>'><%# Eval("DsEstado").ToString() == "1" ? "Activa" : "Inactiva" %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <a href='PreguntaForm.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-primary">Editar</a>
                    <asp:LinkButton runat="server" CommandName="CambiarEstado" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary" OnClientClick="return confirm('¿Cambiar el estado de esta pregunta?');" Text='<%# Eval("DsEstado").ToString() == "1" ? "Desactivar" : "Activar" %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.min.js"></script>
    <script>
        new DataTable('#<%= gvPreguntas.ClientID %>', { language: { url: 'https://cdn.datatables.net/plug-ins/2.1.8/i18n/es-ES.json' } });
    </script>
</asp:Content>