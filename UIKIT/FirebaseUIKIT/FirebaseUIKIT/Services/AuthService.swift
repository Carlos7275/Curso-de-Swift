import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class AuthService {

    static let shared = AuthService()

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

    // Registrar
    func registrarUsuarioCompleto(
        email: String,
        password: String,
        nombres: String,
        apellidos: String,
        fechaNacimiento: String,
        foto: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        Auth.auth().createUser(withEmail: email, password: password) {
            authResult,
            error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let uid = authResult?.user.uid else {
                completion(
                    .failure(
                        NSError(
                            domain: "AuthError",
                            code: 0,
                            userInfo: [
                                NSLocalizedDescriptionKey: "No se obtuvo UID"
                            ]
                        )
                    )
                )
                return
            }

            let db = Firestore.firestore()
            let usuarioRef = db.collection("users").document(uid)

            let usuarioData: [String: Any] = [
                "nombres": nombres,
                "apellidos": apellidos,
                "fechaNacimiento": fechaNacimiento,
                "foto": foto,
                "createdAt": Timestamp(),
            ]

            usuarioRef.setData(usuarioData) { error in
                if let error = error {
                    Auth.auth().currentUser?.delete(completion: nil)
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // Obtener Usuario
    func obtenerUsuario() -> User? {
        return Auth.auth().currentUser
    }
}
