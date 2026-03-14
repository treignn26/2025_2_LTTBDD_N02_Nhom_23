import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:btap_lon/model/chi_tieu_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:btap_lon/giao_dien/screen_chi_tieu.dart';
import 'package:btap_lon/giao_dien/screen_lich.dart';
import 'package:btap_lon/giao_dien/screen_bao_cao.dart';
import 'package:btap_lon/model/chi_tieu.dart';
import 'package:btap_lon/giao_dien/screen_thong_tin.dart';
import 'package:btap_lon/model/app_translations.dart';

class ScreenBaoCao extends StatefulWidget {
  const ScreenBaoCao({super.key});
  @override
  State<StatefulWidget> createState() => _ScreenBaoCaoState();
}

class _ScreenBaoCaoState extends State<ScreenBaoCao> {
  DateTime _viewData = DateTime.now();
  String _viewType = 'thang';
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChiTieuProvider>(context);

    final itemsThangNay = provider.itemsTheoThang(_viewData);
    final double tongChiThang = itemsThangNay.fold(
      0.0,
      (sum, item) => sum + item.soTien,
    );

    final uniqueCategories = itemsThangNay.map((e) => e.danhMuc).toSet();

    List<PieChartSectionData> pieSections = [];
    if (tongChiThang > 0) {
      pieSections = uniqueCategories.map((danhMuc) {
        final double tongDanhMuc = provider.tongTheoDanhMuc(danhMuc, _viewData);
        final double percentage = (tongDanhMuc / tongChiThang) * 100;

        final danhMucInfo = provider.danhMucs.firstWhere(
          (dm) => dm['name'] == danhMuc,
          orElse: () => {'color': Colors.grey},
        );

        return PieChartSectionData(
          value: percentage,
          color: danhMucInfo['color'] as Color,
          title: '${percentage.toStringAsFixed(0)}%\n$danhMuc',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 151, 194),
        title: DropdownButton<String>(
          value: _viewType,
          items: ['thang', 'nam'].map((key) {
            return DropdownMenuItem<String>(
              value: key,
              child: Text(AppTrans.getText(context, key)),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _viewType = val); // Cập nhật lại key
            }
          },
        ),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(
                      () => _viewData = DateTime(
                        _viewData.year,
                        _viewData.month - 1,
                      ),
                    );
                  },
                ),
                Text(
                  DateFormat('MM/yyyy').format(_viewData),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(
                      () => _viewData = DateTime(
                        _viewData.year,
                        _viewData.month + 1,
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Thay vì provider.totalExpense, mình dùng tongChiThang để chuẩn xác theo tháng
                _buildStatItem(
                  AppTrans.getText(context, 'chi_tieu'),
                  tongChiThang,
                  Colors.red,
                ),
                _buildStatItem(
                  AppTrans.getText(context, 'thu_nhap'),
                  0,
                  Colors.blue,
                ), // Tạm để 0 vì chưa có thu nhập
                _buildStatItem(
                  AppTrans.getText(context, 'thu_chi'),
                  -tongChiThang,
                  Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 200,
              child: itemsThangNay.isEmpty
                  ? Center(
                      child: Text(
                        AppTrans.getText(context, 'chua_co_chi_tieu_nao'),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        sections: pieSections,
                        centerSpaceRadius: 50,
                        sectionsSpace: 2, // Khoảng cách giữa các mảnh
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            if (uniqueCategories.isNotEmpty)
              ListView.builder(
                shrinkWrap:
                    true, // Rất quan trọng khi dùng trong SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Tắt cuộn của ListView để dùng cuộn của màn hình tổng
                itemCount: uniqueCategories.length,
                itemBuilder: (context, index) {
                  // Lấy tên danh mục (VD: Ăn uống)
                  final danhMuc = uniqueCategories.elementAt(index);

                  // Tính tổng tiền và phần trăm của danh mục này
                  final double tongDanhMuc = provider.tongTheoDanhMuc(
                    danhMuc,
                    _viewData,
                  );
                  final double percentage = (tongDanhMuc / tongChiThang) * 100;

                  // Lấy màu và icon
                  final danhMucInfo = provider.danhMucs.firstWhere(
                    (dm) => dm['name'] == danhMuc,
                    orElse: () => {
                      'icon': Icons.category,
                      'color': Colors.grey,
                    },
                  );

                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (danhMucInfo['color'] as Color).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        danhMucInfo['icon'] as IconData,
                        color: danhMucInfo['color'] as Color,
                      ),
                    ),
                    title: Text(
                      danhMuc,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${percentage.toStringAsFixed(1)}%',
                    ), // Hiện tỷ lệ phần trăm ở dưới
                    trailing: Text(
                      '-${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(tongDanhMuc)}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(2),
    );
  }

  Widget _buildStatItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(label),
        Text(
          '${value.toInt()}VND',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color.fromARGB(255, 98, 151, 194),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 2) return;
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScreenChiTieu()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ScreenLich()),
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
    );
  }
}

extension ChiTieuExtension on ChiTieuProvider {
  List<ChiTieu> itemsTheoThang(DateTime date) {
    return danhSach
        .where(
          (item) =>
              item.ngay.month == date.month && item.ngay.year == date.year,
        )
        .toList();
  }

  double tongTheoDanhMuc(String danhMuc, DateTime date) {
    return itemsTheoThang(date)
        .where((item) => item.danhMuc == danhMuc)
        .fold(0, (sum, item) => sum + item.soTien);
  }
}
