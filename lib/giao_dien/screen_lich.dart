import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btap_lon/model/chi_tieu_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:btap_lon/giao_dien/screen_chi_tieu.dart';
import 'package:btap_lon/giao_dien/screen_bao_cao.dart';
import 'package:btap_lon/giao_dien/screen_thong_tin.dart';
import 'package:btap_lon/model/app_translations.dart';

class ScreenLich extends StatefulWidget {
  const ScreenLich({super.key});

  @override
  State<ScreenLich> createState() => _ScreenLichState();
}

class _ScreenLichState extends State<ScreenLich> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 151, 194),
        title: Text(AppTrans.getText(context, 'so_thu_chi')),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(3000, 12, 31),
            focusedDay: _focusedDay,

            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 98, 151, 194),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 98, 151, 194),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                return null;
              },
            ),
          ),
          const Divider(thickness: 1, height: 1),
          Expanded(
            child: Consumer<ChiTieuProvider>(
              builder: (context, provider, child) {
                final itemsTheoNgay = provider.danhSach.where((item) {
                  return isSameDay(item.ngay, _selectedDay);
                }).toList();

                final tongChiNgay = itemsTheoNgay.fold(
                  0.0,
                  (sum, item) => sum + item.soTien,
                );

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                AppTrans.getText(context, 'tong_hien_co'),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const Text(
                                '0 VND',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                AppTrans.getText(context, 'tong_chi'),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'VND',
                                ).format(tongChiNgay),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 1),

                    Expanded(
                      child: itemsTheoNgay.isEmpty
                          ? Center(
                              child: Text(
                                AppTrans.getText(
                                  context,
                                  'khong_co_chi_tieu_nao',
                                ),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: itemsTheoNgay.length,
                              itemBuilder: (context, index) {
                                final item = itemsTheoNgay[index];
                                final danhMucInfo = provider.danhMucs
                                    .firstWhere(
                                      (dm) => dm['name'] == item.danhMuc,
                                      orElse: () => {
                                        'icon': Icons.category,
                                        'color': Colors.grey,
                                      },
                                    );
                                return ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: (danhMucInfo['color'] as Color)
                                          .withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      danhMucInfo['icon'] as IconData,
                                      color: danhMucInfo['color'] as Color,
                                    ),
                                  ),
                                  title: Text(
                                    AppTrans.getText(context, item.danhMuc),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.ghiChu.isEmpty
                                        ? AppTrans.getText(
                                            context,
                                            'khong_co_ghi_chu',
                                          )
                                        : item.ghiChu,
                                  ),
                                  trailing: Text(
                                    '-${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(item.soTien)}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color.fromARGB(255, 98, 151, 194),
        onTap: (index) {
          if (index == 1) return;
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScreenChiTieu()),
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
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount, Color color) {
    return Column(
      children: [
        Text(
          AppTrans.getText(context, title),
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          "$amount VND",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String subtitle,
    String amount,
    IconData icon,
    Color iconColor,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(AppTrans.getText(context, title)),
      subtitle: Text(AppTrans.getText(context, subtitle)),
      trailing: Text(
        "$amount VND",
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
