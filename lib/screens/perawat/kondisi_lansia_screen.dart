import 'package:flutter/material.dart';

class KondisiLansiaScreen extends StatefulWidget {
  const KondisiLansiaScreen({super.key});

  @override
  State<KondisiLansiaScreen> createState() => _KondisiLansiaScreenState();
}

class _KondisiLansiaScreenState extends State<KondisiLansiaScreen> {
  DateTime? selectedDate;
  String filterStatus = 'Semua';

  final List<Map<String, dynamic>> kondisiLansia = [
    {
      'nama': 'Ibu Rusi',
      'kamar': 'A-101',
      'tekananDarah': '120/80',
      'suhu': '36.5°C',
      'nadi': '72',
      'gulaDarah': '110 mg/dL',
      'saturasiOksigen': '98%',
      'statusObat': 'Sudah semua',
      'nafsuMakan': 'Baik',
      'catatan': 'Kondisi stabil, banyak tersenyum',
      'waktuUpdate': 'Hari ini, 10:30',
      'status': 'Stabil',
      'warna': Colors.green
    },
    {
      'nama': 'Pak Budi',
      'kamar': 'B-205',
      'tekananDarah': '140/90',
      'suhu': '37.2°C',
      'nadi': '85',
      'gulaDarah': '150 mg/dL',
      'saturasiOksigen': '95%',
      'statusObat': 'Belum vitamin D',
      'nafsuMakan': 'Kurang',
      'catatan': 'Perlu monitoring tekanan darah',
      'waktuUpdate': 'Hari ini, 09:15',
      'status': 'Perlu Perhatian',
      'warna': Colors.orange
    },
    {
      'nama': 'Ibu Siti',
      'kamar': 'A-102',
      'tekananDarah': '110/70',
      'suhu': '36.8°C',
      'nadi': '68',
      'gulaDarah': '95 mg/dL',
      'saturasiOksigen': '97%',
      'statusObat': 'Sudah semua',
      'nafsuMakan': 'Sangat Baik',
      'catatan': 'Makan lancar, aktif bergerak',
      'waktuUpdate': 'Hari ini, 11:00',
      'status': 'Stabil',
      'warna': Colors.green
    },
  ];

  List<Map<String, dynamic>> get filteredLansia {
    if (filterStatus == 'Semua') return kondisiLansia;
    return kondisiLansia.where((lansia) => lansia['status'] == filterStatus).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Kondisi Lansia'),
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
                  '❤️ MONITORING KESEHATAN HARIAN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C6223),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Data vital signs dan kondisi terkini lansia',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF9C6223),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFF9C6223)),
                      ),
                    ),
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      selectedDate == null
                          ? 'Pilih Tanggal'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButton<String>(
                      value: filterStatus,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: ['Semua', 'Stabil', 'Perlu Perhatian']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          filterStatus = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Summary Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard('Total', '${kondisiLansia.length}', Colors.blue, Icons.people),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard('Stabil', 
                    '${kondisiLansia.where((l) => l['status'] == 'Stabil').length}', 
                    Colors.green, 
                    Icons.check_circle
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard('Perhatian', 
                    '${kondisiLansia.where((l) => l['status'] == 'Perlu Perhatian').length}', 
                    Colors.orange, 
                    Icons.warning
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // List Kondisi Lansia
          Expanded(
            child: ListView.builder(
              itemCount: filteredLansia.length,
              itemBuilder: (context, index) {
                final lansia = filteredLansia[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header dengan nama dan status
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: lansia['warna'] as Color,
                              radius: 20,
                              child: const Icon(Icons.person, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lansia['nama']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    'Kamar ${lansia['kamar']} • ${lansia['waktuUpdate']}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(lansia['status']!),
                              backgroundColor: lansia['warna'] as Color,
                              labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Vital Signs
                        const Text(
                          'Tanda-Tanda Vital:',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildVitalItem('❤️ TD', lansia['tekananDarah']!),
                            _buildVitalItem('🌡️ Suhu', lansia['suhu']!),
                            _buildVitalItem('💓 Nadi', '${lansia['nadi']} bpm'),
                            _buildVitalItem('🩸 Gula', lansia['gulaDarah']!),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildVitalItem('💨 SpO2', lansia['saturasiOksigen']!),
                            _buildVitalItem('💊 Obat', lansia['statusObat']!),
                            _buildVitalItem('🍽️ Makan', lansia['nafsuMakan']!),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Catatan
                        if (lansia['catatan'] != null && lansia['catatan']!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Catatan:',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lansia['catatan']!,
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalItem(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}