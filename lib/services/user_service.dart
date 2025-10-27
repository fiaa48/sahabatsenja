import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Simpan user data dengan role ke Firestore
  Future<void> saveUserData({
    required String uid,
    required String email,
    required String role,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({ // ← PAKAI 'users'
        'uid': uid,
        'email': email,
        'role': role,
        'displayName': displayName ?? '',
        'photoURL': photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('❌ ERROR saveUserData: $e');
      throw Exception('Gagal menyimpan data user: $e');
    }
  }

  // Get user data by UID - QUERY BY FIELD
  Future<UserModel?> getUserData(String uid) async {
    try {
      final query = await _firestore
          .collection('users') // ← PAKAI 'users'
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      print('🔍 DEBUG QUERY: Found ${query.docs.length} documents');
      
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        print('🔍 DEBUG: Document data: ${doc.data()}');
        return UserModel.fromMap(doc.data());
      }
      return null;
    } catch (e) {
      print('❌ ERROR getUserData: $e');
      return null;
    }
  }

  // Check if user exists in Firestore
  Future<bool> userExists(String uid) async {
    try {
      final query = await _firestore
          .collection('users') // ← PAKAI 'users'
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      print('❌ ERROR userExists: $e');
      return false;
    }
  }

  // METHOD BARU: Debug check user
  Future<void> debugUser(String uid) async {
    try {
      final query = await _firestore
          .collection('users') // ← PAKAI 'users'
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      
      print('=== DEBUG USER ===');
      print('UID: $uid');
      print('Collection: users');
      print('Documents found: ${query.docs.length}');
      if (query.docs.isNotEmpty) {
        print('Data: ${query.docs.first.data()}');
      } else {
        print('❌ NO DOCUMENT FOUND');
      }
      print('==================');
    } catch (e) {
      print('❌ DEBUG ERROR: $e');
    }
  }
}