import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();

  // 🔹 Login dengan Google (tanpa Sanctum token)
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // 1️⃣ Login via Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      // 2️⃣ Kirim data ke Laravel
      final userData = {
        'firebase_uid': firebaseUser.uid,
        'name': firebaseUser.displayName,
        'email': firebaseUser.email,
        'phone_number': firebaseUser.phoneNumber,
        'profile_photo': firebaseUser.photoURL,
        'role': 'keluarga',
      };

      final laravelResponse = await _apiService.post('login/google', userData);

      // 3️⃣ Return hasil
      return {
        'firebase_user': firebaseUser,
        'laravel_user': laravelResponse['data'] ?? {},
      };
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      return null;
    }
  }

  // 🔹 Logout
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (e) {
      print('❌ Logout Error: $e');
    }
  }

  // 🔹 Cek user
  Future<bool> checkUserExists(String firebaseUid) async {
    try {
      final response = await _apiService.get('users/check/$firebaseUid');
      return response['exists'] ?? false;
    } catch (e) {
      print('❌ Check user error: $e');
      return false;
    }
  }
}
