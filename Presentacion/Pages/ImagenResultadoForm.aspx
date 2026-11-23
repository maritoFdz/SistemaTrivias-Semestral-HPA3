<%@ Page Title="Imagen de resultado" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="ImagenResultadoForm.aspx.cs" Inherits="Presentacion.Pages.ImagenResultadoForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h1 class="h4 mb-4"><asp:Literal ID="litTitulo" runat="server" /></h1>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

                    <asp:Image ID="imgActual" runat="server" Visible="false" CssClass="rounded d-block mx-auto mb-3" Width="160" Height="160" Style="object-fit:cover;" />

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtMinimo" CssClass="form-label">Se muestra desde este porcentaje (0 a 100)</asp:Label>
                        <asp:TextBox ID="txtMinimo" runat="server" CssClass="form-control" TextMode="Number" Text="0" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtMensaje" CssClass="form-label">Mensaje</asp:Label>
                        <asp:TextBox ID="txtMensaje" runat="server" CssClass="form-control" MaxLength="120" placeholder="Ej. ¡Casi lo logras!" />
                    </div>

                    <div class="mb-4">
                        <asp:Label runat="server" AssociatedControlID="fuImagen" CssClass="form-label">Imagen (puede ser GIF)</asp:Label>
                        <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" accept=".png,.jpg,.jpeg,.gif,.webp" />
                        <asp:Label ID="lblAyudaImagen" runat="server" CssClass="form-text d-block" />
                    </div>

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/ImagenesResultado.aspx" CssClass="btn btn-outline-secondary">Cancelar</asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>