import "package:google_sign_in/google_sign_in.dart";
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Eliminar serverClientId para compatibilidad con Web
    // serverClientId: '435607360361-32u2k7h1v2rfrfm2t8965mq7v5ks3kd3.apps.googleusercontent.com',
    clientId: '435607360361-32u2k7h1v2rfrfm2t8965mq7v5ks3kd3.apps.googleusercontent.com',
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Error: Google authentication failed.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (error) {
      print('Error en el inicio de sesión con Google: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
