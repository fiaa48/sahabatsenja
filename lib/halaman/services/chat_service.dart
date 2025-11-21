import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://192.168.1.18:8000/api";

  /// ================================================
  /// GET LIST CHAT UNTUK PERAWAT → MENAMPILKAN DAFTAR KELUARGA YG CHAT
  /// ================================================
  Future<List<dynamic>> getListChatPerawat(int perawatId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/chat/list/perawat/$perawatId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"];
      }
      return [];
    } catch (e) {
      print("Error getListChatPerawat: $e");
      return [];
    }
  }

  /// ================================================
  /// GET PESAN CHAT BERDASARKAN datalansia_id
  /// ================================================
  Future<List<dynamic>> getMessages(int datalansiaId) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/chat/$datalansiaId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"];
      }
      return [];
    } catch (e) {
      print("Error getMessages: $e");
      return [];
    }
  }

  /// ================================================
  /// KIRIM PESAN CHAT
  /// ================================================
  Future<bool> sendMessage({
    required int datalansiaId,
    required String sender,
    required String pesan,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat/send"),
        body: {
          "datalansia_id": datalansiaId.toString(),
          "sender": sender, // Perawat / Keluarga
          "pesan": pesan,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error sendMessage: $e");
      return false;
    }
  }

  /// ================================================
  /// UPDATE STATUS PESAN → DIBACA
  /// ================================================
  Future<bool> markRead(int datalansiaId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chat/read/$datalansiaId"),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error markRead: $e");
      return false;
    }
  }
}
