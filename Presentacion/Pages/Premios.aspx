<%@ Page Title="Premios" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Premios.aspx.cs" Inherits="Presentacion.Pages.Premios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h3 mb-0">Premios</h1>
        <asp:HyperLink runat="server" NavigateUrl="~/Pages/PremioForm.aspx" CssClass="btn btn-primary">Nuevo premio</asp:HyperLink>
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:GridView ID="gvPremios" runat="server" AutoGenerateColumns="false" CssClass="table table-striped align-middle" OnRowCommand="gvPremios_RowCommand">
        <Columns>
            <asp:TemplateField HeaderText="Imagen">
                <ItemTemplate>
                    <img src='<%# ResolveUrl(Eval("DsRutaImagen").ToString()) %>' alt="premio" style="width:56px;height:56px;object-fit:cover;" class="rounded" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="DsNombreTema" HeaderText="Tema" />
            <asp:BoundField DataField="DsNombreNivel" HeaderText="Nivel" />
            <asp:BoundField DataField="DsNombre" HeaderText="Premio" />
            <asp:BoundField DataField="NuPuntos" HeaderText="Puntos" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='badge <%# Eval("DsEstado").ToString() == "1" ? "bg-success" : "bg-secondary" %>'><%# Eval("DsEstado").ToString() == "1" ? "Activo" : "Inactivo" %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <a href='PremioForm.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-primary">Editar</a>
                    <asp:LinkButton runat="server" CommandName="CambiarEstado" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary" OnClientClick="return confirm('¿Cambiar el estado de este premio?');" Text='<%# Eval("DsEstado").ToString() == "1" ? "Desactivar" : "Activar" %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.min.js"></script>
    <script>
        new DataTable('#<%= gvPremios.ClientID %>', { language: { url: 'https://cdn.datatables.net/plug-ins/2.1.8/i18n/es-ES.json' }, columnDefs: [{ orderable: false, targets: [0, 6] }] });
    </script>
</asp:Content>