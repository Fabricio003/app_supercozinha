import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> registerUser({
    required String nome,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await userCredential.user!.updateDisplayName(nome);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          throw Exception(
              'E-mail já cadastrado.');
        } else if (e.code == 'weak-password') {
          throw Exception('A senha fornecida é muito fraca.');
        } else if (e.code == 'invalid-email') {
          throw Exception('O endereço de e-mail não é válido.');
        } else {
          throw Exception('Erro de Autenticação Firebase: ${e.message}');
        }
      }
    } else {
      throw Exception('As senhas não coincidem.');
    }
  }
}
