<%@ Page Title="Noticia" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="NoticiaForm.aspx.cs" Inherits="Presentacion.Pages.NoticiaForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h1 class="h4 mb-4"><asp:Literal ID="litTitulo" runat="server" /></h1>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

                    <asp:Image ID="imgActual" runat="server" Visible="false" CssClass="rounded d-block mx-auto mb-3" Height="120" />

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtTitulo" CssClass="form-label">Título</asp:Label>
                        <asp:TextBox ID="txtTitulo" runat="server" CssClass="form-control" MaxLength="150" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtResumen" CssClass="form-label">Resumen (se ve en la portada)</asp:Label>
                        <asp:TextBox ID="txtResumen" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" MaxLength="300" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtContenido" CssClass="form-label">Contenido</asp:Label>
                        <asp:TextBox ID="txtContenido" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" />
                    </div>

                    <div class="mb-4">
                        <asp:Label runat="server" AssociatedControlID="fuImagen" CssClass="form-label">Imagen (opcional)</asp:Label>
                        <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" accept=".png,.jpg,.jpeg,.gif,.webp" />
                        <asp:Label ID="lblAyudaImagen" runat="server" CssClass="form-text d-block" />
                    </div>

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Noticias.aspx" CssClass="btn btn-outline-secondary">Cancelar</asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>