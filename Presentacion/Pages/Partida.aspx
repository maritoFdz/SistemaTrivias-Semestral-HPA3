<%@ Page Title="Partida" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Partida.aspx.cs" Inherits="Presentacion.Pages.Partida" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <asp:Panel ID="pnlJuego" runat="server" CssClass="card shadow-sm">
        <div class="card-body p-4">
            <div class="d-flex justify-content-between mb-2">
                <span class="text-muted"><asp:Literal ID="litNumero" runat="server" /></span>
                <span class="badge bg-primary"><asp:Literal ID="litPuntos" runat="server" /> pts</span>
            </div>
            <h2 class="h4 mb-3"><asp:Literal ID="litEnunciado" runat="server" Mode="Encode" /></h2>

            <asp:Panel ID="pnlPregunta" runat="server">
                <div class="mb-3">
                    <div class="progress" style="height:10px;"><div id="barra" class="progress-bar bg-success" style="width:100%"></div></div>
                    <small id="txtTiempo" class="text-muted"></small>
                </div>
                <div class="list-group mb-3">
                    <asp:Repeater ID="rpOpciones" runat="server">
                        <ItemTemplate>
                            <label class="list-group-item d-flex gap-2 align-items-center">
                                <input class="form-check-input flex-shrink-0 mt-0" type="radio" name="opcion" value="<%# Eval("Id") %>" />
                                <span><%#: Eval("DsTexto") %></span>
                            </label>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <asp:Button ID="btnResponder" runat="server" Text="Responder" CssClass="btn btn-primary" OnClick="btnResponder_Click" />
                <asp:Button ID="btnTiempo" runat="server" Text="tiempo" style="display:none" OnClick="btnTiempo_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlFeedback" runat="server" Visible="false">
                <asp:Label ID="lblFeedback" runat="server" />
                <asp:Button ID="btnSiguiente" runat="server" CssClass="btn btn-primary" OnClick="btnSiguiente_Click" />
            </asp:Panel>
        </div>
    </asp:Panel>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        (function () {
            var barra = document.getElementById('barra');
            if (!barra) return; // no hay pregunta en pantalla
            var total = <%= SegundosTotales %>;
            var resta = <%= SegundosRestantes %>; // lo calcula el servidor y refrescar no lo reinicia
            var txt = document.getElementById('txtTiempo');
            function pintar() {
                barra.style.width = (total > 0 ? Math.max(0, resta) * 100 / total : 0) + '%';
                barra.className = 'progress-bar ' + (resta <= 5 ? 'bg-danger' : 'bg-success');
                txt.textContent = 'Tiempo restante: ' + Math.max(0, resta) + ' s';
            }
            pintar();
            var t = setInterval(function () {
                resta--;
                pintar();
                if (resta <= 0) { clearInterval(t); document.getElementById('<%= btnTiempo.ClientID %>').click(); } // se acabo el tiempo y se envia sin opcion
            }, 1000);
        })();
    </script>
</asp:Content>