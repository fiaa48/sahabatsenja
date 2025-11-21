import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sahabatsenja_app/models/jadwal_obat_model.dart';

class JadwalObatService {
  final String baseUrl = "http://192.168.1.18:8000/api";

  /// 🔹 Ambil semua jadwal obat untuk 1 lansia - PERBAIKAN BESAR
  Future<List<JadwalObat>> fetchJadwalObat(int datalansiaId) async {
    try {
      print("🔄 Fetch jadwal obat untuk lansia ID: $datalansiaId");
      
      final response = await http.get(
        Uri.parse("$baseUrl/jadwal-obat/$datalansiaId"),
      );

      print("📡 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Cek struktur response
        if (responseData['success'] == true) {
          if (responseData['data'] is List) {
            List data = responseData['data'];
            print("✅ Data berhasil diambil, jumlah: ${data.length}");
            
            List<JadwalObat> result = data.map((e) => JadwalObat.fromJson(e)).toList();
            return result;
          } else {
            print("❌ Data bukan list, tipe: ${responseData['data'].runtimeType}");
            return [];
          }
        } else {
          print("❌ Success false, message: ${responseData['message']}");
          return [];
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetchJadwalObat: $e");
      return [];
    }
  }

  /// 🔹 Tambah jadwal obat - PERBAIKAN
  Future<bool> tambahJadwalObat({
    required int datalansiaId,
    required String namaObat,
    required String dosis,
    required String waktu,
  }) async {
    try {
      print("🔄 Mengirim data baru:");
      print("   - datalansia_id: $datalansiaId");
      print("   - nama_obat: $namaObat");
      print("   - dosis: $dosis");
      print("   - waktu: $waktu");

      final response = await http.post(
        Uri.parse("$baseUrl/jadwal-obat"),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          "datalansia_id": datalansiaId.toString(),
          "nama_obat": namaObat,
          "dosis": dosis,
          "waktu": waktu,
        },
      );

      print("📡 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 201) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      } else {
        final result = jsonDecode(response.body);
        print("❌ Error dari server: ${result['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Error tambahJadwalObat: $e");
      return false;
    }
  }

  /// 🔹 Update status obat - PERBAIKAN
  Future<bool> updateStatus(int id, bool completed) async {
    try {
      print("🔄 Update status: id=$id, completed=$completed");

      final response = await http.put(
        Uri.parse("$baseUrl/jadwal-obat/$id/status"),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          "completed": completed ? "1" : "0",
        },
      );

      print("📡 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      } else {
        final result = jsonDecode(response.body);
        print("❌ Error dari server: ${result['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Error updateStatus: $e");
      return false;
    }
  }

  /// 🔹 Hapus jadwal obat
  Future<bool> deleteJadwalObat(int id) async {
    try {
      print("🔄 Menghapus jadwal obat id: $id");

      final response = await http.delete(
        Uri.parse("$baseUrl/jadwal-obat/$id"),
      );

      print("📡 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      } else {
        final result = jsonDecode(response.body);
        print("❌ Error dari server: ${result['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Error deleteJadwalObat: $e");
      return false;
    }
  }
}