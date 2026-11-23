<%@ Page Title="Crear cuenta" Language="C#" MasterPageFile="~/Publica.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="Presentacion.Pages.Registro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <h1 class="h4 text-center mb-1">Crea tu cuenta</h1>
                        <p class="text-center text-muted small mb-4">Regístrate y empieza a jugar de inmediato</p>

                        <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

                        <div class="mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtNombre" CssClass="form-label">Nombre</asp:Label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="100" />
                        </div>

                        <div class="mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtCedula" CssClass="form-label">Cédula</asp:Label>
                            <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" MaxLength="20" placeholder="8-123-456" />
                        </div>

                        <div class="mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtCorreo" CssClass="form-label">Correo</asp:Label>
                            <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email" MaxLength="100" />
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="form-label">Contraseña</asp:Label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="100" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <asp:Label runat="server" AssociatedControlID="txtConfirmar" CssClass="form-label">Repite la contraseña</asp:Label>
                                <asp:TextBox ID="txtConfirmar" runat="server" CssClass="form-control" TextMode="Password" MaxLength="100" />
                            </div>
                        </div>

                        <%-- campo trampa: una persona no lo ve y un robot si lo llena --%>
                        <div style="position:absolute;left:-5000px;" aria-hidden="true">
                            <asp:TextBox ID="txtWeb" runat="server" TabIndex="-1" autocomplete="off" />
                        </div>

                        <div class="mb-4">
                            <asp:Label runat="server" AssociatedControlID="txtCaptcha" CssClass="form-label">Verificación: ¿cuánto es <strong><asp:Label ID="lblCaptcha" runat="server" /></strong>?</asp:Label>
                            <asp:TextBox ID="txtCaptcha" runat="server" CssClass="form-control" TextMode="Number" MaxLength="3" />
                        </div>

                        <asp:Button ID="btnRegistrar" runat="server" Text="Crear cuenta y jugar" CssClass="btn btn-success w-100" OnClick="btnRegistrar_Click" />
                        <p class="text-center small mt-3 mb-0">¿Ya tienes cuenta? <a href="Login.aspx">Inicia sesión</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>