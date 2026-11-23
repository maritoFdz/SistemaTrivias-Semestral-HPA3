<%@ Page Title="Ranking" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Ranking.aspx.cs" Inherits="Presentacion.Pages.Ranking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h3 mb-0">Ranking</h1>
        <asp:DropDownList ID="ddlTema" runat="server" CssClass="form-select w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlTema_SelectedIndexChanged" />
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <table class="table table-striped align-middle bg-white">
        <thead>
            <tr><th style="width:70px;">#</th><th>Jugador</th><th class="text-end">Puntos</th><th class="text-end">Niveles aprobados</th><th class="text-end">Premios</th></tr>
        </thead>
        <tbody>
            <asp:Repeater ID="rpRanking" runat="server">
                <ItemTemplate>
                    <tr class='<%# (int)Eval("IdUsuario") == MiId ? "table-primary fw-bold" : "" %>'>
                        <td><%# Medalla((int)Eval("Posicion")) %></td>
                        <td><%# Avatar(Eval("DsRutaAvatar")) %> <%#: Eval("DsNombre") %></td>
                        <td class="text-end"><%# Eval("NuPuntos") %></td>
                        <td class="text-end"><%# Eval("NuNivelesAprobados") %></td>
                        <td class="text-end"><%# Eval("NuPremios") %></td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tbody>
    </table>
    <asp:Label ID="lblVacio" runat="server" CssClass="alert alert-info d-block" Visible="false" Text="Todavía nadie ha jugado" />
</asp:Content>