<%@ Page Title="Imágenes de resultado" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="ImagenesResultado.aspx.cs" Inherits="Presentacion.Pages.ImagenesResultado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-2">
        <h1 class="h3 mb-0">Imágenes de resultado</h1>
        <asp:HyperLink runat="server" NavigateUrl="~/Pages/ImagenResultadoForm.aspx" CssClass="btn btn-primary">Nueva imagen</asp:HyperLink>
    </div>
    <p class="text-muted">Al terminar una partida se muestra la imagen activa con el mayor porcentaje mínimo que el jugador alcanzó. Crea una de 0% para que siempre haya una.</p>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:GridView ID="gvImagenes" runat="server" AutoGenerateColumns="false" CssClass="table table-striped align-middle" OnRowCommand="gvImagenes_RowCommand">
        <Columns>
            <asp:TemplateField HeaderText="Imagen">
                <ItemTemplate>
                    <img src='<%# ResolveUrl(Eval("DsRutaImagen").ToString()) %>' alt="resultado" style="width:72px;height:72px;object-fit:cover;" class="rounded" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="NuPorcentajeMinimo" HeaderText="Desde (%)" />
            <asp:BoundField DataField="DsMensaje" HeaderText="Mensaje" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='badge <%# Eval("DsEstado").ToString() == "1" ? "bg-success" : "bg-secondary" %>'><%# Eval("DsEstado").ToString() == "1" ? "Activa" : "Inactiva" %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <a href='ImagenResultadoForm.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-primary">Editar</a>
                    <asp:LinkButton runat="server" CommandName="CambiarEstado" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary" OnClientClick="return confirm('¿Cambiar el estado de esta imagen?');" Text='<%# Eval("DsEstado").ToString() == "1" ? "Desactivar" : "Activar" %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.min.js"></script>
    <script>
        new DataTable('#<%= gvImagenes.ClientID %>', { language: { url: 'https://cdn.datatables.net/plug-ins/2.1.8/i18n/es-ES.json' }, columnDefs: [{ orderable: false, targets: [0, 4] }] });
    </script>
</asp:Content>