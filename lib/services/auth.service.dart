import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> registerUser({
    required String nome,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('As senhas não coincidem.');
    }
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(nome);
      await addUserDetails(userCredential.user!.uid, nome, email);
    } on FirebaseAuthException catch (e) {
      throw Exception(getFirebaseAuthError(e.code));
    }
  }

  Future<String> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Por favor, informe e-mail e senha para entrar.');
    }
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final ref = FirebaseDatabase.instance
          .ref()
          .child('users/${userCredential.user!.uid}');
      var snapshot = await ref.get();
      var userName = snapshot.child('nome').value.toString();

      return userName;
    } on FirebaseAuthException catch (e) {
      throw Exception(getFirebaseAuthError(e.code));
    }
  }

  Future<void> addUserDetails(String userId, String nome, String email) async {
    final ref = FirebaseDatabase.instance.ref().child('users/$userId');
    await ref.set({
      'nome': nome,
      'email': email,
    });
  }

  String getFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'E-mail já cadastrado.';
      case 'weak-password':
        return 'A senha fornecida é muito fraca.';
      case ('invalid-email' || 'weak-password'):
        return 'O endereço de e-mail e senha não são válidos.';
      default:
        return 'Erro de Autenticação informe as credenciais válidas';
    }
  }

  Future<void> deleteUser() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}');
      await ref.remove();

      await user.delete();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      await user.updatePassword(newPassword);
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/${user.uid}');
      await ref.update({'password': newPassword});
    }
  }

  Future<bool> reauthenticate(String currentPassword) async {
    User? user = _firebaseAuth.currentUser;
    var cred = EmailAuthProvider.credential(
      email: user!.email!,
      password: currentPassword,
    );

    try {
      var result = await user.reauthenticateWithCredential(cred);
      return result.user != null;
    } catch (e) {
      return false;
    }
  }
}
