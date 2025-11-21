import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatPerawatScreen extends StatefulWidget {
  final int datalansiaId;
  final String namaKeluarga;

  const ChatPerawatScreen({
    super.key,
    required this.datalansiaId,
    required this.namaKeluarga,
  });

  @override
  State<ChatPerawatScreen> createState() => _ChatPerawatScreenState();
}

class _ChatPerawatScreenState extends State<ChatPerawatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService service = ChatService();

  List chats = [];

  @override
  void initState() {
    super.initState();
    loadChat();
  }

  Future<void> loadChat() async {
    final data = await service.getMessages(widget.datalansiaId);
    chats = data;

    setState(() {});

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final ok = await service.sendMessage(
      datalansiaId: widget.datalansiaId,
      sender: "Perawat",
      pesan: text,
    );

    if (ok) {
      _controller.clear();
      loadChat();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengirim pesan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat: ${widget.namaKeluarga}"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: chats.isEmpty
                ? const Center(child: Text("Belum ada pesan"))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final msg = chats[index];
                      final bool isMe = msg["sender"] == "Perawat";

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                isMe ? Colors.teal[300] : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg["pesan"] ?? "",
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// Input text
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
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
