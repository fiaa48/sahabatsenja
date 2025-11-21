import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import 'chat_perawat_screen.dart';

class ListChatPerawatScreen extends StatelessWidget {
  final int perawatId;

  const ListChatPerawatScreen({super.key, required this.perawatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Chat Keluarga"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: ChatService().getListChatPerawat(perawatId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text("Belum ada chat"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return ListTile(
                leading: const Icon(Icons.person, color: Colors.teal),
                title: Text(item["nama_keluarga"]),
                subtitle: Text(item["last_chat"] ?? ""),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPerawatScreen(
                        datalansiaId: item["datalansia_id"],
                        namaKeluarga: item["nama_keluarga"],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
