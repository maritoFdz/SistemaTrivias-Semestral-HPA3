# Proyecto Semestral — Sistema de Trivias

📅 Fecha: 23/11/2026  
📚 Asignatura: Herramientas de Programacion Aplicadas III  
👩‍🏫 Instructora: Ing. Irina Fong  
👥 Grupo: 1IL133

## 📋 Contenido del Repositorio

Este repositorio contiene una aplicación web desarrollada en **C# con ASP.NET Web Forms (.NET Framework 4.7.2)**, organizada en **programación por capas**, con base de datos **MySQL** a la que solo se accede mediante **procedimientos almacenados**.

El **Sistema de Trivias** permite a los jugadores aprender jugando: eligen un tema, superan tres niveles de dificultad, ganan premios y compiten en un ranking. Los administradores gestionan el contenido y consultan reportes de uso.

La aplicación está compuesta por las siguientes funcionalidades:

1. **Inicio de sesión seguro:** validación de credenciales con hash de contraseñas (PBKDF2) y retorno a la página que el usuario intentaba abrir.
2. **Página de inicio pública:** noticias, información del sistema y datos de contacto.
3. **Registro público de jugadores:** con captcha, campo trampa (honeypot) y límite de registros por sesión.
4. **Gestión de usuarios y roles:** `ADMIN`, `OPERATIVO` y `JUGADOR`.
5. **Gestión de temas.**
6. **Gestión de preguntas:** de opción múltiple y de verdadero/falso, con puntos y tiempo límite por pregunta.
7. **Niveles de juego:** Novato, Principiante y Experto; cada nivel se desbloquea al aprobar el anterior.
8. **Partidas con temporizador y puntuación**, calculados siempre en el servidor.
9. **Premios** por tema y nivel, con imagen y puntos extra (se ganan una sola vez).
10. **Imágenes y mensajes de resultado** según el porcentaje obtenido en la partida.
11. **Avatares** de los jugadores, con carga de imagen.
12. **Ranking** por tema o general.
13. **Panel personal (Dashboard)** con puntos, partidas, niveles aprobados y premios.
14. **Noticias** administrables, con imagen opcional.
15. **Calificaciones:** el jugador califica cada tema y la aplicación, y puede sugerir nuevos temas.
16. **Sets de preguntas con código QR:** el administrador genera un QR que abre una partida con un tema, nivel y cantidad de preguntas definidos.
17. **Reportes** de avance de jugadores, distribución por nivel, tiempos y tema más popular, con **descarga en Excel (.xlsx)**.
18. **Registro de errores** en base de datos, sin mostrar detalles técnicos al usuario.

## 🛠 Tecnologías Utilizadas

| Tecnología | Versión |
|---|---|
| **Lenguaje** | C# 7.3 |
| **Framework** | ASP.NET Web Forms (.NET Framework 4.7.2) |
| **Base de datos** | MySQL 8.x |
| **Conector** | MySql.Data (NuGet) |
| **Generación de QR** | QRCoder (NuGet) |
| **Estilos y componentes** | Bootstrap 5.3.8 (CDN) |
| **Tablas interactivas** | DataTables 2.1.8 + jQuery 3.7.1 (CDN) |
| **IDE recomendado** | Visual Studio 2022 |
| **Control de versiones** | Git |
| **Hash de contraseñas** | PBKDF2 (`Rfc2898DeriveBytes`), 100 000 iteraciones, salt de 16 bytes |

**Conceptos aplicados:**

- Programación por capas
- Interfaces y contratos entre capas
- Inyección de dependencias por constructor
- Principio de responsabilidad única
- Hash y verificación de contraseñas con salt
- Roles y permisos (`ADMIN`, `OPERATIVO` y `JUGADOR`)
- Procedimientos almacenados y consultas parametrizadas
- Usuario de base de datos con privilegios mínimos
- Manejo de excepciones y registro de errores
- Validación de datos en cliente y servidor
- Operaciones CRUD
- Páginas maestras (Master Pages)
- Carga segura de archivos (validación del contenido real de la imagen)
- Generación de archivos Excel sin librerías externas

## 💻 Arquitectura y Funcionalidades

### Arquitectura por capas

```text
Presentacion (Páginas .aspx)  ──►  Negocios (Servicios + Reglas)  ──►  Datos  ──►  MySQL
              │                              │                           │
              └──────────────────────  Entidades  ───────────────────────┘
```

