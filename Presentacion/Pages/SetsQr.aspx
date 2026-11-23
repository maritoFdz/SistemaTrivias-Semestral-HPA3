<%@ Page Title="Sets QR" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="SetsQr.aspx.cs" Inherits="Presentacion.Pages.SetsQr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="h3 mb-3">Sets de preguntas con QR</h1>
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h2 class="h5"><asp:Literal ID="litForm" runat="server" Text="Nuevo set" /></h2>
            <asp:HiddenField ID="hfId" runat="server" Value="0" />
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label" for="<%= txtNombre.ClientID %>">Nombre</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="100" />
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="<%= ddlTema.ClientID %>">Tema</label>
                    <asp:DropDownList ID="ddlTema" runat="server" CssClass="form-select" />
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="<%= ddlNivel.ClientID %>">Nivel</label>
                    <asp:DropDownList ID="ddlNivel" runat="server" CssClass="form-select" />
                </div>
                <div class="col-md-2">
                    <label class="form-label" for="<%= txtCantidad.ClientID %>">Preguntas</label>
                    <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" Text="5" />
                </div>
            </div>
            <div class="mt-3">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-outline-secondary" CausesValidation="false" OnClick="btnCancelar_Click" Visible="false" />
            </div>
        </div>
    </div>

    <asp:GridView ID="gvSets" runat="server" AutoGenerateColumns="false" CssClass="table table-striped align-middle" OnRowCommand="gvSets_RowCommand" DataKeyNames="Id">
        <Columns>
            <asp:BoundField DataField="DsNombre" HeaderText="Nombre" />
            <asp:BoundField DataField="DsNombreTema" HeaderText="Tema" />
            <asp:BoundField DataField="DsNombreNivel" HeaderText="Nivel" />
            <asp:BoundField DataField="NuCantidadPreguntas" HeaderText="Preguntas" />
            <asp:BoundField DataField="NuPartidas" HeaderText="Veces jugado" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='badge <%# Eval("DsEstado").ToString() == "1" ? "bg-success" : "bg-secondary" %>'><%# Eval("DsEstado").ToString() == "1" ? "Activo" : "Inactivo" %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <a href='SetQrVer.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-success">Ver QR</a>
                    <asp:LinkButton runat="server" CommandName="Editar" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary" Text="Editar" />
                    <asp:LinkButton runat="server" CommandName="CambiarEstado" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary" OnClientClick="return confirm('¿Cambiar el estado de este set?');" Text='<%# Eval("DsEstado").ToString() == "1" ? "Desactivar" : "Activar" %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate><div class="text-muted">Todavía no hay sets creados</div></EmptyDataTemplate>
    </asp:GridView>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>