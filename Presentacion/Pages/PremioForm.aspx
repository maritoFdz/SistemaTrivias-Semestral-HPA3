<%@ Page Title="Premio" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="PremioForm.aspx.cs" Inherits="Presentacion.Pages.PremioForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-9 col-lg-7">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h1 class="h4 mb-4"><asp:Literal ID="litTitulo" runat="server" /></h1>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

                    <asp:Image ID="imgActual" runat="server" Visible="false" CssClass="rounded d-block mx-auto mb-3" Width="120" Height="120" Style="object-fit:cover;" />

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="ddlTema" CssClass="form-label">Tema</asp:Label>
                            <asp:DropDownList ID="ddlTema" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="ddlNivel" CssClass="form-label">Nivel que se debe aprobar</asp:Label>
                            <asp:DropDownList ID="ddlNivel" runat="server" CssClass="form-select" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtNombre" CssClass="form-label">Nombre del premio</asp:Label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="80" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtDescripcion" CssClass="form-label">Descripción</asp:Label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" MaxLength="255" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtPuntos" CssClass="form-label">Puntos extra que da el premio</asp:Label>
                        <asp:TextBox ID="txtPuntos" runat="server" CssClass="form-control" TextMode="Number" Text="50" />
                    </div>

                    <div class="mb-4">
                        <asp:Label runat="server" AssociatedControlID="fuImagen" CssClass="form-label">Imagen</asp:Label>
                        <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" accept=".png,.jpg,.jpeg,.gif,.webp" />
                        <asp:Label ID="lblAyudaImagen" runat="server" CssClass="form-text d-block" />
                    </div>

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Premios.aspx" CssClass="btn btn-outline-secondary">Cancelar</asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>