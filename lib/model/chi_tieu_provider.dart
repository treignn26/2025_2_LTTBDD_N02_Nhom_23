import 'package:flutter/material.dart';
import 'package:btap_lon/model/chi_tieu.dart';
import 'package:provider/provider.dart';

class ChiTieuProvider extends ChangeNotifier {
  final List<ChiTieu> _danhsachChiTieu = [];
  List<ChiTieu> get danhSach => _danhsachChiTieu;
  List<ChiTieu> get items => _danhsachChiTieu;

  void addChiTieu(ChiTieu item) {
    _danhsachChiTieu.add(item);
    notifyListeners();
  }

  double get tongChiThangNay {
    return _danhsachChiTieu.fold(0, (sum, item) => sum + item.soTien);
  }

  double getTongTheoLoai(String loai) {
    return _danhsachChiTieu
        .where((item) => item.danhMuc == loai)
        .fold(0, (sum, item) => sum + item.soTien);
  }

  double get totalIncome => 0;
  double get totalExpense {
    return _danhsachChiTieu.fold(0, (sum, item) => sum + item.soTien);
  }

  final List<Map<String, dynamic>> _danhMucs = [
    {'name': 'Ăn uống', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Giao hàng', 'icon': Icons.local_shipping, 'color': Colors.blue},
    {'name': 'Mua sắm', 'icon': Icons.shopping_cart, 'color': Colors.green},
    {'name': 'Giải trí', 'icon': Icons.movie, 'color': Colors.purple},
    {'name': 'Y tế', 'icon': Icons.local_hospital, 'color': Colors.red},
    {'name': 'Giáo dục', 'icon': Icons.school, 'color': Colors.indigo},
  ];
  List<Map<String, dynamic>> get danhMucs => _danhMucs;
  void themDanhMuc(String name, IconData icon, Color color) {
    _danhMucs.add({'name': name, 'icon': icon, 'color': color});
    notifyListeners();
  }
}
