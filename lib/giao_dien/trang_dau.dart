import 'package:flutter/material.dart';
import 'dart:async';

class TrangWidget extends StatelessWidget {
  const TrangWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(
              'assets/images/ảnh_nền.jpg',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            const Spacer(flex: 2),
            Column(
              children: [
                Image.asset('assets/images/anh1.jpg', width: 60),
                const SizedBox(height: 10),
                Center(
                  child: const Text(
                    'Quản lý chi tiêu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
