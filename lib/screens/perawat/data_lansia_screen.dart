import 'package:flutter/material.dart';
import 'detail_lansia_screen.dart';

class DataLansiaScreen extends StatefulWidget {
  const DataLansiaScreen({super.key});

  @override
  State<DataLansiaScreen> createState() => _DataLansiaScreenState();
}

class _DataLansiaScreenState extends State<DataLansiaScreen> {
  final List<Map<String, dynamic>> lansiaList = [
    {
      'nama': 'Ibu Rusi',
      'usia': '78 tahun',
      'tanggalLahir': '15 Maret 1945',
      'kamar': 'A-101',
      'alamat': 'Jl. Merdeka No. 123, Jakarta',
      'kontakDarurat': '08123456789 (Anak - Rina)',
      'riwayatPenyakit': 'Hipertensi, Diabetes',
      'alergi': 'Tidak ada',
      'golonganDarah': 'O+',
      'dataKeluarga': 'Anak: Rina (08123456789)',
      'status': 'Stabil'
    },
    {
      'nama': 'Pak Budi',
      'usia': '82 tahun',
      'tanggalLahir': '10 Agustus 1941',
      'kamar': 'B-205',
      'alamat': 'Jl. Sudirman No. 45, Bandung',
      'kontakDarurat': '08129876543 (Cucu - Andi)',
      'riwayatPenyakit': 'Jantung, Asam Urat',
      'alergi': 'Debu, Udang',
      'golonganDarah': 'A+',
      'dataKeluarga': 'Cucu: Andi (08129876543)',
      'status': 'Perlu Perhatian'
    },
    {
      'nama': 'Ibu Siti',
      'usia': '75 tahun',
      'tanggalLahir': '20 Desember 1948',
      'kamar': 'A-102',
      'alamat': 'Jl. Gatot Subroto No. 67, Surabaya',
      'kontakDarurat': '08111222333 (Menantu - Dewi)',
      'riwayatPenyakit': 'Osteoporosis',
      'alergi': 'Kacang, Susu',
      'golonganDarah': 'B+',
      'dataKeluarga': 'Menantu: Dewi (08111222333)',
      'status': 'Stabil'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Master Lansia'),
        backgroundColor: const Color(0xFF9C6223),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF9C6223).withOpacity(0.1),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📋 DATA MASTER LANSIA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C6223),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Informasi dasar dan profil tetap lansia',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: lansiaList.length,
              itemBuilder: (context, index) {
                final lansia = lansiaList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF9C6223),
                      child: Text(
                        lansia['nama']!.toString().substring(0, 1),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      lansia['nama']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('👵 ${lansia['usia']} - Kamar ${lansia['kamar']}'),
                        Text('🏠 ${lansia['alamat']}'),
                        Text('🩸 Gol. Darah: ${lansia['golonganDarah']}'),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: lansia['status'] == 'Stabil' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: lansia['status'] == 'Stabil' ? Colors.green : Colors.orange,
                            ),
                          ),
                          child: Text(
                            lansia['status']!,
                            style: TextStyle(
                              color: lansia['status'] == 'Stabil' ? Colors.green : Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showDetailDialog(context, lansia);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> lansia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Profil - ${lansia['nama']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('👤 Nama Lengkap', lansia['nama']!),
              _buildDetailItem('🎂 Tanggal Lahir', lansia['tanggalLahir']!),
              _buildDetailItem('🏠 Kamar', lansia['kamar']!),
              _buildDetailItem('📍 Alamat', lansia['alamat']!),
              _buildDetailItem('📞 Kontak Darurat', lansia['kontakDarurat']!),
              _buildDetailItem('🏥 Riwayat Penyakit', lansia['riwayatPenyakit']!),
              _buildDetailItem('⚠️ Alergi', lansia['alergi']!),
              _buildDetailItem('🩸 Golongan Darah', lansia['golonganDarah']!),
              _buildDetailItem('👨‍👩‍👧‍👦 Data Keluarga', lansia['dataKeluarga']!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C6223)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailLansiaScreen(namaLansia: lansia['nama']!),
                ),
              );
            },
            child: const Text('INPUT DATA HARIAN'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}