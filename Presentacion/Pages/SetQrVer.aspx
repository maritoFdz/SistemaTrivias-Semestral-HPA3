<%@ Page Title="Código QR" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="SetQrVer.aspx.cs" Inherits="Presentacion.Pages.SetQrVer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:Panel ID="pnlQr" runat="server" CssClass="card shadow-sm text-center">
        <div class="card-body p-4">
            <h1 class="h4"><asp:Literal ID="litNombre" runat="server" /></h1>
            <p class="text-muted"><asp:Literal ID="litDetalle" runat="server" /></p>
            <asp:Image ID="imgQr" runat="server" AlternateText="Código QR del set" CssClass="img-fluid border rounded p-2 bg-white" Width="300" Height="300" />
            <p class="small text-break mt-3 mb-1">Enlace: <asp:Literal ID="litEnlace" runat="server" /></p>
            <div class="row justify-content-center mt-3">
                <div class="col-md-6">
                    <label class="form-label" for="<%= txtBase.ClientID %>">Dirección del servidor (la que abrirá el celular)</label>
                    <div class="input-group">
                        <asp:TextBox ID="txtBase" runat="server" CssClass="form-control" />
                        <asp:Button ID="btnActualizar" runat="server" Text="Actualizar QR" CssClass="btn btn-outline-primary" OnClick="btnActualizar_Click" />
                    </div>
                    <div class="form-text">Con localhost el celular no abre nada, usa la IP de la compu, por ejemplo http://192.168.1.10:8080</div>
                </div>
            </div>
            <div class="mt-3">
                <asp:HyperLink ID="lnkDescargar" runat="server" CssClass="btn btn-success">Descargar PNG</asp:HyperLink>
                <button type="button" class="btn btn-outline-secondary" onclick="window.print()">Imprimir</button>
                <asp:HyperLink runat="server" NavigateUrl="~/Pages/SetsQr.aspx" CssClass="btn btn-outline-secondary">Volver</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>