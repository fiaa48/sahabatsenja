import 'package:flutter/material.dart';

class JadwalObatScreen extends StatelessWidget {
  const JadwalObatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jadwalObat = [
      {'nama': 'Obat Hipertensi', 'dosis': '1x sehari', 'waktu': 'Pagi', 'lansia': 'Ibu Rusi'},
      {'nama': 'Vitamin D', 'dosis': '2x sehari', 'waktu': 'Pagi & Malam', 'lansia': 'Pak Budi'},
      {'nama': 'Obat Diabetes', 'dosis': '3x sehari', 'waktu': 'Setelah makan', 'lansia': 'Ibu Siti'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Obat'), backgroundColor: const Color(0xFF9C6223)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildSummaryCard('Total Obat', '15', Colors.blue)),
                const SizedBox(width: 10),
                Expanded(child: _buildSummaryCard('Harus Diberikan', '8', Colors.orange)),
                const SizedBox(width: 10),
                Expanded(child: _buildSummaryCard('Sudah Diberikan', '7', Colors.green)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: jadwalObat.length,
                itemBuilder: (context, index) {
                  final obat = jadwalObat[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: Colors.purple),
                      title: Text(obat['nama']!),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Dosis: ${obat['dosis']}'), Text('Waktu: ${obat['waktu']}'), Text('Untuk: ${obat['lansia']}')]),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      color: color,
      child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), Text(title, style: const TextStyle(fontSize: 12, color: Colors.white))])),
    );
  }
}