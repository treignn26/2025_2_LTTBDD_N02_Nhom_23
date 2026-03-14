import 'package:flutter/material.dart';
import 'chi_tieu.dart';
import 'package:provider/provider.dart';

class ChiTieuProvider extends ChangeNotifier {
  final List<ChiTieu> _items = [];
  List<ChiTieu> get items => _items;
  List<ChiTieu> _danhSachChiTieu = [];

  List<ChiTieu> get danhSach => _danhSachChiTieu;

  void addChiTieu(ChiTieu item) {
    _danhSachChiTieu.add(item);
    notifyListeners();
  }

  double get tongChiThangNay {
    return _danhSachChiTieu.fold(
      0,
      (sum, item) => sum + item.soTien,
    );
  }

  double getTongTheoLoai(String loai) {
    return _items
        .where((item) => item.danhMuc == loai)
        .fold(0, (sum, item) => sum + item.soTien);
  }

  double get totalIncome => 0;
  double get totalExpense =>
      items.fold(0, (sum, item) => sum + item.soTien);
}
