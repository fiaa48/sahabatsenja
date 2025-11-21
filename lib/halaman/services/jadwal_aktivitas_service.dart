import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sahabatsenja_app/models/jadwal_aktivitas_model.dart';

class JadwalService {
  final String baseUrl = 'http://192.168.1.18:8000/api';

  Future<List<JadwalAktivitas>> fetchJadwal() async {
    final response = await http.get(Uri.parse('$baseUrl/jadwal'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => JadwalAktivitas.fromJson(e)).toList();
    } else {
      throw Exception('Gagal fetch jadwal: ${response.statusCode}');
    }
  }

  Future<bool> tambahJadwal(JadwalAktivitas jadwal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jadwal'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jadwal.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateCompleted(int id, bool completed) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/jadwal/$id/completed'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'completed': completed}),
    );
    return response.statusCode == 200;
  }

  // 🔹 PERBAIKI METHOD HAPUS DENGAN DEBUGGING
  Future<bool> hapusJadwal(int id) async {
    try {
      print('🔄 Menghapus jadwal dengan ID: $id');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/jadwal/$id'),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Jadwal berhasil dihapus');
        return true;
      } else {
        print('❌ Gagal hapus jadwal: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error hapus jadwal: $e');
      return false;
    }
  }

  Future<bool> updateJadwal(JadwalAktivitas jadwal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jadwal/${jadwal.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jadwal.toJson()),
    );
    return response.statusCode == 200;
  }
}