| Proyecto | Responsabilidad | Referencia a |
|---|---|---|
| `Entidades` | Clases que representan los datos (`E_Usuario`, `E_Tema`, `E_Pregunta`, `E_SetQr`...). Sin lógica. | Nada |
| `Datos` | Conexión a MySQL y acceso a datos mediante procedimientos almacenados. | `Entidades` |
| `Negocios` | Reglas de negocio, permisos por rol, validaciones, seguridad, generación de QR y de Excel. | `Entidades`, `Datos` |
| `Presentacion` | Páginas Web Forms, páginas maestras y clases de apoyo de la interfaz. | `Entidades`, `Negocios` |

La capa de **Presentación no referencia a Datos**: las páginas nunca se comunican directamente con la base de datos.

### Convención de errores entre capas

| Excepción | Significado | Qué hace la página |
|---|---|---|
| `ArgumentException` | Datos inválidos | Muestra el mensaje al usuario |
| `InvalidOperationException` | Conflicto de negocio (duplicado, nivel bloqueado, set inactivo) | Muestra el mensaje al usuario |
| `UnauthorizedAccessException` | Sin permiso para la acción | Muestra el mensaje al usuario |
| Cualquier otra | Error inesperado | Se guarda en `log_errores` y se muestra un mensaje genérico |

El permiso se valida en la **capa de Negocios**. Ocultar un botón o un menú es solo una comodidad visual: aunque se intentara ejecutar la acción desde otra ruta, Negocios lanzaría `UnauthorizedAccessException`.

### Roles

| Rol | Permisos |
|---|---|
| `ADMIN` | Todo: usuarios, temas, preguntas, premios, imágenes de resultado, noticias, calificaciones, sets QR y reportes. Además juega. |
| `OPERATIVO` | Administra contenido (temas, preguntas, premios, noticias, sets QR) y consulta reportes. |
| `JUGADOR` | Juega, ve su panel, el ranking, califica temas, gestiona sus avatares y escanea QR. |

Los jugadores que se registran desde la página pública siempre reciben el rol `JUGADOR`; el rol no viene del formulario.

### Reglas del juego

- Cada tema tiene tres niveles: **Novato**, **Principiante** y **Experto**.
- Un nivel se desbloquea cuando el anterior está aprobado (validado en el procedimiento almacenado y en Negocios).
- Cada partida tiene **5 preguntas** (en un set QR, la cantidad que defina el administrador, entre 3 y 10).
- Cada pregunta tiene su tiempo límite; el cronómetro y la puntuación se calculan en el **servidor** (con 3 segundos de gracia por la red).
- Los puntos de un nivel son los de la **mejor partida** del jugador; los premios suman puntos extra.
- Cada tema y nivel tiene a lo sumo **un premio**, que se gana una sola vez.
- La imagen y el mensaje del resultado dependen del porcentaje obtenido.

### Sets de preguntas con QR

1. El administrador crea un set: nombre, tema, nivel y cantidad de preguntas. El sistema le asigna un código único (GUID).
2. Desde **Ver QR** se muestra y se descarga la imagen del QR (PNG). El enlace se arma con la dirección del servidor que el administrador indique.
3. Al escanearlo, el jugador llega a `JugarQr.aspx?c=<codigo>`. Si no tiene sesión, entra por el login y regresa automáticamente al set.
4. La partida respeta las mismas reglas de desbloqueo de niveles y queda marcada como jugada por QR.
5. Un set se puede desactivar sin perder su historial; el código no cambia al editarlo.

### Reportes

La pantalla **Reportes** muestra:

- Jugadores que han jugado, partidas totales y partidas por QR.
- Promedio de puntos por partida y tiempo promedio por respuesta.
- Tema más popular.
- Distribución de jugadores por nivel.
- Avance de cada jugador por tema (porcentaje, nivel más alto, puntos, tiempos y tiempo entre niveles).

El botón **Descargar Excel** genera un archivo `.xlsx` con tres hojas: *Resumen*, *Distribución por nivel* y *Avance por jugador*.

### Seguridad aplicada

