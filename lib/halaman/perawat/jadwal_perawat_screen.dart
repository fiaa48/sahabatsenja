import 'package:flutter/material.dart';
import 'package:sahabatsenja_app/halaman/services/jadwal_aktivitas_service.dart';
import 'package:sahabatsenja_app/models/jadwal_aktivitas_model.dart';

class JadwalPerawatScreen extends StatefulWidget {
  const JadwalPerawatScreen({super.key});

  @override
  State<JadwalPerawatScreen> createState() => _JadwalPerawatScreenState();
}

class _JadwalPerawatScreenState extends State<JadwalPerawatScreen> {
  List<JadwalAktivitas> _list = [];
  bool _loading = true;
  final JadwalService _service = JadwalService();

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  Future<void> _loadJadwal() async {
    setState(() => _loading = true);
    try {
      final data = await _service.fetchJadwal();
      setState(() => _list = data);
    } catch (e) {
      print('⚠️ Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.brown[700],
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown[50]!,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: _loading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Memuat jadwal...',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadJadwal,
                color: Colors.brown[700],
                child: _list.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.brown.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                size: 60,
                                color: Colors.brown[300],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Belum ada aktivitas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap + untuk menambah aktivitas baru',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.brown[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          final a = _list[index];
                          return _buildActivityCard(a, index);
                        },
                      ),
              ),
      ),
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: _loading ? 0 : 1,
        child: FloatingActionButton(
          onPressed: _showTambahDialog,
          child: const Icon(Icons.add, size: 28),
          backgroundColor: Colors.brown[700],
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(JadwalAktivitas a, int index) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final dayName = days[a.tanggal.weekday % 7];
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: a.completed
                  ? [Colors.green[50]!, Colors.green[100]!]
                  : [Colors.white, Colors.orange[50]!],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showDetail(a),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Status Indicator
                    Container(
                      width: 4,
                      height: 60,
                      decoration: BoxDecoration(
                        color: a.completed ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Date Box
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: a.completed ? Colors.green : Colors.brown[700],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (a.completed ? Colors.green : Colors.brown)!.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            a.tanggal.day.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${a.tanggal.month.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  a.judul,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    decoration: a.completed ? TextDecoration.lineThrough : null,
                                    color: a.completed ? Colors.grey : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (a.completed)
                                Icon(
                                  Icons.verified,
                                  color: Colors.green[700],
                                  size: 16,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '$dayName, ${a.tanggal.toLocal().toString().split(' ')[0]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                a.waktu,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (a.lokasi.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    a.lokasi,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Menu
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                      onSelected: (value) => _handleMenuAction(value, a),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red[700]),
                              const SizedBox(width: 8),
                              const Text('Hapus'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action, JadwalAktivitas a) {
    switch (action) {
      case 'edit':
        _showEditDialog(a);
        break;
      case 'delete':
        _showDeleteDialog(a);
        break;
    }
  }

  void _showDeleteDialog(JadwalAktivitas a) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Hapus Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('Yakin ingin menghapus "${a.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            onPressed: () async {
              final success = await _service.hapusJadwal(a.id!);
              if (success) {
                _loadJadwal();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Aktivitas berhasil dihapus'),
                    backgroundColor: Colors.green[400],
                  ),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(JadwalAktivitas a) {
    final judul = TextEditingController(text: a.judul);
    final deskripsi = TextEditingController(text: a.deskripsi);
    final lokasi = TextEditingController(text: a.lokasi);
    final peserta = TextEditingController(text: a.peserta);
    TimeOfDay? selectedTime = TimeOfDay.fromDateTime(a.tanggal);
    DateTime? selectedDate = a.tanggal;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Aktivitas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judul,
                  decoration: InputDecoration(
                    labelText: 'Judul Aktivitas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: deskripsi,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lokasi,
                  decoration: InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: peserta,
                  decoration: InputDecoration(
                    labelText: 'Peserta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Date Picker Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal & Hari',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.brown[700]!,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? '${_getDayName(selectedDate!)}, ${selectedDate!.toLocal().toString().split(' ')[0]}'
                                      : 'Pilih Tanggal',
                                  style: TextStyle(
                                    color: selectedDate != null ? Colors.black87 : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (selectedDate != null)
                                  Text(
                                    _getFormattedDate(selectedDate!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            Icon(Icons.calendar_today, color: Colors.brown[700]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Time Picker Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Waktu',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now(),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.brown[700]!,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedTime = picked);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTime != null
                                  ? '${selectedTime!.format(context)}'
                                  : 'Pilih Waktu',
                              style: TextStyle(
                                color: selectedTime != null ? Colors.black87 : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.access_time, color: Colors.brown[700]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (judul.text.isEmpty || selectedDate == null || selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Harap isi judul, tanggal, dan waktu'),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                  return;
                }
                
                final updatedAktivitas = JadwalAktivitas(
                  id: a.id,
                  judul: judul.text,
                  deskripsi: deskripsi.text,
                  lokasi: lokasi.text,
                  peserta: peserta.text,
                  tanggal: DateTime(
                    selectedDate!.year, 
                    selectedDate!.month, 
                    selectedDate!.day, 
                    selectedTime!.hour, 
                    selectedTime!.minute
                  ),
                  waktu: selectedTime!.format(context),
                  completed: a.completed,
                );
                
                final success = await _service.updateJadwal(updatedAktivitas);
                if (success) {
                  _loadJadwal();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Aktivitas berhasil diupdate'),
                      backgroundColor: Colors.green[400],
                    ),
                  );
                }
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return days[date.weekday % 7];
  }

  String _getFormattedDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showTambahDialog() {
    final judul = TextEditingController();
    final deskripsi = TextEditingController();
    final lokasi = TextEditingController();
    final peserta = TextEditingController();
    TimeOfDay? selectedTime;
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Tambah Aktivitas Baru',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judul,
                  decoration: InputDecoration(
                    labelText: 'Judul Aktivitas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: deskripsi,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lokasi,
                  decoration: InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: peserta,
                  decoration: InputDecoration(
                    labelText: 'Peserta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Date Picker Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal & Hari',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.brown[700]!,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? '${_getDayName(selectedDate!)}, ${selectedDate!.toLocal().toString().split(' ')[0]}'
                                      : 'Pilih Tanggal',
                                  style: TextStyle(
                                    color: selectedDate != null ? Colors.black87 : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (selectedDate != null)
                                  Text(
                                    _getFormattedDate(selectedDate!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            Icon(Icons.calendar_today, color: Colors.brown[700]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Time Picker Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Waktu',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now(),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.brown[700]!,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedTime = picked);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTime != null
                                  ? '${selectedTime!.format(context)}'
                                  : 'Pilih Waktu',
                              style: TextStyle(
                                color: selectedTime != null ? Colors.black87 : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.access_time, color: Colors.brown[700]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (judul.text.isEmpty || selectedDate == null || selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Harap isi judul, tanggal, dan waktu'),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                  return;
                }
                
                final newAktivitas = JadwalAktivitas(
                  judul: judul.text,
                  deskripsi: deskripsi.text,
                  lokasi: lokasi.text,
                  peserta: peserta.text,
                  tanggal: DateTime(
                    selectedDate!.year, 
                    selectedDate!.month, 
                    selectedDate!.day, 
                    selectedTime!.hour, 
                    selectedTime!.minute
                  ),
                  waktu: selectedTime!.format(context),
                );
                
                final success = await _service.tambahJadwal(newAktivitas);
                if (success) {
                  _loadJadwal();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Aktivitas berhasil ditambahkan'),
                      backgroundColor: Colors.green[400],
                    ),
                  );
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Filter Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.filter_list, color: Colors.brown[700]),
              title: const Text('Semua Aktivitas'),
              onTap: () {
                // Implement filter logic
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green[700]),
              title: const Text('Selesai'),
              onTap: () {
                // Implement filter logic
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.orange[700]),
              title: const Text('Belum Selesai'),
              onTap: () {
                // Implement filter logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(JadwalAktivitas a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.brown[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            a.judul,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.brown[700]),
                          onPressed: () {
                            Navigator.pop(context);
                            _showEditDialog(a);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: a.completed ? Colors.green[100] : Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            a.completed ? Icons.check_circle : Icons.access_time,
                            size: 14,
                            color: a.completed ? Colors.green[800] : Colors.orange[800],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            a.completed ? 'SELESAI' : 'BELUM SELESAI',
                            style: TextStyle(
                              color: a.completed ? Colors.green[800] : Colors.orange[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Detail Information
                    _buildDetailItem(Icons.description, 'Deskripsi', a.deskripsi),
                    _buildDetailItem(Icons.calendar_today, 'Tanggal & Hari', 
                        '${_getDayName(a.tanggal)}, ${a.tanggal.toLocal().toString().split(' ')[0]}'),
                    _buildDetailItem(Icons.access_time, 'Waktu', a.waktu),
                    if (a.lokasi.isNotEmpty)
                      _buildDetailItem(Icons.location_on, 'Lokasi', a.lokasi),
                    if (a.peserta.isNotEmpty)
                      _buildDetailItem(Icons.people, 'Peserta', a.peserta),
                    
                    const Spacer(),
                    
                    // Action Buttons
                    Row(
                      children: [
                        if (!a.completed)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                final success = await _service.updateCompleted(a.id!, true);
                                if (success) {
                                  setState(() => a.completed = true);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Aktivitas ditandai selesai'),
                                      backgroundColor: Colors.green[400],
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Tandai Selesai',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteDialog(a);
                            },
                            child: const Text(
                              'Hapus',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.brown[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.brown[700], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}