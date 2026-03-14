# 💰 Ứng dụng Quản lý Chi tiêu (Expense Tracker App)

Đây là dự án Bài Tập Lớn xây dựng một ứng dụng di động đa nền tảng bằng **Flutter**, giúp người dùng dễ dàng theo dõi, ghi chép và quản lý các khoản chi tiêu cá nhân hằng ngày một cách trực quan và hiệu quả.

---

## 👥 Thành viên nhóm phát triển

- **Đào Thu Trang** - MSSV: 23010630
- **Trần Thảo Vy** - MSSV: 23010588

---

## ✨ Các tính năng nổi bật

- **📝 Ghi chép chi tiêu nhanh chóng:** Nhập số tiền, ngày tháng, ghi chú và chọn danh mục chỉ trong vài thao tác.
- **🎨 Tùy chỉnh danh mục:** Cho phép người dùng tự do thêm mới danh mục chi tiêu với bộ sưu tập biểu tượng (icons) và màu sắc đa dạng.
- **📅 Quản lý theo Lịch:** Tích hợp bộ lịch trực quan giúp xem lại tổng quan lịch sử chi tiêu của từng ngày một cách dễ dàng.
- **📊 Báo cáo thống kê:** Hiển thị biểu đồ tròn (Pie Chart) sinh động, tổng hợp chi tiêu theo tháng, giúp người dùng nắm bắt được mình đang tiêu tiền vào đâu nhiều nhất.
- **🌐 Hỗ trợ Đa ngôn ngữ:** Tích hợp tính năng chuyển đổi ngôn ngữ linh hoạt giữa **Tiếng Việt** và **Tiếng Anh (English)** ngay trong ứng dụng mà không cần khởi động lại.

---

## 🛠 Công nghệ & Thư viện sử dụng

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Quản lý trạng thái (State Management):** `provider`
- **Xử lý ngày tháng:** `intl`
- **Giao diện Lịch:** `table_calendar`
- **Vẽ biểu đồ:** Tùy chỉnh nội bộ / thư viện biểu đồ.
- **Cấu trúc dữ liệu:** Xây dựng Provider riêng biệt cho Chi tiêu (`ChiTieuProvider`) và Ngôn ngữ (`AppTrans`).

---

## 📂 Cấu trúc thư mục chính (lib/)

- `giao_dien/`: Chứa toàn bộ các màn hình (UI) của ứng dụng như Màn hình nhập (`screen_chi_tieu`), Lịch (`screen_lich`), Báo cáo (`screen_bao_cao`), Cài đặt thông tin (`screen_thong_tin`), v.v.
- `model/`: Chứa các lớp định nghĩa đối tượng (`chi_tieu.dart`), logic xử lý state (`chi_tieu_provider.dart`), và từ điển đa ngôn ngữ (`app_translations.dart`).

---

## 🚀 Hướng dẫn cài đặt và chạy thử nghiệm

1. **Đảm bảo bạn đã cài đặt môi trường Flutter:** [Hướng dẫn cài đặt](https://docs.flutter.dev/get-started/install)
2. **Clone repository này về máy:**
   ```bash
   git clone <link-github-cua-ban>
   ```