| Riesgo | Medida |
|---|---|
| Inyección SQL | Solo procedimientos almacenados con parámetros tipados |
| XSS | Codificación de toda salida (`<%: %>` y `Validador.CodificarHtml`) |
| Contraseñas | PBKDF2 con salt aleatorio por usuario; el hash nunca sale de la capa de Negocios |
| Acceso sin sesión o sin permiso | `PaginaBase` revisa sesión y rol en cada página; Negocios vuelve a validar |
| Redirecciones abiertas | `ReturnUrl` solo acepta rutas internas `.aspx` |
| Registro automático (bots) | Captcha de suma, campo trampa y máximo de 3 registros por sesión |
| Archivos subidos | Se valida el contenido real de la imagen (no la extensión), nombre aleatorio y tamaño máximo |
| Trampa en el juego | Puntos y tiempos se calculan en el servidor, no en el navegador |
| Mensajes de error | El detalle técnico va a `log_errores`; el usuario ve un mensaje genérico |
| Privilegios de base de datos | La aplicación no usa `root`: solo tiene `EXECUTE` sobre los procedimientos |

### Base de datos

El archivo:

```text
bd_trivias_respaldo.sql
```

crea la base de datos `bd_trivias`, sus 15 tablas con datos de ejemplo, los procedimientos almacenados, el usuario de la aplicación y sus permisos.

**Tablas:** `usuarios`, `avatares`, `temas`, `niveles`, `preguntas`, `opciones`, `premios`, `usuario_premios`, `imagenes_resultado`, `partidas`, `respuestas`, `noticias`, `calificaciones`, `sets_qr` y `log_errores`.

**Procedimientos almacenados:** todos con prefijo `sp_` y agrupados por módulo (`sp_login`, `sp_usuario_*`, `sp_tema_*`, `sp_pregunta_*`, `sp_premio_*`, `sp_imgres_*`, `sp_avatar_*`, `sp_juego_*`, `sp_partida_*`, `sp_ranking`, `sp_noticia_*`, `sp_calif_*`, `sp_setqr_*`, `sp_reporte_*`, `sp_log_error`).

### Conexión con privilegios mínimos

La aplicación **no utiliza `root`**. Se conecta con el usuario `app_trivias`, que solo tiene permiso `EXECUTE` sobre `bd_trivias`. No puede leer ni modificar las tablas directamente, ni acceder a otras bases de datos.

## 💻 Capturas de Pantalla

> Agregar aquí las capturas (guardarlas en `docs/img/`).

### Inicio público
<img width="1920" height="1012" alt="image" src="https://github.com/user-attachments/assets/c1c234d3-e0dc-425e-9ad2-0ac3d0839ba8" />


### Inicio de sesión
<img width="1920" height="1018" alt="image" src="https://github.com/user-attachments/assets/02860910-6eaf-4942-8325-cc28a353ef51" />


### Registro de jugadores
<img width="1920" height="1023" alt="image" src="https://github.com/user-attachments/assets/768377a0-4b37-485c-a540-dbbc844d89ce" />


### Panel del jugador (Dashboard)
<img width="1920" height="1019" alt="image" src="https://github.com/user-attachments/assets/7d952131-3b46-47ee-81bd-f91a989c20e1" />


### Selección de tema y niveles
<img width="1920" height="1023" alt="image" src="https://github.com/user-attachments/assets/db22f42a-53a8-4c53-a48b-f01370618b96" />


### Partida en curso
<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/acec5434-7308-4ec2-8853-003b7fb8c07c" />

<img width="1920" height="1021" alt="image" src="https://github.com/user-attachments/assets/40003e02-d821-4ad1-ba15-3980e27808b5" />



### Resultado de la partida
<img width="1574" height="826" alt="image" src="https://github.com/user-attachments/assets/57e8b377-7a84-4383-a821-5c61544db5a4" />

<img width="1920" height="1021" alt="image" src="https://github.com/user-attachments/assets/37edf8a9-77ff-4446-a155-3d954ff2c402" />


### Ranking
<img width="1920" height="1019" alt="image" src="https://github.com/user-attachments/assets/cef825d7-56b7-45e0-948a-0e6ecafc9257" />


### Administración (usuarios, temas, preguntas, premios)
<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/3b698285-6ca1-4632-942a-cbe1f7f9db85" />

<img width="1920" height="1019" alt="image" src="https://github.com/user-attachments/assets/f26debdb-a4d0-42c6-80fb-d5735e2f1625" />

<img width="1920" height="1019" alt="image" src="https://github.com/user-attachments/assets/b52f9469-c7d2-4a03-b5fa-711114c183e6" />

<img width="1920" height="1023" alt="image" src="https://github.com/user-attachments/assets/33970072-10e1-4b40-86a0-0294cdeb2e30" />

