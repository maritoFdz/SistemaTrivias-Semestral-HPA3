<%@ Page Title="Usuario" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="UsuarioForm.aspx.cs" Inherits="Presentacion.Pages.UsuarioForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h1 class="h4 mb-4"><asp:Literal ID="litTitulo" runat="server" /></h1>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtCedula" CssClass="form-label">Cédula</asp:Label>
                        <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" MaxLength="20" placeholder="8-123-456" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtNombre" CssClass="form-label">Nombre</asp:Label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="100" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtCorreo" CssClass="form-label">Correo</asp:Label>
                        <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email" MaxLength="100" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="ddlRol" CssClass="form-label">Rol</asp:Label>
                        <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-select" />
                    </div>

                    <div class="mb-4">
                        <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="form-label">Contraseña</asp:Label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="100" />
                        <asp:Label ID="lblAyudaPassword" runat="server" CssClass="form-text d-block" />
                    </div>

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Usuarios.aspx" CssClass="btn btn-outline-secondary">Cancelar</asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
</asp:Content>