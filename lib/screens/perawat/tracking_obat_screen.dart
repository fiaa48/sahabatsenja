import 'package:flutter/material.dart';

class TrackingObatScreen extends StatelessWidget {
  const TrackingObatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trackingData = [
      {'obat': 'Obat Hipertensi', 'lansia': 'Ibu Rusi', 'waktu': '08:00', 'status': 'Sudah', 'tanggal': '15 Nov 2023'},
      {'obat': 'Vitamin D', 'lansia': 'Pak Budi', 'waktu': '10:00', 'status': 'Belum', 'tanggal': '15 Nov 2023'},
      {'obat': 'Obat Diabetes', 'lansia': 'Ibu Siti', 'waktu': '12:00', 'status': 'Sudah', 'tanggal': '15 Nov 2023'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tracking Obat'), backgroundColor: const Color(0xFF9C6223)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF9C6223),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildTrackingStat('Total', '12'), _buildTrackingStat('Sudah', '8'), _buildTrackingStat('Belum', '4')]),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: trackingData.length,
                itemBuilder: (context, index) {
                  final data = trackingData[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(Icons.medication, color: data['status'] == 'Sudah' ? Colors.green : Colors.red),
                      title: Text(data['obat']!),
                      subtitle: Text('${data['lansia']} - ${data['waktu']} - ${data['tanggal']}'),
                      trailing: Chip(label: Text(data['status']!), backgroundColor: data['status'] == 'Sudah' ? Colors.green : Colors.red),
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

  Widget _buildTrackingStat(String label, String value) {
    return Column(children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), Text(label, style: const TextStyle(color: Colors.white))]);
  }
}