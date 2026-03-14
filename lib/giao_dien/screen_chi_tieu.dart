import 'package:btap_lon/model/chi_tieu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:btap_lon/model/chi_tieu_provider.dart';
import 'package:btap_lon/giao_dien/screen_bao_cao.dart';
import 'package:btap_lon/giao_dien/screen_lich.dart';

class ScreenChiTieu extends StatefulWidget {
  const ScreenChiTieu({super.key});
  @override
  State<StatefulWidget> createState() => _ScreenChiTieuState();
}

class _ScreenChiTieuState extends State<ScreenChiTieu> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _ghiChuController = TextEditingController();
  final TextEditingController _soTienController = TextEditingController();
  String _selectedDanhMuc = 'Ăn uống';

  // List<Map<String, dynamic>> danhMucs = [
  //   {'name': 'Ăn uống', 'icon': Icons.restaurant, 'color': Colors.orange},
  //   {'name': 'Giao hàng', 'icon': Icons.local_shipping, 'color': Colors.blue},
  //   {'name': 'Mua sắm', 'icon': Icons.shopping_cart, 'color': Colors.green},
  //   {'name': 'Giải trí', 'icon': Icons.movie, 'color': Colors.purple},
  //   {'name': 'Y tế', 'icon': Icons.local_hospital, 'color': Colors.red},
  //   {'name': 'Giáo dục', 'icon': Icons.school, 'color': Colors.indigo},
  // ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập chi tiêu'),
        backgroundColor: const Color.fromARGB(255, 98, 151, 194),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color.fromARGB(255, 98, 151, 194),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),

            TextField(
              controller: _ghiChuController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                hintText: 'Chưa nhập vào',
              ),
            ),
            TextField(
              controller: _soTienController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tiền chi',
                suffixText: 'VNĐ',
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Danh mục'),
            ),
            Consumer<ChiTieuProvider>(
              builder: (context, provider, child) {
                final displayList = List.from(provider.danhMucs);
                displayList.add({
                  'name': 'Chỉnh sửa',
                  'icon': Icons.edit,
                  'color': Colors.grey,
                });

                return SizedBox(
                  height: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final isEditButton = index == displayList.length - 1;
                        final danhMuc = displayList[index];

                        return GestureDetector(
                          onTap: () {
                            if (isEditButton) {
                              print("Mở trang chỉnh sửa danh mục");
                            } else {
                              setState(
                                () => _selectedDanhMuc = danhMuc['name'],
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    (!isEditButton &&
                                        _selectedDanhMuc == danhMuc['name'])
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color:
                                  (!isEditButton &&
                                      _selectedDanhMuc == danhMuc['name'])
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  danhMuc['icon'],
                                  color: danhMuc['color'],
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  danhMuc['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isEditButton
                                        ? Colors.grey[700]
                                        : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                ChiTieu moi = ChiTieu(
                  ngay: _selectedDate,
                  ghiChu: _ghiChuController.text,
                  soTien: double.tryParse(_soTienController.text) ?? 0,
                  danhMuc: _selectedDanhMuc,
                  iconData: Icons.money,
                );
                print('Đã lưu: ${moi.soTien} cho ${moi.danhMuc}');
                Provider.of<ChiTieuProvider>(
                  context,
                  listen: false,
                ).addChiTieu(moi);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 98, 151, 194),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Nhập khoản chi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScreenLich()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ScreenBaoCao()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Nhập vào'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Báo cáo',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 98, 151, 194),
        //unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
