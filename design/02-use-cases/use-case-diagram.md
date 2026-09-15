# OctaPoint - Use Case Diagram

## 1. System Actors

Hệ thống OctaPoint gồm các tác nhân chính:

- Customer
- Merchant Staff
- Merchant Admin
- Platform Admin
- Developer
- AI Agent

## 2. Main Use Cases

### Customer
- Đăng nhập
- Xem số dư Credit
- Xem lịch sử giao dịch
- Đổi Credit
- Nhận Credit từ chương trình khuyến mãi

### Merchant Staff
- Kiểm tra số dư Customer
- Cộng Credit cho Customer
- Trừ Credit khi Customer đổi thưởng
- Xem lịch sử giao dịch

### Merchant Admin
- Quản lý Merchant
- Quản lý Customer
- Quản lý Campaign
- Cấu hình Earn/Redeem Rules
- Quản lý API Key
- Xem Audit Log
- Xem báo cáo

### Platform Admin
- Quản lý Tenant
- Quản lý User và Role
- Quản lý Merchant
- Giám sát hệ thống
- Xem Analytics
- Quản lý Billing

### Developer
- Tích hợp API
- Sử dụng TypeScript SDK
- Kiểm tra API Credentials
- Nhận Webhook

### AI Agent
- Kiểm tra Credit Balance
- Tra cứu Transaction History
- Kiểm tra thông tin Campaign
- Thực hiện các tác vụ được cấp quyền
