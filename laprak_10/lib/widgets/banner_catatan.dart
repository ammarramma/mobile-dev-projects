import 'package:flutter/material.dart';

class BannerCatatan extends StatelessWidget {
  const BannerCatatan({super.key, required this.teks});

  final String teks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.teal.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              teks,
              style: TextStyle(fontSize: 13, color: Colors.teal.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
