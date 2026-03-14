import 'package:btap_lon/model/chi_tieu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:btap_lon/model/chi_tieu_provider.dart';
import 'package:btap_lon/giao_dien/screen_bao_cao.dart';
import 'package:btap_lon/giao_dien/screen_lich.dart';
import 'package:btap_lon/giao_dien/screen_them_danh_muc.dart';
import 'package:btap_lon/giao_dien/screen_thong_tin.dart';
import 'package:btap_lon/model/app_translations.dart';

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
        title: Text(AppTrans.getText(context, 'nhap_chi_tieu')),
        backgroundColor: const Color.fromARGB(255, 98, 151, 194),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScreenThongTin()),
              );
            },
          ),
        ],
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
                '${AppTrans.getText(context, 'ngay')}: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),

            TextField(
              controller: _ghiChuController,
              decoration: InputDecoration(
                labelText: AppTrans.getText(context, 'ghi_chu'),
                hintText: AppTrans.getText(context, 'chua_nhap_vao'),
              ),
            ),
            TextField(
              controller: _soTienController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppTrans.getText(context, 'tien_chi'),
                suffixText: 'VNĐ',
              ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(AppTrans.getText(context, 'danh_muc_label')),
            ),

            Consumer<ChiTieuProvider>(
              builder: (context, provider, child) {
                final displayList = List.from(provider.danhMucs);
                displayList.add({
                  'name': 'chinh_sua_key',
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ScreenThemDanhMuc(),
                                ),
                              );
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
                                  AppTrans.getText(context, danhMuc['name']),
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
              child: Text(
                AppTrans.getText(context, 'nhap_khoan_chi_btn'),
                style: const TextStyle(color: Colors.white),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.edit),
            label: AppTrans.getText(context, 'nhap_vao'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: AppTrans.getText(context, 'lich'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.pie_chart),
            label: AppTrans.getText(context, 'bao_cao'),
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 98, 151, 194),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
