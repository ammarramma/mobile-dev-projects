import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF2F4F8),
      ),
      home: const ProfilMahasiswa(),
    );
  }
}

class ProfilMahasiswa extends StatelessWidget {
  const ProfilMahasiswa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Mahasiswa"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ============================================
                  // ✨ AVATAR dengan BORDER RING
                  // ============================================
                  Container(
                    padding: const EdgeInsets.all(4), // tebal ring
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Gradient ring biar kece
                      gradient: const LinearGradient(
                        colors: [Colors.indigo, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4), // gap putih
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('Images/ammar.jpg'),
                        // Kalau tanpa gambar:
                        // child: Icon(Icons.person, size: 60, color: Colors.indigo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === Nama, NIM, Prodi ===
                  const Text(
                    "Ammar",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "2024573010129 • Teknik Informatika",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // === Container info (Semester, IPK, SKS) ===
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.indigo.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: _InfoKolom(angka: "5", label: "Semester"),
                        ),
                        Expanded(
                          child: _InfoKolom(angka: "3.71", label: "IPK"),
                        ),
                        Expanded(
                          child: _InfoKolom(angka: "106", label: "SKS"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // === Ikon media sosial (dengan HOVER) ===
                  const Divider(thickness: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _SosialIcon(icon: Icons.camera_alt, color: Colors.pink),
                      _SosialIcon(icon: Icons.code, color: Colors.black87),
                      _SosialIcon(icon: Icons.email, color: Colors.redAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget kolom info
class _InfoKolom extends StatelessWidget {
  final String angka;
  final String label;

  const _InfoKolom({required this.angka, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          angka,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}

// ============================================================
// ✨ IKON SOSMED dengan HOVER EFFECT
// ============================================================
class _SosialIcon extends StatefulWidget {
  final IconData icon;
  final Color color;

  const _SosialIcon({required this.icon, required this.color});

  @override
  State<_SosialIcon> createState() => _SosialIconState();
}

class _SosialIconState extends State<_SosialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
        // scale saat hover
        transformAlignment: Alignment.center,
        child: AnimatedScale(
          scale: _isHovered ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered
                  ? widget.color
                  : widget.color.withValues(alpha: 0.12),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.45),
                        blurRadius: 14,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              widget.icon,
              color: _isHovered ? Colors.white : widget.color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
