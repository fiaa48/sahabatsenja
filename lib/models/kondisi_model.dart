class KondisiHarian {
  final int? id;
  final int idLansia;
  final String tekananDarah;
  final String nadi;
  final String nafsuMakan;
  final String statusObat;
  final String? catatan;
  final String status;
  final DateTime tanggal;
  final String? namaLansia;

  KondisiHarian({
    this.id,
    required this.idLansia,
    required this.tekananDarah,
    required this.nadi,
    required this.nafsuMakan,
    required this.statusObat,
    this.catatan,
    required this.status,
    required this.tanggal,
    this.namaLansia,
  });

  /// 🧩 Ubah objek ke JSON (untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'id_lansia': idLansia,
      'tekanan_darah': tekananDarah,
      'nadi': nadi,
      'nafsu_makan': nafsuMakan,
      'status_obat': statusObat,
      'catatan': catatan ?? '',
      'status': status,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  /// 🧩 Parse dari JSON ke model Dart
  factory KondisiHarian.fromJson(Map<String, dynamic> json) {
    return KondisiHarian(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      idLansia: json['id_lansia'] is int
          ? json['id_lansia']
          : int.tryParse(json['id_lansia'].toString()) ?? 0,
      tekananDarah: json['tekanan_darah']?.toString() ?? '',
      nadi: json['nadi']?.toString() ?? '',
      nafsuMakan: json['nafsu_makan']?.toString() ?? '',
      statusObat: json['status_obat']?.toString() ?? '',
      catatan: json['catatan']?.toString(),
      status: json['status']?.toString() ?? '',
      tanggal: DateTime.tryParse(json['tanggal'].toString()) ?? DateTime.now(),
      namaLansia: json['nama_lansia']?.toString() ?? '-',
    );
  }

  /// 🧩 Get normalized status untuk konsistensi
  String get normalizedStatus {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('stabil')) return 'Stabil';
    if (statusLower.contains('perhatian')) return 'Perlu Perhatian';
    return status;
  }
}