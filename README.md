# 🚀 OctaPoint CaaS - Đồ án Thiết kế Cơ sở dữ liệu

**OctaPoint CaaS** (Credit-as-a-Service) là hệ thống quản lý điểm thưởng và khách hàng thân thiết được thiết kế theo kiến trúc **Multi-tenant** (Đa khách thuê). Đồ án tập trung vào việc mô hình hóa dữ liệu, chuẩn hóa các ràng buộc nghiệp vụ và triển khai truy vấn trên hệ quản trị cơ sở dữ liệu **SQL Server**.

## 📌 Bối cảnh nghiệp vụ
Hệ thống được phân cấp chặt chẽ để phục vụ các chuỗi bán lẻ / tập đoàn lớn:
- **TENANT (Công ty/Tập đoàn):** Đơn vị cao nhất đăng ký sử dụng nền tảng (VD: Golden Gate, Vingroup).
- **MERCHANT (Cửa hàng/Chi nhánh):** Các cơ sở kinh doanh trực thuộc Tenant (VD: Kichi-Kichi Vincom, GoGi House).
- Khách hàng (Customer) và các chiến dịch khuyến mãi (Campaign), giao dịch tích điểm (Credit Transaction) được quản lý và cô lập dữ liệu theo từng Merchant, đảm bảo tính bảo mật và hiệu năng.
- Tích hợp phân hệ phân quyền **RBAC (Role-Based Access Control)** với thực thể `ROLE` và `USER` nhằm quản lý chặt chẽ quyền hạn nhân sự tại các cửa hàng.

## 🛠 Công nghệ sử dụng
- **Hệ quản trị CSDL:** SQL Server 2016+ (T-SQL)
- **Công cụ thiết kế ERD / Lược đồ:** TikZ trong LaTeX
- **Soạn thảo báo cáo:** LaTeX (Biên dịch bằng LaTeX Workshop trên VS Code)

## 📂 Cấu trúc thư mục báo cáo (LaTeX)
Dự án được tổ chức code LaTeX theo từng chương riêng biệt để dễ bảo trì:
- `main.tex`: File cấu hình gốc, gọi các module con và dùng để build ra `main.pdf`.
- `chuong1/`: Tổng quan dự án và yêu cầu bài toán.
- `chuong2/`: Mô hình quan niệm (Thực thể, Thuộc tính, Mối quan hệ).
- `chuong3/`: Mô hình Logic, Chuẩn hóa dữ liệu (BCNF) và Từ điển dữ liệu.
- `chuong4/`: Mô hình Vật lý, Mã lệnh DDL (chuẩn T-SQL) và các câu truy vấn mẫu trên SQL Server.

## 🚀 Hướng dẫn sử dụng
1. **Xem Báo cáo:** Biên dịch `main.tex` để xem báo cáo từ nguồn hiện tại. `main.pdf` có sẵn trên nhánh gốc là bản cũ, chưa phản ánh thay đổi trong đề xuất này.
2. **Triển khai Database:**
   - Cài đặt SQL Server và SQL Server Management Studio (SSMS).
   - Chạy `database/schema.sql` một lần trong cơ sở dữ liệu trống với schema mặc định `dbo`. Mục 4.4 nạp trực tiếp file này. Đây không phải script migration cho dữ liệu đang tồn tại.
   - Các câu truy vấn mẫu (Select, Join, Group By,...) có thể tìm thấy tại mục 4.6.

---
**Tác giả:** Lưu Minh Hoa

## Kiểm tra thay đổi
- Đọc [ghi chú rà soát](REVIEW.md) để xem phạm vi, quy ước và giới hạn.
- Chạy `python tests/check_consistency.py` để kiểm tra tĩnh cấu trúc và liên kết nguồn.
- Sau khi tạo schema trong **database thử nghiệm trống**, chạy `database/constraint_tests.sql` để kiểm tra dữ liệu hợp lệ và các ràng buộc từ chối dữ liệu sai. Dữ liệu thử được rollback.
- Biên dịch `pdflatex -interaction=nonstopmode -halt-on-error main.tex` hai lần từ thư mục gốc repo để cập nhật mục lục.
- File `SQL` ở thư mục gốc là bản ghi terminal cũ, không phải script khởi tạo CSDL.

### Tài liệu đối chiếu SQL Server
- [Chỉ mục duy nhất và giá trị NULL](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-index-transact-sql)
- [Chỉ mục có điều kiện](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/create-filtered-indexes)
- [Khóa chính, khóa ngoại và chỉ mục](https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints)
- [ISJSON](https://learn.microsoft.com/en-us/sql/t-sql/functions/isjson-transact-sql)
