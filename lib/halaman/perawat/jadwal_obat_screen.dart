import 'package:flutter/material.dart';
import 'package:sahabatsenja_app/halaman/services/jadwal_obat_service.dart';
import 'package:sahabatsenja_app/models/jadwal_obat_model.dart';

class JadwalObatScreen extends StatefulWidget {
  final int datalansiaId;

  const JadwalObatScreen({super.key, required this.datalansiaId});

  @override
  State<JadwalObatScreen> createState() => _JadwalObatScreenState();
}

class _JadwalObatScreenState extends State<JadwalObatScreen> {
  final JadwalObatService service = JadwalObatService();
  List<JadwalObat> jadwal = [];
  bool isLoading = true;

  // Filter
  String filterWaktu = "Semua";

  // form input
  final TextEditingController namaObatC = TextEditingController();
  final TextEditingController dosisC = TextEditingController();
  String? waktuSelected;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    setState(() => isLoading = true);
    jadwal = await service.fetchJadwalObat(widget.datalansiaId);
    setState(() => isLoading = false);
  }

  Future<void> tambahObat() async {
    if (namaObatC.text.isEmpty || dosisC.text.isEmpty || waktuSelected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data harus diisi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool success = await service.tambahJadwalObat(
      datalansiaId: widget.datalansiaId,
      namaObat: namaObatC.text,
      dosis: dosisC.text,
      waktu: waktuSelected!,
    );

    if (success) {
      Navigator.pop(context);
      namaObatC.clear();
      dosisC.clear();
      setState(() => waktuSelected = null);
      fetchData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jadwal obat berhasil ditambahkan"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menambah jadwal obat"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateStatus(int id, bool value) async {
    bool success = await service.updateStatus(id, value);
    if (success) {
      fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal update status"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteObat(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Jadwal Obat"),
        content: const Text("Apakah Anda yakin ingin menghapus jadwal obat ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await service.deleteJadwalObat(id);
      if (success) {
        fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Jadwal obat berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menghapus jadwal obat"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔎 Filter jadwal sesuai pilihan
    final jadwalFiltered = filterWaktu == "Semua"
        ? jadwal
        : jadwal.where((j) => j.waktu == filterWaktu).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Obat"),
        backgroundColor: const Color(0xFF9C6223),
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9C6223),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: openAddDialog,
      ),

      body: Column(
        children: [
          // 🔽 WIDGET FILTER
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField(
              value: filterWaktu,
              decoration: const InputDecoration(
                labelText: "Filter Waktu",
                border: OutlineInputBorder(),
              ),
              items: ["Semua", "Pagi", "Siang", "Sore", "Malam"]
                  .map((w) => DropdownMenuItem(
                        value: w,
                        child: Text(w),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() => filterWaktu = val!);
              },
            ),
          ),

          // 🔹 ISI LIST DATA
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : jadwalFiltered.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada jadwal obat",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: jadwalFiltered.length,
                        itemBuilder: (context, index) {
                          final item = jadwalFiltered[index];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Checkbox(
                                value: item.completed,
                                onChanged: (val) =>
                                    updateStatus(item.id, val!),
                              ),
                              title: Text(
                                item.namaObat,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: item.completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: item.completed ? Colors.grey : Colors.black,
                                ),
                              ),
                              subtitle: Text("${item.dosis} • ${item.waktu}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteObat(item.id),
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

  // 🔹 POPUP TAMBAH OBAT
  void openAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Tambah Jadwal Obat"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaObatC,
                      decoration: const InputDecoration(
                        labelText: "Nama Obat",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dosisC,
                      decoration: const InputDecoration(
                        labelText: "Dosis",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Waktu",
                        border: OutlineInputBorder(),
                      ),
                      value: waktuSelected,
                      items: ["Pagi", "Siang", "Sore", "Malam"]
                          .map((w) => DropdownMenuItem(
                                child: Text(w),
                                value: w,
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => waktuSelected = val.toString());
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Batal"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C6223),
                  ),
                  onPressed: tambahObat,
                  child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                )
              ],
            );
          },
        );
      },
    );
  }
}