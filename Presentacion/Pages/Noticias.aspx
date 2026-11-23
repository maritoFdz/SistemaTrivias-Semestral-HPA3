<%@ Page Title="Noticias" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Noticias.aspx.cs" Inherits="Presentacion.Pages.Noticias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h3 mb-0">Noticias</h1>
        <asp:HyperLink runat="server" NavigateUrl="~/Pages/NoticiaForm.aspx" CssClass="btn btn-primary">Nueva noticia</asp:HyperLink>
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:GridView ID="gvNoticias" runat="server" AutoGenerateColumns="false" CssClass="table table-striped align-middle" OnRowCommand="gvNoticias_RowCommand">
        <Columns>
            <asp:BoundField DataField="DtPublicacion" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
            <asp:BoundField DataField="DsTitulo" HeaderText="Título" />
            <asp:BoundField DataField="DsResumen" HeaderText="Resumen" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='badge <%# Eval("DsEstado").ToString() == "1" ? "bg-success" : "bg-secondary" %>'><%# Eval("DsEstado").ToString() == "1" ? "Publicada" : "Oculta" %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <a href='NoticiaForm.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-primary">Editar</a>
                    <asp:LinkButton runat="server" CommandName="CambiarEstado" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary" OnClientClick="return confirm('¿Cambiar el estado de esta noticia?');" Text='<%# Eval("DsEstado").ToString() == "1" ? "Ocultar" : "Publicar" %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.min.js"></script>
    <script>
        new DataTable('#<%= gvNoticias.ClientID %>', { language: { url: 'https://cdn.datatables.net/plug-ins/2.1.8/i18n/es-ES.json' }, order: [[0, 'desc']], columnDefs: [{ orderable: false, targets: [4] }] });
    </script>
</asp:Content>