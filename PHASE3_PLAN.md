# 📘 Phase 3 Plan — Lịch học & Nhắc nhở

## 🎯 Mục tiêu
- Thêm lịch học/thi trong `Course`
- Local push notifications nhắc lịch
- Link học online (Zoom/Meet) + mở app + chia sẻ

## 📋 Backlog chi tiết
1) Lịch học & thi
- Model: `classSchedules[]`, `examSchedules[]` trong `Course` (date, time, location/online)
- UI: Form thêm/sửa/xóa lịch trong Course Detail và Planning
- Hiển thị lịch sắp tới (Next up) trên Dashboard/Planning

2) Notifications
- Nhắc trước X phút (config per schedule)
- Bật/tắt theo từng schedule và Course
- Snooze/cancel

3) Link học online
- Trường `onlineLink` trong `Course`
- Mở với `url_launcher` (Zoom/Meet)
- Chia sẻ qua `share_plus`

## 🛠️ Công nghệ
- flutter_local_notifications, timezone
- url_launcher, share_plus

## 📊 Deliverables
- Course Detail có lịch học/thi + link online
- Notifications hoạt động iOS/Android
- UI quản lý lịch trong Planning

## ⏱️ Timeline (3-4 tuần)
- Tuần 1: Model + UI nhập lịch
- Tuần 2: Notifications + timezone
- Tuần 3-4: Link online + tích hợp Planning + kiểm thử
