import 'package:flutter/material.dart';

class BottomActions extends StatelessWidget {
  const BottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   children: [
        //     Expanded(
        //       child: ElevatedButton.icon(
        //         onPressed: () {},
        //         icon: const Icon(Icons.qr_code_scanner),
        //         label: const Text(
        //           'Scan QR',
        //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //         ),
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: const Color(0xFF0EA5E9),
        //           foregroundColor: Colors.white,
        //           padding: const EdgeInsets.symmetric(vertical: 18),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(16),
        //           ),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 12),
        //     Expanded(
        //       child: OutlinedButton.icon(
        //         onPressed: () {},
        //         icon: const Icon(Icons.ios_share),
        //         label: const Text(
        //           'Share QR',
        //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        //         ),
        //         style: OutlinedButton.styleFrom(
        //           foregroundColor: Colors.white70,
        //           side: const BorderSide(color: Color(0xFF374151)),
        //           padding: const EdgeInsets.symmetric(vertical: 18),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(16),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.phone, size: 24),
            label: const Text(
              'Emergency Call',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}