<img width="1920" height="1019" alt="image" src="https://github.com/user-attachments/assets/d3b6c3dd-9894-4e6d-b600-e00674e73eac" />

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/4832c64c-b9a5-495e-869e-25fc5bc99e9d" />

<img width="1920" height="1019" alt="image" src="https://github.com/user-attachments/assets/8669a447-2be8-431a-b52c-a646f2fe11e9" />

<img width="1920" height="1008" alt="image" src="https://github.com/user-attachments/assets/1bf46529-d1ce-4973-a14d-e46d86e85cd6" />


### Avatares
<img width="1919" height="1020" alt="image" src="https://github.com/user-attachments/assets/06036f7c-cf90-45dc-8b08-0ad3c849047b" />

<img width="1920" height="1057" alt="image" src="https://github.com/user-attachments/assets/59135271-bf77-487a-823a-da785787815d" />


### Noticias
<img width="1902" height="854" alt="image" src="https://github.com/user-attachments/assets/eb1d645a-97bb-4973-b571-c7d782587568" />

<img width="1920" height="1017" alt="image" src="https://github.com/user-attachments/assets/79b3fec9-0896-4304-ba5e-cf4483a298f8" />


### Sets QR
<img width="1919" height="1021" alt="image" src="https://github.com/user-attachments/assets/408ebdaa-2b41-4802-8cca-80e5617cb6e3" />

<img width="1920" height="1021" alt="image" src="https://github.com/user-attachments/assets/0a2916dd-69e3-429e-9523-3972ce06a5ba" />


### Reportes y Excel
<img width="1919" height="1019" alt="image" src="https://github.com/user-attachments/assets/40b0a988-4e99-419d-926a-33275a490d55" />

<img width="1920" height="1023" alt="image" src="https://github.com/user-attachments/assets/17754fd5-3402-40e2-b407-462ffc10f0ba" />

<img width="1920" height="1021" alt="image" src="https://github.com/user-attachments/assets/0c6332fa-9629-42f2-b310-e2fa842ca238" />


## 📁 Estructura de Carpetas o Directorios

```text
Sistema de Trivias/
│
├── README.md
├── .gitignore
├── SistemaTrivias.sln
├── bd_trivias_respaldo.sql
│
├── docs/
│   └── img/
│
├── Entidades/        (E_Usuario, E_Tema, E_Pregunta, E_Premio, E_SetQr, E_Reporte...)
│
├── Datos/            (ConexionBD, D_Usuario, D_Tema, D_Pregunta, D_Premio, D_Juego,
│                      D_Noticia, D_Calificacion, D_SetQr, D_Reporte, D_LogError...)
│
├── Negocios/
│   ├── Seguridad/    (IHashService, HashService, IVerificarHashService, ...)
│   ├── Servicios/    (IUsuarioService/N_Usuario, IJuegoService/N_Juego,
│   │                  ISetQrService/N_SetQr, IReporteService/N_Reporte, ...)
│   └── Utilidades/   (Validador, ManejadorErrores, ImagenArchivo, GeneradorQr, ExcelSimple)
│
└── Presentacion/
    ├── Web.config
    ├── Principal.Master          (maestra privada, con menú y sesión)
    ├── Publica.Master            (maestra pública)
    ├── Clases/                   (PaginaBase, Navegacion)
    ├── Uploads/                  (avatares, premios, resultados, noticias)
    └── Pages/
        ├── Inicio.aspx, Registro.aspx, Login.aspx
        ├── Dashboard.aspx
        ├── Jugar.aspx, JugarQr.aspx, Partida.aspx, Resultado.aspx, Ranking.aspx
        ├── Usuarios.aspx, Temas.aspx, Preguntas.aspx, Premios.aspx
        ├── ImagenesResultado.aspx, Avatares.aspx
        ├── Noticias.aspx, NoticiaForm.aspx
        ├── Calificaciones.aspx, Calificar.aspx
        ├── SetsQr.aspx, SetQrVer.aspx, QrImagen.ashx
        └── Reportes.aspx
```

Los directorios `.vs`, `bin`, `obj` y `packages` corresponden a archivos generados por Visual Studio y por el proceso de compilación. No se incluyen en el repositorio (ver `.gitignore`). La carpeta `Uploads/` **sí** se incluye, porque contiene las imágenes de los datos de ejemplo.

## ▶️ Instrucciones de Instalación y Ejecución

### Requisitos

