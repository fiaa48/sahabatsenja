class JadwalAktivitas {
  int? id;
  String waktu;
  String judul;
  String deskripsi;
  String lokasi;
  String peserta;
  bool completed;
  DateTime tanggal;

  JadwalAktivitas({
    this.id,
    required this.waktu,
    required this.judul,
    required this.deskripsi,
    required this.lokasi,
    required this.peserta,
    this.completed = false,
    required this.tanggal,
  });

  factory JadwalAktivitas.fromJson(Map<String, dynamic> json) => JadwalAktivitas(
        id: json['id'],
        waktu: json['waktu'] ?? '',
        judul: json['judul'] ?? '',
        deskripsi: json['deskripsi'] ?? '',
        lokasi: json['lokasi'] ?? '',
        peserta: json['peserta'] ?? '',
        completed: json['completed'] == 1 || json['completed'] == true,
        tanggal: DateTime.parse(json['tanggal']),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'waktu': waktu,
        'judul': judul,
        'deskripsi': deskripsi,
        'lokasi': lokasi,
        'peserta': peserta,
        'completed': completed,
        'tanggal': tanggal.toIso8601String(),
      };
}