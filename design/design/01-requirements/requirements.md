# OctaPoint - System Requirements

## 1. System Overview

OctaPoint là nền tảng Credit-as-a-Service (CaaS) hỗ trợ doanh nghiệp quản lý điểm thưởng và tín dụng khách hàng theo mô hình Multi-tenant.

Hệ thống được thiết kế nhằm hỗ trợ doanh nghiệp quản lý Merchant, Customer, Campaign, Credit và Transaction, đồng thời cung cấp khả năng tích hợp thông qua API, Developer SDK và MCP cho AI Agent.

Trong phạm vi đồ án, hệ thống tập trung vào phân tích và thiết kế. Các thành phần Blockchain, SDK và MCP được đặc tả ở mức thiết kế/prototype, không yêu cầu triển khai hệ thống production.

---

## 2. System Actors

### 2.1. Customer

Khách hàng sử dụng hệ thống điểm thưởng.

Chức năng chính:
- Đăng nhập.
- Xem số dư Credit.
- Xem lịch sử giao dịch.
- Nhận Credit từ Merchant.
- Sử dụng Credit để đổi ưu đãi.

### 2.2. Merchant Staff

Nhân viên cửa hàng thực hiện các nghiệp vụ điểm thưởng.

Chức năng chính:
- Tra cứu Customer.
- Kiểm tra số dư Credit.
- Cộng Credit cho Customer.
- Trừ/Redeem Credit.
- Xem lịch sử giao dịch.

### 2.3. Merchant Admin

Quản trị viên của Merchant.

Chức năng chính:
- Quản lý thông tin Merchant.
- Quản lý Customer.
- Quản lý Campaign.
- Cấu hình quy tắc Earn/Redeem.
- Quản lý API Key.
- Xem lịch sử giao dịch và báo cáo.

### 2.4. System Admin

Quản trị viên toàn bộ nền tảng OctaPoint.

Chức năng chính:
- Quản lý Tenant.
- Quản lý Merchant.
- Quản lý User và Role.
- Quản lý quyền truy cập.
- Theo dõi hoạt động hệ thống.
- Theo dõi giao dịch và audit log.

### 2.5. AI Agent

Tác nhân AI tương tác với OctaPoint thông qua MCP Server.

Chức năng chính:
- Tra cứu số dư Credit.
- Tra cứu lịch sử giao dịch.
- Tra cứu thông tin Campaign.
- Thực hiện các thao tác được hệ thống cho phép thông qua MCP.

---

## 3. External Systems

### 3.1. Sui Blockchain

Lưu trữ và thực thi các Credit Object và Smart Contract được thiết kế cho hệ thống.

### 3.2. Authentication Provider

Cung cấp cơ chế xác thực người dùng.

### 3.3. Payment Provider

Hỗ trợ thanh toán và quản lý subscription của Merchant.

---

## 4. Functional Requirements

### FR-01: Merchant Management

Hệ thống cho phép quản trị viên quản lý thông tin Merchant thuộc Tenant.

### FR-02: Customer Management

Hệ thống cho phép Merchant quản lý thông tin Customer.

### FR-03: Credit Management

Hệ thống cho phép Merchant Staff phát hành, kiểm tra và sử dụng Credit của Customer.

### FR-04: Campaign Management

Hệ thống cho phép Merchant Admin tạo và quản lý các Campaign điểm thưởng.

### FR-05: Transaction Management

Hệ thống lưu trữ và cung cấp lịch sử các giao dịch Credit.

### FR-06: Authentication and Authorization

Hệ thống hỗ trợ xác thực người dùng và phân quyền dựa trên Role.

### FR-07: Multi-tenant Management

Hệ thống đảm bảo dữ liệu của các Tenant và Merchant được phân tách.

### FR-08: API Integration

Hệ thống cung cấp API để Merchant và các ứng dụng bên ngoài tích hợp.

### FR-09: Developer SDK

Hệ thống cung cấp thiết kế SDK TypeScript nhằm hỗ trợ các ứng dụng Merchant thực hiện các thao tác Credit.

### FR-10: MCP Integration

Hệ thống cung cấp MCP Server để AI Agent có thể tương tác với các chức năng được hệ thống cho phép.

### FR-11: Audit and Transaction History

Hệ thống cung cấp lịch sử giao dịch và thông tin audit phục vụ kiểm tra và đối soát.

### FR-12: System Administration

System Admin có thể quản lý Tenant, Merchant, User, Role và theo dõi hoạt động của hệ thống.

---

## 5. Non-functional Requirements

### NFR-01: Security

Hệ thống phải đảm bảo xác thực, phân quyền và bảo vệ dữ liệu người dùng.

### NFR-02: Performance

Hệ thống được thiết kế để đáp ứng nhanh các thao tác phổ biến như kiểm tra số dư và thực hiện giao dịch Credit.

### NFR-03: Scalability

Kiến trúc hệ thống phải có khả năng mở rộng khi số lượng Tenant, Merchant và Customer tăng.

### NFR-04: Availability

Các thành phần chính của hệ thống được thiết kế nhằm đảm bảo khả năng hoạt động ổn định.

### NFR-05: Auditability

Các giao dịch quan trọng phải có thông tin lịch sử để phục vụ kiểm tra và đối soát.

### NFR-06: Maintainability

Hệ thống được thiết kế theo các module độc lập nhằm thuận tiện cho việc bảo trì và mở rộng.

---

## 6. System Scope

### In Scope

- Multi-tenant management.
- Merchant management.
- Customer management.
- Credit management.
- Campaign management.
- Credit transaction management.
- Role-based access control.
- Database design.
- API design.
- SDK design.
- MCP integration design.
- Blockchain integration design.
- UML system modeling.
- Merchant Portal design.
- Admin Portal design.

### Out of Scope

- Production deployment.
- Large-scale blockchain operation.
- Real-world financial credit scoring.
- Commercial security audit.
- Production-level AI model training.
- Full-scale performance benchmarking.
