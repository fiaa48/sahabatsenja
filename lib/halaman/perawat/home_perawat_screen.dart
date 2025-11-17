import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'data_lansia_screen.dart';
import 'kondisi_lansia_screen.dart';
import 'jadwal_perawat_screen.dart';
import 'jadwal_obat_screen.dart';
import 'tracking_obat_screen.dart';
import 'chat_detail_screen.dart';

class HomePerawatScreen extends StatefulWidget {
  const HomePerawatScreen({super.key});

  @override
  State<HomePerawatScreen> createState() => _HomePerawatScreenState();
}

class _HomePerawatScreenState extends State<HomePerawatScreen> {
  int _selectedIndex = 0;
  bool _isRefreshing = false;

  // Data user - nanti bisa diambil dari Firebase, SharedPreferences, atau provider
  String _userName = "Bahdanov Semi"; // Ganti dengan data dinamis
  String _userRole = "Perawat Senior"; // Ganti dengan data dinamis

  /// 🔄 Fungsi untuk refresh halaman
  Future<void> _refreshContent() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '🚨 Darurat!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Apakah kamu ingin mengirim peringatan ke keluarga lansia?\nGunakan fitur ini hanya jika lansia dalam kondisi gawat.',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('🚨 Peringatan darurat telah dikirim ke keluarga!')),
              );
            },
            icon: const Icon(Icons.send),
            label: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildDashboard(),
      _buildChatScreen(),
      const ProfileScreen(showAppBar: false),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isRefreshing
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF9C6223)))
          : screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF9C6223),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Sahabat Senja',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
          tooltip: 'Darurat',
          onPressed: () => _showEmergencyDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          tooltip: 'Notifikasi',
          onPressed: () {},
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF9C6223),
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Konsultasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  /// 🏠 DASHBOARD / HOME SCREEN
  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: _refreshContent,
      color: const Color(0xFF9C6223),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                kBottomNavigationBarHeight,
          ),
          child: Column(
            children: [
              // HEADER DENGAN BACKGROUND GAMBAR
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/home_gambar.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Halo,',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sahabat Senja',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _userRole,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // KONTEN UTAMA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // JUDUL MENU
                    const Text(
                      'Menu Perawat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // GRID MENU
                    Column(
                      children: [
                        // Baris 1
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuItem(
                                Icons.elderly,
                                'Data Lansia',
                                const DataLansiaScreen(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMenuItem(
                                Icons.favorite,
                                'Kondisi Lansia',
                                const KondisiLansiaScreen(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Baris 2
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuItem(
                                Icons.event_note,
                                'Jadwal Aktivitas',
                                const JadwalPerawatScreen(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMenuItem(
                                Icons.local_hospital,
                                'Jadwal Obat',
                                const JadwalObatScreen(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Baris 3
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuItem(
                                Icons.medication,
                                'Tracking Obat',
                                const TrackingObatScreen(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMenuItem(
                                Icons.assignment,
                                'Laporan',
                                const DataLansiaScreen(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    
                    // SPACER UNTUK MENGHINDARI BOTTOM OVERFLOW
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET MENU ITEM
  Widget _buildMenuItem(IconData icon, String title, Widget page) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C6223).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF9C6223),
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 💬 KONSULTASI / CHAT SCREEN
  Widget _buildChatScreen() {
    final keluargaList = [
      {
        'nama': 'Keluarga Ibu Rusi',
        'relation': 'Anak',
        'lastMessage': 'Terima kasih infonya bu...',
        'time': '10:30'
      },
      {
        'nama': 'Keluarga Pak Budi', 
        'relation': 'Cucu',
        'lastMessage': 'Besok saya jenguk...', 
        'time': '09:15'
      },
      {
        'nama': 'Keluarga Ibu Siti',
        'relation': 'Menantu',
        'lastMessage': 'Obat sudah sampai?',
        'time': 'Kemarin'
      },
      {
        'nama': 'Keluarga Bapak Joko',
        'relation': 'Anak',
        'lastMessage': 'Kondisi ayah bagaimana?',
        'time': '08:45'
      },
      {
        'nama': 'Keluarga Ibu Maryam',
        'relation': 'Cucu',
        'lastMessage': 'Terima kasih untuk laporannya',
        'time': 'Kemarin'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Konsultasi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari keluarga...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),

            // CHAT LIST
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshContent,
                color: const Color(0xFF9C6223),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: keluargaList.length,
                  itemBuilder: (context, index) {
                    final keluarga = keluargaList[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFF9C6223),
                          child: Text(
                            keluarga['nama']!.split(' ').last[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          keluarga['nama']!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${keluarga['relation']} • ${keluarga['lastMessage']}',
                          style: const TextStyle(color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              keluarga['time']!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (index == 0) // Hanya untuk chat terbaru
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatDetailScreen(namaKeluarga: keluarga['nama']!),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}