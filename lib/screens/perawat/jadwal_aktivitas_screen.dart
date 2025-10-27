import 'package:flutter/material.dart';

class JadwalAktivitasScreen extends StatefulWidget {
  const JadwalAktivitasScreen({super.key});

  @override
  State<JadwalAktivitasScreen> createState() => _JadwalAktivitasScreenState();
}

class _JadwalAktivitasScreenState extends State<JadwalAktivitasScreen> {
  List<Map<String, dynamic>> aktivitasList = [
    {'waktu': '08:00 - 09:00', 'judul': 'SENAM PAGI', 'deskripsi': 'Senam ringan untuk lansia', 'lokasi': 'Lapangan Utama', 'peserta': 'Semua penghuni', 'completed': false},
    {'waktu': '10:00 - 11:00', 'judul': 'TERAPI FISIK', 'deskripsi': 'Pijat dan stretching', 'lokasi': 'Ruang Terapi', 'peserta': 'Kelompok A', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Aktivitas'), backgroundColor: const Color(0xFF9C6223)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('JADWAL AKTIVITAS PANTI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Center(child: Text('${_getHariIni()}, ${_getTanggalHariIni()}', style: const TextStyle(fontSize: 16, color: Colors.grey))),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: aktivitasList.length,
                itemBuilder: (context, index) {
                  final aktivitas = aktivitasList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 8),
                              Text(aktivitas['waktu'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 16),
                              Expanded(child: Text(aktivitas['judul'], style: const TextStyle(fontWeight: FontWeight.bold))),
                              Checkbox(value: aktivitas['completed'], onChanged: (value) => setState(() => aktivitasList[index]['completed'] = value!)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('✗ ${aktivitas['deskripsi']}'),
                          const SizedBox(height: 4),
                          Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.green), const SizedBox(width: 4), Text(aktivitas['lokasi'])]),
                          const SizedBox(height: 4),
                          Row(children: [const Icon(Icons.people, size: 16, color: Colors.purple), const SizedBox(width: 4), Text(aktivitas['peserta'])]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('TAMBAH AKTIVITAS BARU'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C6223)),
                onPressed: () => _showTambahAktivitasDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTambahAktivitasDialog(BuildContext context) {
    TextEditingController waktuController = TextEditingController();
    TextEditingController judulController = TextEditingController();
    TextEditingController deskripsiController = TextEditingController();
    TextEditingController lokasiController = TextEditingController();
    TextEditingController pesertaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Aktivitas Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: waktuController, decoration: const InputDecoration(labelText: 'Waktu (contoh: 08:00 - 09:00)')),
              TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Judul Aktivitas')),
              TextField(controller: deskripsiController, decoration: const InputDecoration(labelText: 'Deskripsi')),
              TextField(controller: lokasiController, decoration: const InputDecoration(labelText: 'Lokasi')),
              TextField(controller: pesertaController, decoration: const InputDecoration(labelText: 'Peserta')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (waktuController.text.isNotEmpty && judulController.text.isNotEmpty) {
                setState(() {
                  aktivitasList.add({
                    'waktu': waktuController.text,
                    'judul': judulController.text,
                    'deskripsi': deskripsiController.text,
                    'lokasi': lokasiController.text,
                    'peserta': pesertaController.text,
                    'completed': false
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aktivitas baru berhasil ditambahkan!')));
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  String _getHariIni() => ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'][DateTime.now().weekday];
  String _getTanggalHariIni() => '${DateTime.now().day} ${['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'][DateTime.now().month]} ${DateTime.now().year}';
}