# 🚀 OctaPoint CaaS - Đồ án Thiết kế Cơ sở dữ liệu

**OctaPoint CaaS** (Credit-as-a-Service) là hệ thống quản lý điểm thưởng và khách hàng thân thiết được thiết kế theo kiến trúc **Multi-tenant** (Đa khách thuê). Đồ án tập trung vào việc mô hình hóa dữ liệu, chuẩn hóa các ràng buộc nghiệp vụ và triển khai truy vấn trên hệ quản trị cơ sở dữ liệu **SQL Server**.

## 📌 Bối cảnh nghiệp vụ
Hệ thống được phân cấp chặt chẽ để phục vụ các chuỗi bán lẻ / tập đoàn lớn:
- **TENANT (Công ty/Tập đoàn):** Đơn vị cao nhất đăng ký sử dụng nền tảng (VD: Golden Gate, Vingroup).
- **MERCHANT (Cửa hàng/Chi nhánh):** Các cơ sở kinh doanh trực thuộc Tenant (VD: Kichi-Kichi Vincom, GoGi House).
- Khách hàng (Customer) và các chiến dịch khuyến mãi (Campaign), giao dịch tích điểm (Credit Transaction) được quản lý và cô lập dữ liệu theo từng Merchant, đảm bảo tính bảo mật và hiệu năng.
- Tích hợp phân hệ phân quyền **RBAC (Role-Based Access Control)** với thực thể `ROLE` và `USER` nhằm quản lý chặt chẽ quyền hạn nhân sự tại các cửa hàng.

## 🛠 Công nghệ sử dụng
- **Hệ quản trị CSDL:** SQL Server (T-SQL)
- **Công cụ thiết kế ERD / Lược đồ:** (Các công cụ bạn đã dùng, ví dụ: draw.io, Visio,...)
- **Soạn thảo báo cáo:** LaTeX (Biên dịch bằng LaTeX Workshop trên VS Code)

## 📂 Cấu trúc thư mục báo cáo (LaTeX)
Dự án được tổ chức code LaTeX theo từng chương riêng biệt để dễ bảo trì:
- `main.tex`: File cấu hình gốc, gọi các module con và dùng để build ra `main.pdf`.
- `chuong1/`: Tổng quan dự án và yêu cầu bài toán.
- `chuong2/`: Mô hình quan niệm (Thực thể, Thuộc tính, Mối quan hệ).
- `chuong3/`: Mô hình Logic, Chuẩn hóa dữ liệu (BCNF) và Từ điển dữ liệu.
- `chuong4/`: Mô hình Vật lý, Mã lệnh DDL (chuẩn T-SQL) và các câu truy vấn mẫu trên SQL Server.

## 🚀 Hướng dẫn sử dụng
1. **Xem Báo cáo:** Mở file `main.pdf` để xem toàn bộ tài liệu thiết kế hệ thống.
2. **Triển khai Database:**
   - Cài đặt SQL Server và SQL Server Management Studio (SSMS) / Azure Data Studio.
   - Copy đoạn mã DDL tại mục 4.4 (`chuong4/4.4_ma_lenh_tao_bang.tex`) và chạy trên SSMS để khởi tạo Schema.
   - Các câu truy vấn mẫu (Select, Join, Group By,...) có thể tìm thấy tại mục 4.6.

---
**Tác giả:** Lưu Minh Hoa