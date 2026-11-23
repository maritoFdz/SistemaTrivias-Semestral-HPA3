<%@ Page Title="Jugar con QR" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="JugarQr.aspx.cs" Inherits="Presentacion.Pages.JugarQr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:Panel ID="pnlSet" runat="server" CssClass="card shadow-sm text-center">
        <div class="card-body p-4">
            <p class="text-muted mb-1">Set de preguntas</p>
            <h1 class="h3"><asp:Literal ID="litNombre" runat="server" /></h1>
            <p><asp:Literal ID="litDetalle" runat="server" /></p>
            <asp:Button ID="btnComenzar" runat="server" Text="Comenzar" CssClass="btn btn-primary btn-lg" OnClick="btnComenzar_Click" />
        </div>
    </asp:Panel>

    <div class="mt-3">
        <asp:HyperLink runat="server" NavigateUrl="~/Pages/Jugar.aspx" CssClass="btn btn-outline-secondary">Ir a los temas</asp:HyperLink>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>