import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:btap_lon/model/chi_tieu_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:btap_lon/giao_dien/screen_chi_tieu.dart';
import 'package:btap_lon/giao_dien/screen_lich.dart';

class ScreenBaoCao extends StatefulWidget {
  const ScreenBaoCao({super.key});
  @override
  State<StatefulWidget> createState() => _ScreenBaoCaoState();
}

class _ScreenBaoCaoState extends State<ScreenBaoCao> {
  DateTime _viewData = DateTime.now();
  String _viewType = 'Tháng';
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChiTieuProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 151, 194),
        title: DropdownButton<String>(
          value: _viewType,
          items: ['Tháng', 'Năm']
              .map(
                (e) =>
                    DropdownMenuItem(value: e, child: Text(e)),
              )
              .toList(),
          onChanged: (val) {
            setState(() => _viewType = val!);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              //Timf kiesme
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
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(
                      () => _viewData = DateTime(
                        _viewData.year,
                        _viewData.month - 1,
                      ),
                    );
                  },
                ),
                Text(DateFormat('MM/yyyy').format(_viewData)),
                IconButton(
                  icon: Icon(Icons.chevron_right),
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
                _buildStatItem(
                  'Chi tiêu',
                  provider.totalExpense,
                  Colors.red,
                ),
                _buildStatItem('Thu nhập', 0, Colors.blue),
                _buildStatItem(
                  'Thu chi',
                  -provider.totalExpense,
                  Colors.black,
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.orange,
                      title: 'Ăn uống',
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.blue,
                      title: 'Xăng xe',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  _buildTransactionItem(
                    'Ăn uống',
                    'Phở bòo',
                    '-35.000',
                    Icons.restaurant,
                    Colors.orange,
                  ),
                  _buildTransactionItem(
                    'Xăng xe',
                    'Đổ xăng',
                    '-500.000',
                    Icons.gas_meter,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(2),
    );
  }

  Widget _buildStatItem(
    String label,
    double value,
    Color color,
  ) {
    return Column(
      children: [
        Text(label),
        Text(
          '${value.toInt()}VND',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 2) return;
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScreenChiTieu(),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ScreenLich(),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          label: 'Nhập vào',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Lịch',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Báo cáo',
        ),
      ],
    );
  }
}
