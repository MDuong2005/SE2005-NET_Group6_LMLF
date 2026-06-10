# Khung Quản Lý Vòng Đời & Phân Phối Học Liệu (LMLF)

Hệ thống LMLF (Learning Material Lifecycle & Distribution Framework) là nền tảng cốt lõi của nhà trường dùng để cấu hình, soạn thảo, phê duyệt và phân phối đề cương chi tiết (Syllabus) cùng tài liệu học tập gốc. 

Hệ thống đóng vai trò là **"Nguồn sự thật duy nhất" (Single Source of Truth)**, giúp nhà trường kiểm soát chặt chẽ phiên bản tài liệu và đảm bảo tính đồng bộ dữ liệu toàn trường.

---

## 🚀 Các Tính Năng & Luồng Nghiệp Vụ Chính

### 1. Phân Hệ Quản Lý Vòng Đời & Phê Duyệt Đề Cương
* **Cấu hình khung chương trình (Curriculum Configuration):** Phòng Đào tạo (Academic Office) quản lý danh sách môn học, số tín chỉ và cấu hình các môn tiên quyết cho từng chuyên ngành.
* **Phân công vai trò (Role Assignment):** Phòng Đào tạo phân công giảng viên làm người soạn thảo (Syllabus Designer) hoặc người duyệt (Syllabus Reviewer) cho từng môn học theo kỳ.
* **Trạm soạn thảo tài liệu (Drafting Workstation):** Giảng viên soạn thảo tiến hành tải lên file PDF Syllabus và file ZIP Slide gốc, chọn loại thay đổi (Minor/Major) và nộp bài.
* **Luồng thẩm định & Phản hồi (Evaluation Workflow):** Giảng viên duyệt tiến hành tải gói tài liệu về kiểm tra, viết nhận xét ghi chú và bấm Duyệt (Approve) hoặc Từ chối (Reject).
* **Tự động kiểm soát phiên bản (Automated Version Control):** Khi được duyệt, hệ thống tự động tính toán để tăng số phiên bản (Ví dụ từ v1.1 lên v1.2 hoặc v2.0) dựa trên loại thay đổi đã chọn ban đầu.
* **Tự động lưu trữ lịch sử (Historical Archiving):** Gói tài liệu cũ đang hoạt động sẽ tự động bị khóa và đẩy vào kho lưu trữ lịch sử (Archive History Vault) để phục vụ công tác thanh tra sau này.

### 2. Phân Hệ Phân Phối Tài Liệu Song Song
* **Trung tâm tài liệu của Giảng viên (Lecturer Material Center):** Giảng viên đi dạy đăng nhập vào sẽ xem và tải Syllabus, Slide gốc **chỉ của những môn mình được phân công dạy trong kỳ**. Giảng viên có thể tải lên các bản slide tùy biến riêng của lớp mình để nhà trường lưu trữ hậu kiểm.
* **Cổng học tập của Sinh viên (Student Learning Portal):** Sinh viên và Cựu sinh viên có thể xem lộ trình học tập trực quan (Sơ đồ cây Learning Path), xem môn tiên quyết và tải Syllabus PDF cùng tài liệu hướng dẫn khung (Assignment/Lab Guide). Hệ thống ẩn hoàn toàn các file slide tùy biến riêng của giáo viên tại đây.

### 3. Phân Hệ Quản Trị Hệ Thống
* **Nhật ký giao dịch (System Transaction Logs):** Cho phép Quản trị viên (System Admin) xem lịch sử truy cập database, các lỗi chạy ngầm backend và cờ thực thi của luồng tự động tăng version để bảo mật hệ thống.

---

## 🛠️ Ranh Giới Hệ Thống & Quy Tắc Nghiệp Vụ Chí Mạng

* **BR-24 (Cô lập vai trò):** Một tài khoản không thể vừa làm người soạn thảo (Designer) vừa làm người duyệt (Reviewer) cho cùng một môn học trong cùng một học kỳ.
* **BR-99 (Cô lập dữ liệu):** Cổng sinh viên chỉ hiển thị tài liệu khung chuẩn hóa đã xuất bản của trường. Các file slide sửa đổi riêng do giảng viên upload lên để backup hậu kiểm sẽ bị ẩn hoàn toàn với sinh viên trên LMLF. Sinh viên muốn lấy slide của lớp mình phải lên hệ thống quản lý lớp học bên ngoài (CMS/EduNext).

---

## 💻 Công Nghệ Sử Dụng & Kiến Trúc

* **Backend:** Java (Servlet, JSP, JSTL)
* **Frontend:** HTML, CSS, JavaScript
* **Database:** SQL Server (Quản lý ma trận môn học, tài khoản, log hệ thống và đường dẫn file)
* **Kiến trúc:** Mô hình MVC (Model-View-Controller) phân rã rạch ròi giữa phân hệ xử lý dữ liệu động (Luồng phê duyệt) và phân hệ khai thác dữ liệu tĩnh (Cổng phân phối cho sinh viên/giảng viên).

---

## 🛑 Các Chức Năng Tự Động Chạy Ngầm Ở Backend (Non-UI Services)

1. `CalculateNextVersionNumber`: Chạy tự động ngay khi Reviewer bấm duyệt bài; đọc loại thay đổi của Designer để tự động tính toán cộng chuỗi version mới (v1.x lên v1.x+1 hoặc v2.0).
2. `ArchiveSupersededSyllabus`: Tự động sao chép gói dữ liệu cũ, đóng dấu đóng băng trạng thái (Read-only) và cất vào kho Archive Vault trước khi phiên bản mới được kích hoạt live.
3. `SyncFacultyTeachingAssignments`: Hệ thống tự động đồng bộ dữ liệu phân công lịch dạy từ hệ thống FAP của trường theo định kỳ để cập nhật danh sách môn học hiển thị cho từng giảng viên.
4. `TriggerWorkflowEmailAlerts`: Dịch vụ lắng nghe trạng thái của đề cương, tự động bắn email thông báo cho Reviewer khi có bài mới cần chấm, và thông báo cho Designer khi bài bị từ chối hoặc được thông qua.
