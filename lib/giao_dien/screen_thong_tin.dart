import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btap_lon/model/language_provider.dart';
import 'package:btap_lon/model/app_translations.dart';

class ScreenThongTin extends StatelessWidget {
  const ScreenThongTin({super.key});

  @override
  Widget build(BuildContext context) {
    var langProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 151, 194),
        title: Text(AppTrans.getText(context, 'thong_tin')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTrans.getText(context, 'thanh_vien_nhom'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildThanhVien(
                    'Đào Thu Trang',
                    'Thành viên - MSSV: 23010630',
                    Icons.person,
                    const Color.fromARGB(255, 134, 185, 227),
                  ),
                  const Divider(height: 1),
                  _buildThanhVien(
                    'Trần Thảo Vy',
                    'Thành viên - MSSV: 23010588',
                    Icons.person,
                    const Color.fromARGB(255, 134, 185, 227),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Text(
              AppTrans.getText(context, 'ngon_ngu'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        const Text('🇻🇳 ', style: TextStyle(fontSize: 20)),
                        Text(AppTrans.getText(context, 'tieng_viet')),
                      ],
                    ),
                    value: 'vi',
                    groupValue: langProvider.locale.languageCode,
                    activeColor: const Color.fromARGB(255, 98, 151, 194),
                    onChanged: (value) {
                      if (value != null) langProvider.changeLanguage(value);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        const Text('🇺🇸 ', style: TextStyle(fontSize: 20)),
                        Text(AppTrans.getText(context, 'tieng_anh')),
                      ],
                    ),
                    value: 'en',
                    groupValue: langProvider.locale.languageCode,
                    activeColor: const Color.fromARGB(255, 98, 151, 194),
                    onChanged: (value) {
                      if (value != null) langProvider.changeLanguage(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThanhVien(
    String ten,
    String chucVu,
    IconData icon,
    Color iconColor,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(ten, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(chucVu),
    );
  }
}
