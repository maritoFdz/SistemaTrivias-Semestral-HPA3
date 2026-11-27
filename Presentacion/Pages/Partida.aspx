<%@ Page Title="Partida" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Partida.aspx.cs" Inherits="Presentacion.Pages.Partida" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <audio id="musica" src="<%= ResolveUrl("~/Audio/musica.wav") %>" loop preload="auto"></audio>
    <audio id="sfxCorrecto" src="<%= ResolveUrl("~/Audio/correcto.wav") %>" preload="auto"></audio>
    <audio id="sfxIncorrecto" src="<%= ResolveUrl("~/Audio/incorrecto.wav") %>" preload="auto"></audio>
    <audio id="sfxTick" src="<%= ResolveUrl("~/Audio/tick.wav") %>" preload="auto"></audio>

    <div class="text-end mb-2">
        <button type="button" id="btnMute" class="btn btn-sm btn-outline-secondary">🔊</button>
    </div>

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
            var musica = document.getElementById('musica');
            var btn = document.getElementById('btnMute');
            var mute = sessionStorage.getItem('mute') === '1'; // se recuerda entre preguntas
            var pos = parseFloat(sessionStorage.getItem('musicaPos') || '0');

            musica.volume = 0.3; // bajita para que no tape los efectos
            musica.muted = mute;
            if (musica.readyState >= 1) musica.currentTime = pos;
            else musica.addEventListener('loadedmetadata', function () { musica.currentTime = pos; }); // sigue donde iba

            function tocar() { musica.play().catch(function () { }); }
            tocar();
            document.addEventListener('click', tocar, { once: true }); // por si el navegador bloqueo el autoplay

            window.addEventListener('pagehide', function () { sessionStorage.setItem('musicaPos', musica.currentTime); }); // guarda el segundo antes del postback

            function pintarMute() { btn.textContent = mute ? '🔇' : '🔊'; }
            pintarMute();
            btn.addEventListener('click', function () {
                mute = !mute;
                musica.muted = mute;
                sessionStorage.setItem('mute', mute ? '1' : '0');
                pintarMute();
            });

            window.sonar = function (id) { // efectos cortos
                if (mute) return;
                var a = document.getElementById(id);
                a.currentTime = 0;
                a.play().catch(function () { });
            };

            var sonido = '<%= Sonido %>';
            if (sonido === 'correcto') sonar('sfxCorrecto');
            if (sonido === 'incorrecto') sonar('sfxIncorrecto');
        })();
    </script>
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
                if (resta > 0 && resta <= 5) sonar('sfxTick'); // presion en los ultimos 5 segundos
                if (resta <= 0) { clearInterval(t); document.getElementById('<%= btnTiempo.ClientID %>').click(); } // se acabo el tiempo y se envia sin opcion
            }, 1000);
        })();
    </script>
</asp:Content>