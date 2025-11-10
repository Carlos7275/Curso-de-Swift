import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AuthService {

    static let shared = AuthService()
    let urlImageDefault =
        "https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1906669723.jpg"

    private init() {}

    // Login
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result,
            error in
            if let error = error {
                completion(.failure(error))
            } else if let uid = result?.user.uid {
                completion(.success(uid))
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    func registrarUsuarioCompleto(
        email: String,
        password: String,
        usuario: Usuario,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(domain: "AuthError", code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "No se obtuvo UID"])))
                return
            }

            let db = Firestore.firestore()
            let usuarioRef = db.collection("usuarios").document(uid)

            let usuarioData: [String: Any] = [
                "nombres": usuario.nombres,
                "apellidos": usuario.apellidos,
                "foto": self.urlImageDefault,
                "fechanacimiento": usuario.fechaNacimiento,
                "createdAt": Timestamp(),
                "genero": usuario.genero
            ]

            usuarioRef.setData(usuarioData) { error in
                if let error = error {
                    // Si falla el guardado, intentamos limpiar el usuario creado
                    Auth.auth().currentUser?.delete(completion: nil)
                    completion(.failure(error))
                    return
                }

                // Logout inmediato para que la app no quede logueada como el nuevo usuario
                do {
                    try Auth.auth().signOut()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }


    // Obtener Usuario
    func obtenerUsuario() -> User? {
        return Auth.auth().currentUser
    }
}
