<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Publica.Master" AutoEventWireup="true" CodeBehind="Inicio.aspx.cs" Inherits="Presentacion.Pages.Inicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hero { background: linear-gradient(135deg, #1e3c72, #2a5298); color: #fff; padding: 5rem 0; }
        section { scroll-margin-top: 70px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <header class="hero text-center">
        <div class="container">
            <h1 class="display-4 fw-bold">Aprende jugando</h1>
            <p class="lead mb-4">Trivias de programación con niveles, premios y ranking. Pon a prueba lo que sabes de C#, ASP.NET, HTML, Bootstrap, PHP, JavaScript y Laravel.</p>
            <a href="Registro.aspx" class="btn btn-success btn-lg me-2">Crear mi cuenta</a>
            <a href="Jugar.aspx" class="btn btn-outline-light btn-lg">Entrar y jugar</a>
        </div>
    </header>

    <section id="acerca" class="container py-5">
        <div class="row g-4">
            <div class="col-lg-6">
                <h2 class="h3">¿Qué es el Sistema de Trivias?</h2>
                <p>Es una aplicación web donde cada jugador elige un tema, responde preguntas con tiempo límite y va desbloqueando niveles a medida que aprueba. Cada nivel superado da puntos y un premio, y el ranking muestra cómo vas frente a los demás jugadores.</p>
                <ul>
                    <li>Tres niveles por tema: Novato, Principiante y Experto.</li>
                    <li>Preguntas de opción múltiple y de verdadero o falso.</li>
                    <li>Premios con imagen y puntos extra por cada nivel aprobado.</li>
                    <li>Resultado con imagen distinta según tu desempeño.</li>
                    <li>Avatares para identificarte y ranking por tema o general.</li>
                </ul>
            </div>
            <div class="col-lg-6">
                <h2 class="h3">¿Por qué usar trivias en capacitaciones?</h2>
                <p>Una trivia convierte el repaso en una actividad corta y con metas claras. Para equipos y aulas tiene varias ventajas:</p>
                <ul>
                    <li><strong>Motivación:</strong> los puntos, premios y el ranking invitan a seguir practicando.</li>
                    <li><strong>Retención:</strong> responder con tiempo límite refuerza lo aprendido mejor que solo leerlo.</li>
                    <li><strong>Diagnóstico:</strong> muestra qué temas se dominan y cuáles necesitan refuerzo.</li>
                    <li><strong>Progreso ordenado:</strong> los niveles obligan a construir sobre las bases antes de avanzar.</li>
                    <li><strong>Retroalimentación inmediata:</strong> en cada pregunta se ve la respuesta correcta.</li>
                </ul>
            </div>
        </div>
    </section>

    <section id="temas" class="bg-light py-5">
        <div class="container">
            <h2 class="h3 text-center mb-4">Temas disponibles</h2>
            <div class="row g-3 justify-content-center">
                <asp:Repeater ID="rpTemas" runat="server">
                    <ItemTemplate>
                        <div class="col-6 col-md-4 col-lg-3">
                            <div class="card h-100 text-center shadow-sm">
                                <div class="card-body d-flex flex-column">
                                    <h3 class="h5"><%#: Eval("DsNombre") %></h3>
                                    <p class="small text-muted flex-grow-1"><%#: Eval("DsDescripcion") %></p>
                                    <a href='Jugar.aspx?tema=<%# Eval("Id") %>' class="btn btn-primary btn-sm">Jugar</a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <asp:Label ID="lblSinTemas" runat="server" CssClass="text-center text-muted d-block" Visible="false" Text="Pronto habrá temas disponibles" />
        </div>
    </section>

    <section id="noticias" class="container py-5">
        <h2 class="h3 text-center mb-4">Noticias</h2>
        <asp:Label ID="lblSinNoticias" runat="server" CssClass="text-center text-muted d-block" Visible="false" Text="Todavía no hay noticias" />
        <div class="row g-4">
            <asp:Repeater ID="rpNoticias" runat="server">
                <ItemTemplate>
                    <div class="col-md-6">
                        <div class="card h-100 shadow-sm">
                            <%# ImagenNoticia(Eval("DsRutaImagen")) %>
                            <div class="card-body">
                                <small class="text-muted"><%# Eval("DtPublicacion", "{0:dd/MM/yyyy}") %></small>
                                <h3 class="h5"><%#: Eval("DsTitulo") %></h3>
                                <p><%#: Eval("DsResumen") %></p>
                                <div class="collapse" id='n<%# Eval("Id") %>'>
                                    <p class="border-top pt-2"><%#: Eval("DsContenido") %></p>
                                </div>
                                <button class="btn btn-sm btn-outline-primary" type="button" data-bs-toggle="collapse" data-bs-target='#n<%# Eval("Id") %>'>Leer más</button>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

    <section id="contacto" class="bg-dark text-light py-5">
        <div class="container">
            <h2 class="h3 text-center mb-4">Contacto</h2>
            <div class="row justify-content-center text-center g-4">
                <div class="col-md-4"><h3 class="h6 text-uppercase text-secondary">Universidad</h3>Universidad Tecnológica de Panamá<br />Facultad de Ingeniería de Sistemas Computacionales</div>
                <div class="col-md-4"><h3 class="h6 text-uppercase text-secondary">Correo</h3>mario.fernandez@utp.ac</div>
                <div class="col-md-4"><h3 class="h6 text-uppercase text-secondary">Asignatura</h3>Herramienta de Programación Aplicada III<br />Grupo 1IL133</div>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>