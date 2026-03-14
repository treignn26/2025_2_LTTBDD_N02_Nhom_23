import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btap_lon/model/chi_tieu_provider.dart';

class ScreenThemDanhMuc extends StatefulWidget {
  const ScreenThemDanhMuc({super.key});

  @override
  State<ScreenThemDanhMuc> createState() =>
      _ScreenThemDanhMucState();
}

class _ScreenThemDanhMucState extends State<ScreenThemDanhMuc> {
  final TextEditingController _tenController =
      TextEditingController();

  final List<IconData> _danhSachIcons = [
    Icons.fastfood,
    Icons.local_cafe,
    Icons.shopping_bag,
    Icons.directions_car,
    Icons.flight,
    Icons.home,
    Icons.pets,
    Icons.fitness_center,
    Icons.local_hospital,
    Icons.school,
    Icons.phone_android,
    Icons.videogame_asset,
    Icons.build,
    Icons.monetization_on,
    Icons.card_giftcard,
  ];

  final List<Color> _danhSachMau = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.brown,
    Colors.blueGrey,
  ];

  IconData _iconDuocChon = Icons.fastfood;
  Color _mauDuocChon = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm danh mục mới'),
        backgroundColor: const Color.fromARGB(255, 98, 151, 194),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tenController,
              decoration: const InputDecoration(
                labelText: 'Tên danh mục',
                hintText: 'VD: Tiền điện, Đi chơi...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Chọn màu sắc:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _danhSachMau.map((mau) {
                return GestureDetector(
                  onTap: () =>
                      setState(() => _mauDuocChon = mau),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: mau,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _mauDuocChon == mau
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),

            const Text(
              'Chọn biểu tượng:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: _danhSachIcons.map((icon) {
                return GestureDetector(
                  onTap: () =>
                      setState(() => _iconDuocChon = icon),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _iconDuocChon == icon
                          ? _mauDuocChon.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _iconDuocChon == icon
                            ? _mauDuocChon
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: _iconDuocChon == icon
                          ? _mauDuocChon
                          : Colors.grey,
                      size: 32,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    98,
                    151,
                    194,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_tenController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vui lòng nhập tên danh mục!',
                        ),
                      ),
                    );
                    return;
                  }

                  Provider.of<ChiTieuProvider>(
                    context,
                    listen: false,
                  ).themDanhMuc(
                    _tenController.text.trim(),
                    _iconDuocChon,
                    _mauDuocChon,
                  );

                  Navigator.pop(context);
                },
                child: const Text(
                  'Lưu danh mục',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
