<%@ Page Title="Avatares" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Avatares.aspx.cs" Inherits="Presentacion.Pages.Avatares" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Avatares</h1>
        <asp:HyperLink runat="server" NavigateUrl="~/Pages/AvatarForm.aspx" CssClass="btn btn-primary">Nuevo avatar</asp:HyperLink>
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:Label ID="lblVacio" runat="server" CssClass="alert alert-info d-block" Visible="false" Text="Todavía no hay avatares. Crea el primero con el botón de arriba" />

    <asp:Repeater ID="rpAvatares" runat="server" OnItemCommand="rpAvatares_ItemCommand">
        <HeaderTemplate><div class="row g-4"></HeaderTemplate>
        <ItemTemplate>
            <div class="col-6 col-md-4 col-lg-3">
                <div class='card h-100 shadow-sm text-center <%# (int)Eval("Id") == AvatarActualId ? "border-primary border-2" : "" %>'>
                    <img src='<%# ResolveUrl(Eval("DsRutaImagen").ToString()) %>' alt="avatar" class='rounded-circle mx-auto mt-3 <%# Eval("DsEstado").ToString() == "1" ? "" : "opacity-25" %>' style="width:130px;height:130px;object-fit:cover;" />
                    <div class="card-body">
                        <h2 class="h6 mb-1"><%#: Eval("DsNombre") %></h2>
                        <span class='badge <%# Eval("DsEstado").ToString() == "1" ? "bg-success" : "bg-secondary" %>'><%# Eval("DsEstado").ToString() == "1" ? "Activo" : "Inactivo" %></span>
                        <asp:PlaceHolder runat="server" Visible='<%# EsGestor %>'>
                            <div class="small text-muted mt-1"><%#: Eval("DsNombreUsuario") %></div>
                        </asp:PlaceHolder>
                    </div>
                    <div class="card-footer bg-white border-0 pb-3">
                        <asp:LinkButton runat="server" CommandName="Usar" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-primary" Text="Usar" Visible='<%# Eval("DsEstado").ToString() == "1" && (int)Eval("IdUsuario") == UsuarioActual.Id && (int)Eval("Id") != AvatarActualId %>' />
                        <a href='AvatarForm.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-primary">Editar</a>
                        <asp:LinkButton runat="server" CommandName="CambiarEstado" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary" OnClientClick="return confirm('¿Cambiar el estado de este avatar?');" Text='<%# Eval("DsEstado").ToString() == "1" ? "Desactivar" : "Activar" %>' />
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>