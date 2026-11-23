<%@ Page Title="Pregunta" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="PreguntaForm.aspx.cs" Inherits="Presentacion.Pages.PreguntaForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h1 class="h4 mb-4"><asp:Literal ID="litTitulo" runat="server" /></h1>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block" Visible="false" />

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <asp:Label runat="server" AssociatedControlID="ddlTema" CssClass="form-label">Tema</asp:Label>
                            <asp:DropDownList ID="ddlTema" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <asp:Label runat="server" AssociatedControlID="ddlNivel" CssClass="form-label">Nivel</asp:Label>
                            <asp:DropDownList ID="ddlNivel" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <asp:Label runat="server" AssociatedControlID="ddlTipo" CssClass="form-label">Tipo</asp:Label>
                            <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTipo_SelectedIndexChanged" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtEnunciado" CssClass="form-label">Pregunta</asp:Label>
                        <asp:TextBox ID="txtEnunciado" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="500" />
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtPuntos" CssClass="form-label">Puntos</asp:Label>
                            <asp:TextBox ID="txtPuntos" runat="server" CssClass="form-control" TextMode="Number" Text="10" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label runat="server" AssociatedControlID="txtSegundos" CssClass="form-label">Segundos para responder</asp:Label>
                            <asp:TextBox ID="txtSegundos" runat="server" CssClass="form-control" TextMode="Number" Text="30" />
                        </div>
                    </div>

                    <asp:Panel ID="pnlMultiple" runat="server">
                        <h2 class="h6 mt-2">Opciones</h2>
                        <div class="mb-2"><asp:TextBox ID="txtOp1" runat="server" CssClass="form-control" MaxLength="255" placeholder="Opción A" /></div>
                        <div class="mb-2"><asp:TextBox ID="txtOp2" runat="server" CssClass="form-control" MaxLength="255" placeholder="Opción B" /></div>
                        <div class="mb-2"><asp:TextBox ID="txtOp3" runat="server" CssClass="form-control" MaxLength="255" placeholder="Opción C" /></div>
                        <div class="mb-3"><asp:TextBox ID="txtOp4" runat="server" CssClass="form-control" MaxLength="255" placeholder="Opción D" /></div>
                        <div class="mb-4">
                            <asp:Label runat="server" AssociatedControlID="ddlCorrecta" CssClass="form-label">Opción correcta</asp:Label>
                            <asp:DropDownList ID="ddlCorrecta" runat="server" CssClass="form-select" />
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlVF" runat="server" CssClass="mb-4">
                        <asp:Label runat="server" AssociatedControlID="rblVF" CssClass="form-label d-block">La respuesta correcta es</asp:Label>
                        <asp:RadioButtonList ID="rblVF" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="form-check-inline" />
                    </asp:Panel>

                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:HyperLink runat="server" NavigateUrl="~/Pages/Preguntas.aspx" CssClass="btn btn-outline-secondary">Cancelar</asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>