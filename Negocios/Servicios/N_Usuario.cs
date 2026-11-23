using System;
using System.Collections.Generic;
using Datos;
using Entidades;
using Negocios.Seguridad;
using Negocios.Utilidades;

namespace Negocios.Servicios
{
    public class N_Usuario : IUsuarioService
    {
        private readonly D_Usuario _datos;
        private readonly IHashService _hash;
        private readonly IVerificarHashService _verificar;

        public N_Usuario() : this(new D_Usuario(), new HashService(), new VerificarHashService()) { } // constructor por default para no pasar los parametros siempre

        public N_Usuario(D_Usuario datos, IHashService hash, IVerificarHashService verificar)
        {
            _datos = datos;
            _hash = hash;
            _verificar = verificar;
        }

        public E_Usuario Login(string correo, string password)
        {
            correo = Validador.Sanitizar(correo);
            if (correo.Length == 0) throw new ArgumentException("Ingrese el correo");
            if (!Validador.EsCorreoValido(correo)) throw new ArgumentException("El correo no tiene un formato válido");
            if (string.IsNullOrEmpty(password)) throw new ArgumentException("Ingrese la contraseña");

            E_Usuario encontrado = _datos.ObtenerPorCorreo(correo);
            if (encontrado == null) return null;
            if (!_verificar.Verificar(password, encontrado.DsPassword)) return null;
            encontrado.DsPassword = null; // el hash no sale de esta capa
            return encontrado;
        }

        public void RegistrarPublico(E_Usuario nuevo, string password)
        {
            nuevo.DsRol = Roles.Jugador;
            Validar(nuevo);
            nuevo.DsCedula = Validador.Sanitizar(nuevo.DsCedula).ToUpper();
            if (!Validador.EsCedulaValida(nuevo.DsCedula)) throw new ArgumentException("La cédula no tiene un formato válido (ej. 8-123-456)");
            if (!Validador.EsPasswordValida(password)) throw new ArgumentException("La contraseña debe tener al menos 6 caracteres");

            _datos.Registrar(nuevo, _hash.GenerarHash(password), "registro_publico");
        }

        public List<E_Usuario> Listar() { return _datos.Listar(); }

        public E_Usuario ObtenerPorId(int id) { return _datos.ObtenerPorId(id); }

        public void Registrar(E_Usuario actual, E_Usuario nuevo, string password)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar usuarios");

            Validar(nuevo);
            nuevo.DsCedula = Validador.Sanitizar(nuevo.DsCedula).ToUpper();
            if (!Validador.EsCedulaValida(nuevo.DsCedula)) throw new ArgumentException("La cédula no tiene un formato válido (ej. 8-123-456)");
            if (!Validador.EsPasswordValida(password)) throw new ArgumentException("La contraseña debe tener al menos 6 caracteres");

            _datos.Registrar(nuevo, _hash.GenerarHash(password), actual.DsCorreo);
        }

        public void Actualizar(E_Usuario actual, E_Usuario editado, string passwordNuevo)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar usuarios");
            if (editado.Id <= 0) throw new ArgumentException("Usuario no válido");

            Validar(editado);
            string hash = null; // null = no se cambia la contraseña
            if (!string.IsNullOrEmpty(passwordNuevo))
            {
                if (!Validador.EsPasswordValida(passwordNuevo)) throw new ArgumentException("La contraseña debe tener al menos 6 caracteres");
                hash = _hash.GenerarHash(passwordNuevo);
            }

            _datos.Actualizar(editado, hash, actual.DsCorreo); // la cedula ni se manda, no se puede editar
        }

        public void CambiarEstado(E_Usuario actual, int id)
        {
            if (!PuedeAdministrar(actual)) throw new UnauthorizedAccessException("No tiene permiso para administrar usuarios");
            if (id == actual.Id) throw new InvalidOperationException("No puedes desactivar tu propio usuario");

            E_Usuario u = _datos.ObtenerPorId(id) ?? throw new InvalidOperationException("El usuario no existe");
            _datos.CambiarEstado(id, u.DsEstado == "1" ? "0" : "1", actual.DsCorreo);
        }

        // solo admin y operativo manejan usuarios
        private static bool PuedeAdministrar(E_Usuario actual)
        {
            return actual != null && (actual.DsRol == Roles.Admin || actual.DsRol == Roles.Operativo);
        }

        // limpia y valida lo que es igual al crear y al editar
        private static void Validar(E_Usuario u)
        {
            u.DsNombre = Validador.Sanitizar(u.DsNombre);
            u.DsCorreo = Validador.Sanitizar(u.DsCorreo);
            if (!Validador.LargoEntre(u.DsNombre, 3, 100)) throw new ArgumentException("El nombre debe tener entre 3 y 100 caracteres");
            if (!Validador.EsCorreoValido(u.DsCorreo)) throw new ArgumentException("El correo no tiene un formato válido");
            if (u.DsRol != Roles.Admin && u.DsRol != Roles.Operativo && u.DsRol != Roles.Jugador) throw new ArgumentException("El rol no es válido");
        }
    }
}