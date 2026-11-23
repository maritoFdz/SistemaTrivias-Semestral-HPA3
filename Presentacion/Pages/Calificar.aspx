<%@ Page Title="Calificar" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Calificar.aspx.cs" Inherits="Presentacion.Pages.Calificar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-9 col-lg-7">
            <asp:Label ID="lblMensaje" runat="server" Visible="false" />

            <asp:Panel ID="pnlForm" runat="server" CssClass="card shadow-sm">
                <div class="card-body p-4">
                    <h1 class="h4 mb-4">Tu opinión sobre <asp:Literal ID="litTema" runat="server" Mode="Encode" /></h1>

                    <div class="mb-3">
                        <label class="form-label d-block">¿Cuánto te gustó jugar este tema?</label>
                        <asp:RadioButtonList ID="rblTema" runat="server" RepeatDirection="Horizontal" CssClass="calif" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label d-block">¿Cuánto te gustó la aplicación?</label>
                        <asp:RadioButtonList ID="rblApp" runat="server" RepeatDirection="Horizontal" CssClass="calif" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtSugerido" CssClass="form-label">¿Qué otro tema te gustaría que agreguemos? (opcional)</asp:Label>
                        <asp:TextBox ID="txtSugerido" runat="server" CssClass="form-control" MaxLength="200" />
                    </div>

                    <div class="mb-4">
                        <asp:Label runat="server" AssociatedControlID="txtComentario" CssClass="form-label">Comentario (opcional)</asp:Label>
                        <asp:TextBox ID="txtComentario" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="500" />
                    </div>

                    <asp:Button ID="btnGuardar" runat="server" Text="Enviar calificación" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Jugar.aspx" CssClass="btn btn-outline-secondary">Volver</asp:HyperLink>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <style>
        .calif td { padding-right: 1.25rem; }
        .calif label { margin-left: .35rem; }
    </style>
</asp:Content>