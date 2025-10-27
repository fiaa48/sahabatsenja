import 'package:flutter/material.dart';

class DetailLansiaScreen extends StatefulWidget {
  final String namaLansia;
  const DetailLansiaScreen({super.key, required this.namaLansia});

  @override
  State<DetailLansiaScreen> createState() => _DetailLansiaScreenState();
}

class _DetailLansiaScreenState extends State<DetailLansiaScreen> {
  int _selectedAppetite = 2;
  List<bool> _obatStatus = [true, false, false];
  TextEditingController sistolikController = TextEditingController(text: '120');
  TextEditingController diastolikController = TextEditingController(text: '80');
  TextEditingController nadiController = TextEditingController(text: '72');
  TextEditingController catatanController = TextEditingController(text: 'Kondisi hari ini stabil, banyak tersenyum...');
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2025));
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Data - ${widget.namaLansia}'), backgroundColor: const Color(0xFF9C6223)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('INPUT DATA KESEHATAN - ${widget.namaLansia}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: GestureDetector(onTap: () => _selectDate(context), child: _buildDateTimeField('Tanggal', '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'))),
                  const SizedBox(width: 16),
                  Expanded(child: GestureDetector(onTap: () => _selectTime(context), child: _buildDateTimeField('Waktu', _selectedTime.format(context)))),
                ],
              ),
              const SizedBox(height: 20),
              const Text('☑ STATUS OBAT:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildObatItem('Obat Cacing', 0),
              _buildObatItem('Vitamin D', 1),
              _buildObatItem('Obat Hipertensi', 2),
              const SizedBox(height: 20),
              const Text('📖 NAFSU MAKAN:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAppetiteOption('Sangat\nKurang', 0),
                  _buildAppetiteOption('Kurang', 1),
                  _buildAppetiteOption('Normal', 2),
                  _buildAppetiteOption('Baik', 3),
                  _buildAppetiteOption('Sangat\nBaik', 4),
                ],
              ),
              const SizedBox(height: 20),
              const Text('🔍 TEKANAN DARAH:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildNumberField('Sistolik', sistolikController, 'mmHg')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildNumberField('Diastolik', diastolikController, 'mmHg')),
                ],
              ),
              const SizedBox(height: 20),
              const Text('🔍 DENYUT NADI:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildNumberField('Denyut Nadi', nadiController, 'bpm'),
              const SizedBox(height: 20),
              const Text('☑ CATATAN TAMBAHAN:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: catatanController, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Tulis catatan tambahan...')),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('SIMPAN DATA'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C6223), padding: const EdgeInsets.symmetric(vertical: 15)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data kesehatan berhasil disimpan!')));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text('BATAL'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:'),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
          child: Row(children: [Text(value), const Spacer(), const Icon(Icons.arrow_drop_down, color: Colors.grey)]),
        ),
      ],
    );
  }

  Widget _buildObatItem(String namaObat, int index) {
    return Row(children: [
      Checkbox(value: _obatStatus[index], onChanged: (value) => setState(() => _obatStatus[index] = value!)),
      Text('$namaObat - ${_obatStatus[index] ? 'Sudah diminum' : 'Belum diminum'}'),
    ]);
  }

  Widget _buildAppetiteOption(String label, int value) {
    return Column(children: [
      Radio(value: value, groupValue: _selectedAppetite, onChanged: (newValue) => setState(() => _selectedAppetite = newValue!)),
      Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
    ]);
  }

  Widget _buildNumberField(String label, TextEditingController controller, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:'),
        const SizedBox(height: 4),
        Row(children: [
          Expanded(child: TextField(controller: controller, keyboardType: TextInputType.number, decoration: InputDecoration(border: const OutlineInputBorder(), suffixText: unit))),
        ]),
      ],
    );
  }
}