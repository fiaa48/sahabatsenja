class JadwalObat {
  final int id;
  final int datalansiaId;
  final String namaObat;
  final String dosis;
  final String waktu;
  final bool completed;
  final DateTime? lastGiven;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JadwalObat({
    required this.id,
    required this.datalansiaId,
    required this.namaObat,
    required this.dosis,
    required this.waktu,
    required this.completed,
    this.lastGiven,
    this.createdAt,
    this.updatedAt,
  });

  factory JadwalObat.fromJson(Map<String, dynamic> json) {
    print("📋 Parsing JSON: $json");
    
    return JadwalObat(
      id: json['id'] ?? 0,
      datalansiaId: json['datalansia_id'] ?? json['datalansiaId'] ?? 0,
      namaObat: json['nama_obat'] ?? json['namaObat'] ?? '',
      dosis: json['dosis'] ?? '',
      waktu: json['waktu'] ?? '',
      completed: json['completed'] == 1 || 
                json['completed'] == true || 
                (json['completed'] is String && json['completed'] == '1'),
      lastGiven: json['last_given'] != null && json['last_given'] is String
          ? DateTime.tryParse(json['last_given']) 
          : null,
      createdAt: json['created_at'] != null && json['created_at'] is String
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null && json['updated_at'] is String
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datalansia_id': datalansiaId,
      'nama_obat': namaObat,
      'dosis': dosis,
      'waktu': waktu,
      'completed': completed,
      'last_given': lastGiven?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}