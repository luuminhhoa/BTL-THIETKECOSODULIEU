# Đề xuất đồng bộ báo cáo và SQL Server

## Thay đổi
- Thống nhất SQL Server 2016+ / T-SQL; dùng NVARCHAR cho tên Unicode, NVARCHAR(MAX) + ISJSON cho cấu hình.
- Đưa nguồn DDL vào database/schema.sql và nạp trực tiếp vào mục 4.4.
- Khôi phục ManagerID và FK tự tham chiếu; bổ sung ROLE và quan hệ quản lý vào sơ đồ logic.
- Campaign.EndDate nullable và không trước StartDate.
- Bổ sung UNIQUE ApiKey, cặp CustomerID/MerchantID; chỉ mục duy nhất có điều kiện cho WalletAddress và SuiTxDigest.
- CHECK số dư không âm, hệ số dương, trạng thái và biến động có dấu.
- Thống nhất Campaign Draft/Active/Expired, Merchant Active/Suspended, giao dịch Earn/Redeem/Refund.
- Triển khai chỉ mục FK, bổ sung đầy đủ từ điển dữ liệu cho cả 10 bảng.
- Sửa phân tích khóa ứng viên/BCNF; CreditTransaction có khóa riêng nên không phải thực thể yếu.
- Truy vấn cộng điểm lọc Earn; truy vấn tháng dùng khoảng nửa kín. Loại bỏ khẳng định chắc chắn về thuật toán join và hiệu năng.

## Quy ước cần nhóm đọc khi review
- Giữ Amount có dấu theo mô hình hiện tại: Earn dương, Redeem âm; Refund khác 0, đảo dấu biến động được hoàn. DDL chưa đối chiếu giao dịch gốc.
- Một ví cho mỗi cặp khách hàng/cửa hàng; một vai trò cho mỗi User; Email User duy nhất toàn hệ thống.
- Một digest tương ứng tối đa một giao dịch nội bộ, duy nhất khi đã có giá trị. Nhiều giao dịch chưa có digest được phép NULL.
- ActionType là mã mở rộng, không đặt CHECK danh sách đóng chỉ từ các ví dụ.
- FK không tự bảo đảm cùng Merchant, chống chu trình quản lý hay phân quyền truy cập.
- Bất biến nội dung nghiệp vụ, cập nhật số dư nguyên tử và đồng bộ Sui là yêu cầu chưa triển khai trong DDL. Việc bổ sung digest sau đồng bộ cần luồng quyền riêng.
- Các bảng Permission/AuditLog/FraudEvent/billing chỉ thuộc phạm vi mở rộng.

## Kiểm tra
- Đã chạy thành công tests/check_consistency.py: 10 bảng, tham chiếu FK/chỉ mục, định danh nullable và 24 nguồn TeX. git diff --check không báo lỗi.
- Có 20 ca từ chối dữ liệu sai trong database/constraint_tests.sql, cùng các ca hợp lệ cho nhiều NULL, ngày kết thúc trống/bằng ngày bắt đầu và các dấu giao dịch.
- Môi trường hiện tại chưa có SQL Server hoạt động và chưa có pdflatex. Chưa chạy các ca T-SQL, chưa biên dịch/kiểm tra bố cục PDF. Không coi kiểm tra tĩnh là kiểm thử thực thi.
- main.pdf trong repo là bản cũ. Cần biên dịch lại từ main.tex trước khi nộp; không thay bằng PDF chưa xác minh.
- Chỉ đề xuất trên nhánh riêng, không merge vào main.
