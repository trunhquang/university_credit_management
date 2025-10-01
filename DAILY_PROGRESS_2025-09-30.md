# Daily Progress – 2025-09-30

## Hôm nay đã làm

### GPA (2.1)
- Tạo `GPAService` và nâng cấp `GPAPage` (nhập GPA mục tiêu, dự đoán theo mục tiêu).
- Thêm gợi ý theo xếp loại (Xuất sắc/Giỏi/Khá/Trung bình).
- Lưu lịch sử GPA (`GPAHistoryService`) và hiển thị lịch sử + line chart (fl_chart).

### Planning (2.2)
- Thêm models/service: `SemesterPlan`, `PlannedCourseRef`, `PlanningService` (lưu SharedPreferences).
- `PlanningPage`:
  - Tạo/xóa học kỳ; thêm/xóa môn; tổng tín chỉ; padding tránh FAB che nội dung.
  - Ràng buộc tín chỉ/học kỳ + cảnh báo prerequisites; gợi ý môn theo prerequisites.
  - Ghi chú/lịch học (edit dialog); timeline text view cho schedule.
  - Popup chọn môn: search, loại trừ môn đã chọn/đã đủ nhóm, hiển thị BB/TC, nhóm, còn cần (BB/TC).
  - Bổ sung logic nhóm:
    - Tính `BB còn`, `TC còn` (chỉ tính phần chưa bắt đầu học), theo dõi riêng `Đang học: X TC` (progReq/progOpt).
    - Hiển thị “Đang học: X TC” trong danh sách đã chọn và trong “Tóm tắt theo nhóm”.
    - “Tóm tắt theo nhóm” thu gọn bằng ExpansionTile tổng; click badge BB/TC để mở picker đúng tiêu chí nhóm.

### Thông báo & UI
- Tạo `NotificationService` và refactor SnackBar/Dialog tại GPA/Planning/Settings/Course Detail dùng service tập trung.
- Sửa overflow và tối ưu bố cục (Wrap thay Row, padding, ẩn divider ExpansionTile, di chuyển nút “Thêm môn” lên trên khu Gợi ý).

### Kiểm thử & Chất lượng
- Unit tests: GPA (tính, dự đoán) và ProgressModel (tín chỉ, thống kê).
- Lint sạch sau các thay đổi.

## Kế hoạch ngày mai (tiếp tục Phase 2)

1) Dashboard nâng cao (2.3)
- Progress timeline + analytics theo khối; Section progress chi tiết; widget “Môn sắp tới”.

2) Graduation checklist (2.4)
- Trang checklist điều kiện tốt nghiệp; cảnh báo phần còn thiếu; liên kết với số TC còn thiếu theo nhóm.

3) Polish & Tests
- Bổ sung widget/integration tests cho luồng GPA/Planning.
- Hoàn thiện i18n cho `NotificationService`/messages.
- Tối ưu hiệu năng tính toán nhóm (ghi nhớ/memo nhỏ khi cần).

4) Dọn dẹp & Docs
- Cập nhật `PROJECT_BLUEPRINT.md` (đánh dấu xong 2.1, phần lớn 2.2).
- Viết README ngắn cho `NotificationService` và hướng dẫn mở rộng.

## Ghi chú
- Bộ lọc chọn môn đã loại trừ: môn đã chọn, nhóm đã đủ BB/TC tương ứng, và các môn đang học.
- Tóm tắt theo nhóm nay gọn, không che nội dung chính; vẫn hỗ trợ thêm nhanh theo nhóm/loại.

