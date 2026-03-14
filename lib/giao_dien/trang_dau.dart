import 'package:flutter/material.dart';
import 'dart:async';
import 'package:btap_lon/giao_dien/screen_chi_tieu.dart';

class TrangWidget extends StatefulWidget {
  const TrangWidget({super.key});

  @override
  State<TrangWidget> createState() => _TrangWidgetState();
}

class _TrangWidgetState extends State<TrangWidget> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenChiTieu()),
        );
      }
    });
  }

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