- Windows 10 u 11.
- Visual Studio 2022 con la carga de trabajo **Desarrollo de ASP.NET y web**.
- .NET Framework 4.7.2 (Developer Pack).
- Servidor **MySQL 8.0 o superior** instalado y funcionando (no es compatible con MariaDB/XAMPP).

### Pasos

**1. Clonar el repositorio**

```bash
git clone https://github.com/maritoFdz/SistemaTrivias-Semestral-HPA3.git
cd [repositorio]
```

**2. Crear la base de datos**

Ejecutar el script `bd_trivias_respaldo.sql` con el usuario `root` de MySQL:

```bash
mysql -u root -p < bd_trivias_respaldo.sql
```

O abrirlo en MySQL Workbench y ejecutarlo completo.

> ⚠️ El script comienza con `DROP TABLE`, por lo que elimina los datos de las tablas si ya existen.

**3. Verificar la creación**

```sql
USE bd_trivias;
SELECT id, dsNombre, dsRol FROM usuarios;
SHOW GRANTS FOR 'app_trivias'@'localhost';
```

**4. Abrir la solución**

Abrir `SistemaTrivias.sln` en Visual Studio. Los paquetes NuGet (`MySql.Data` y `QRCoder`) se restauran automáticamente. Si no lo hacen: clic derecho en la solución → **Restaurar paquetes NuGet**.

**5. Establecer el proyecto de inicio**

Clic derecho en `Presentacion` → **Establecer como proyecto de inicio**.

**6. Compilar y ejecutar**

Compilar con `Ctrl + Shift + B` y ejecutar con `F5`.

### Credenciales de prueba

| Usuario | Contraseña | Rol |
|---|---|---|
| `admin@trivias.local` | `Admin#2026` | `ADMIN` |

Los jugadores se crean desde la página pública **Registro**. Un administrador puede crear usuarios con cualquier rol desde **Administrar → Usuarios**.

### Probar los sets QR desde un celular

El QR contiene la dirección del servidor, por lo que `localhost` no sirve en otro dispositivo. Opciones:

- Usar un **Dev Tunnel** de Visual Studio (dirección pública `https://...devtunnels.ms`) y escribirla en el campo *Dirección del servidor* de la pantalla **Ver QR**.
- O usar la IP de la computadora dentro de la misma red, habilitando el puerto en el firewall.

Para pruebas en la misma computadora basta abrir el enlace que aparece debajo del QR.

## ⚠️ Consideraciones

La cadena de conexión se encuentra en:

```text
Presentacion/Web.config
```

Los valores por defecto son:

```text
Server=localhost
Database=bd_trivias
Uid=app_trivias
Pwd=ClaveSegura#2026
```

La contraseña por defecto de la base de datos y el usuario `admin@trivias.local` / `Admin#2026` son **solo para fines académicos**. En un proyecto real deben cambiarse y no publicarse en un repositorio público.

El respaldo incluye datos de ejemplo (temas, 105 preguntas, premios, imágenes y noticias). La carpeta `Uploads/` debe acompañar siempre al respaldo: la base solo guarda las rutas de las imágenes.

## 👥 Integrantes y Contexto

| Integrante | Cédula |
|---|---|
| Mario Fernández | 20-16-8273 |
| Norlan Ortega | 20-53-8062 |
| Alejandro Vargas | E-8-214647 |
| Kevin Esquivel | 8-1023-1678 |

- **Institución:** Universidad Tecnológica de Panamá (UTP) — Facultad de Ingeniería en Sistemas Computacionales
- **Asignatura:** Herramientas de Programación Aplicadas III
- **Grupo:** 1IL133
- **Instructora:** Ing. Irina Fong
- **Fecha de Realización:** 23/11/2026

Este proyecto fue desarrollado como proyecto semestral, con el propósito de aplicar la programación por capas, el acceso a datos con procedimientos almacenados y buenas prácticas de seguridad en una aplicación web con C# y ASP.NET Web Forms.

## 📚 Referencias

- Microsoft Learn — Documentación oficial de C#.
- Microsoft Learn — ASP.NET Web Forms y .NET Framework 4.7.2.
- Microsoft Learn — `Rfc2898DeriveBytes` (PBKDF2).
- MySQL Documentation — Stored Programs y administración de privilegios.
- Documentación de `MySql.Data` para conectividad entre C# y MySQL.
- Documentación de `QRCoder` para la generación de códigos QR.
- Bootstrap 5 y DataTables — documentación oficial.
