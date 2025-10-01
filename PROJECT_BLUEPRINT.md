# 📋 Blueprint Phát triển Dự án Grad Tracker

## 🎯 Tổng quan dự án
Ứng dụng theo dõi tiến độ học tập cho sinh viên đại học với chương trình 138 tín chỉ, hỗ trợ quản lý học phần, tính toán GPA và lập kế hoạch học tập.

## 📊 Phân tích yêu cầu từ app.md

### 🔍 Các tính năng chính:
1. **Dashboard** - Trang tổng quan tiến độ
2. **Theo dõi học phần** - Quản lý môn học và điểm số
3. **Tiến độ khối kiến thức** - Theo dõi từng khối học
4. **Kế hoạch học tập** - Lập kế hoạch cá nhân
5. **Checklist tốt nghiệp** - Kiểm tra điều kiện tốt nghiệp
6. **Thông tin chi tiết học phần** - Chi tiết môn học
7. **Theo dõi GPA** - Tính toán và dự đoán điểm

---

## 🚀 BLUEPRINT 4 GIAI ĐOẠN

---

## 📱 GIAI ĐOẠN 1: CORE FEATURES (4-6 tuần)
*Mục tiêu: Xây dựng nền tảng cơ bản và các tính năng cốt lõi*

### 🎯 Mục tiêu chính
- Tạo ứng dụng hoạt động cơ bản
- Hiển thị dữ liệu chương trình học
- Quản lý tiến độ học tập cơ bản

### 📋 Tính năng cần phát triển

#### 1.1 **Dashboard Cơ bản**
- [ ] Hiển thị tổng số tín chỉ đã tích lũy / 138 tín chỉ
- [ ] Progress bar hoặc biểu đồ tròn đơn giản
- [ ] Tóm tắt 4 khối kiến thức chính
- [ ] Thống kê cơ bản (số môn đã học, đang học, chưa học)

#### 1.2 **Danh sách học phần**
- [ ] Hiển thị tất cả môn học theo khối kiến thức
- [ ] Phân loại môn bắt buộc (BB) và tự chọn (TC)
- [ ] Trạng thái môn học (chưa học, đang học, đã hoàn thành)
- [ ] Tìm kiếm và lọc môn học cơ bản

#### 1.3 **Quản lý tiến độ cơ bản**
- [ ] Đánh dấu môn học đã hoàn thành
- [ ] Nhập điểm số cho môn đã hoàn thành
- [ ] Tính toán tự động số tín chỉ đã tích lũy
- [ ] Hiển thị tiến độ từng khối kiến thức

#### 1.4 **Thông tin chi tiết môn học**
- [ ] Màn hình chi tiết môn học
- [ ] Hiển thị mã môn, tên, số tín chỉ, loại môn
- [ ] Chỉnh sửa trạng thái và điểm số

### 🛠️ Công nghệ & Kiến trúc
- **State Management**: Provider/Riverpod
- **UI Framework**: Flutter Material Design
- **Data Storage**: SharedPreferences (local)
- **Charts**: fl_chart package
- **Navigation**: GoRouter

### 📊 Deliverables
- [ ] Ứng dụng Flutter cơ bản
- [ ] 4 màn hình chính: Dashboard, Danh sách môn, Chi tiết môn, Cài đặt
- [ ] Dữ liệu mẫu hoạt động
- [ ] Navigation cơ bản

---

## 🎨 GIAI ĐOẠN 2: ADVANCED FEATURES (6-8 tuần)
*Mục tiêu: Phát triển các tính năng nâng cao và tối ưu trải nghiệm*

### 🎯 Mục tiêu chính
- Tính toán GPA và dự đoán điểm
- Kế hoạch học tập thông minh
- Giao diện đẹp và trải nghiệm tốt

### 📋 Tính năng cần phát triển

#### 2.1 **Tính toán GPA nâng cao**
- [ ] Tính GPA theo thang điểm 4.0
- [ ] Dự đoán điểm cần đạt để đạt mức GPA mong muốn
- [ ] Gợi ý điểm cho các môn còn lại (Xuất sắc, Giỏi, Khá)
- [ ] Biểu đồ xu hướng GPA theo thời gian
- [ ] So sánh GPA với các mức xếp loại

#### 2.2 **Kế hoạch học tập thông minh**
- [ ] Lập kế hoạch học tập theo học kỳ
- [ ] Tùy chỉnh kế hoạch cá nhân
- [ ] Cảnh báo khi kế hoạch ảnh hưởng tiến độ tốt nghiệp
- [ ] Gợi ý môn học nên học trong học kỳ tiếp theo
- [ ] Quản lý lịch học dự kiến

#### 2.3 **Dashboard nâng cao**
- [ ] Biểu đồ chi tiết tiến độ từng khối kiến thức
- [ ] Thống kê điểm số theo khối học
- [ ] Timeline tiến độ học tập
- [ ] Widget hiển thị môn học sắp tới
- [ ] Thông báo và nhắc nhở

#### 2.4 **Checklist tốt nghiệp**
- [ ] Danh sách điều kiện tốt nghiệp
- [ ] Theo dõi chuẩn ngoại ngữ
- [ ] Quản lý chứng chỉ và giấy tờ
- [ ] Cảnh báo điều kiện còn thiếu
- [ ] Timeline chuẩn bị tốt nghiệp

#### 2.5 **Tối ưu giao diện**
- [ ] Dark/Light theme
- [ ] Animation và transition mượt mà
- [ ] Responsive design
- [ ] Accessibility features
- [ ] Custom icons và illustrations

### 🛠️ Công nghệ bổ sung
- **Charts**: fl_chart với animations
- **Animations**: Flutter animations
- **Local Database**: SQLite/Hive
- **Notifications**: Local notifications
- **File Management**: File picker cho chứng chỉ

### 📊 Deliverables
- [ ] Tính năng GPA hoàn chỉnh
- [ ] Kế hoạch học tập thông minh
- [ ] Giao diện đẹp và responsive
- [ ] Checklist tốt nghiệp
- [ ] Hệ thống thông báo

---

## 🌟 GIAI ĐOẠN 3: LỊCH HỌC & NHẮC NHỞ (3-4 tuần)
*Mục tiêu: Bổ sung lịch thi/lịch học cho môn, nhắc nhở cục bộ, link học online*

### 🎯 Mục tiêu chính
- Lịch thi/lịch học trong mỗi `Course`
- Local push notifications nhắc lịch
- Link học online (Zoom/Meet) + mở app + chia sẻ

### 📋 Tính năng cần phát triển

#### 3.1 **Lịch học & lịch thi trong Course**
- [ ] Thêm trường `classSchedules[]` và `examSchedules[]` cho `Course`
- [ ] UI nhập/sửa/xóa lịch (ngày, giờ, địa điểm/online)
- [ ] Hiển thị lịch sắp tới trên Course Detail và Planning

#### 3.2 **Local notifications**
- [ ] Nhắc nhở trước giờ học/thi (config phút trước)
- [ ] Bật/tắt theo từng lịch, theo từng Course
- [ ] Cho phép snooze/cancel

#### 3.3 **Link học online**
- [ ] Trường `onlineLink` trong `Course`
- [ ] Mở link qua app (Zoom/Meet) bằng `url_launcher`
- [ ] Chia sẻ link qua ShareSheet

### 🛠️ Công nghệ
- `flutter_local_notifications`, `timezone`
- `url_launcher`, `share_plus`

### 📊 Deliverables
- [ ] Course Detail có lịch học/thi + link online
- [ ] Notifications hoạt động nền tảng iOS/Android
- [ ] UI quản lý lịch trong Planning

### 📊 Deliverables
- [ ] Ứng dụng hoàn chỉnh và ổn định
- [ ] Test coverage > 80%
- [ ] Performance optimization
- [ ] App store ready
- [ ] Documentation đầy đủ

---

## 🌟 GIAI ĐOẠN 4: MULTI-PROGRAM & EDITOR (3-4 tuần)
*Mục tiêu: Một user có thể học nhiều chuyên ngành; CRUD Section/CourseGroup/Course*

### 🎯 Mục tiêu chính
- Hỗ trợ nhiều `Program` (chuyên ngành/chương trình)
- CRUD cấu trúc chương trình: `Section`, `CourseGroup`, `Course`

### 📋 Tính năng cần phát triển

#### 4.1 **Multi-Program**
- [ ] Model `Program` (id, name, totalCredits, outcomes)
- [ ] Cho phép chọn/chuyển `Program` đang hoạt động
- [ ] Lưu dữ liệu riêng theo `Program`

#### 4.2 **Curriculum Editor**
- [ ] Thêm/Sửa/Xóa `Section`
- [ ] Thêm/Sửa/Xóa `CourseGroup`
- [ ] Thêm/Sửa/Xóa `Course`
- [ ] Ràng buộc: tổng tín chỉ, tiên quyết, loại môn

### 🛠️ Công nghệ
- Reusable forms, validation
- Export/Import JSON để chia sẻ curriculum

### 📊 Deliverables
- [ ] Quản lý nhiều chương trình
- [ ] Trình chỉnh sửa curriculum đầy đủ

---

## 🌟 GIAI ĐOẠN 5: CHUẨN BỊ PHÁT HÀNH V1 (2-3 tuần)
*Mục tiêu: Sẵn sàng phát hành v1 lên App Store/Google Play*

### 🎯 Mục tiêu chính
- Thiết lập auto test (unit/integration cơ bản)
- Chuẩn bị icon, splash, screenshots, metadata
- Thiết lập CI/CD build & signing, beta distribution (TestFlight/Play Console)
- Tối thiểu hóa crash/ANR, bật Crashlytics/Analytics

### 📋 Hạng mục công việc
- [ ] Unit tests & widget/integration tests cho flows chính
- [ ] App icon, splash, screenshots đa nền tảng
- [ ] App Store/Play metadata: mô tả, từ khóa, privacy, age rating
- [ ] CI/CD: build, code signing, upload (GitHub Actions)
- [ ] Thiết lập Firebase Crashlytics/Analytics (tối thiểu)
- [ ] Release checklist: versioning, changelog, QA smoke tests

### 📊 Deliverables
- [ ] Bản build v1 sẵn sàng submit store
- [ ] Test cơ bản pass, CI/CD chạy ổn định
- [ ] Tài liệu phát hành (release notes, hướng dẫn)

---

## 🌟 GIAI ĐOẠN 6: NÂNG CAO (V2)
*Mục tiêu: Tập trung các tính năng nâng cao, sẽ phát hành ở v2*

### 6.1 **Tính năng nâng cao**
- [ ] Export/Import dữ liệu (JSON, CSV)
- [ ] Backup và restore dữ liệu
- [ ] Chia sẻ tiến độ học tập
- [ ] Tích hợp lịch học từ hệ thống trường
- [ ] Thống kê chi tiết và báo cáo

### 6.2 **Tối ưu hiệu suất**
- [ ] Lazy loading cho danh sách môn học
- [ ] Caching dữ liệu thông minh
- [ ] Tối ưu memory usage
- [ ] Fast startup time
- [ ] Smooth scrolling và animations

### 6.3 **Tính năng xã hội**
- [ ] So sánh tiến độ với bạn bè (nếu có)
- [ ] Chia sẻ thành tích học tập
- [ ] Community features (nếu cần)
- [ ] Feedback và rating system

### 6.4 **Chuẩn bị phát hành v2**
- [ ] Unit tests và integration tests mở rộng
- [ ] Performance testing
- [ ] Security audit
- [ ] App store optimization
- [ ] Documentation và user guide

### 6.5 **Tính năng bổ sung**
- [ ] Offline mode hoàn toàn
- [ ] Multi-language support
- [ ] Accessibility improvements
- [ ] Advanced analytics
- [ ] Custom themes và personalization

### 🛠️ Công nghệ cuối cùng
- **Testing**: Flutter testing framework
- **CI/CD**: GitHub Actions
- **Analytics**: Firebase Analytics
- **Crash Reporting**: Firebase Crashlytics
- **Performance**: Firebase Performance

---

## 📅 TIMELINE TỔNG THỂ

```
Giai đoạn 1: Core Features     [4-6 tuần]
├── Tuần 1-2: Setup + Dashboard cơ bản
├── Tuần 3-4: Danh sách môn học + Quản lý tiến độ
└── Tuần 5-6: Chi tiết môn học + Polish

Giai đoạn 2: Advanced Features [6-8 tuần]
├── Tuần 1-2: Tính toán GPA nâng cao
├── Tuần 3-4: Kế hoạch học tập thông minh
├── Tuần 5-6: Dashboard nâng cao + Checklist
└── Tuần 7-8: Tối ưu giao diện + Testing

Giai đoạn 3: Lịch học & Nhắc nhở [3-4 tuần]
├── Tuần 1: Course schedules + UI nhập
├── Tuần 2: Notifications + timezone
└── Tuần 3-4: Link online + tích hợp Planning

Giai đoạn 4: Multi-Program & Editor [3-4 tuần]
├── Tuần 1: Model Program + switcher
├── Tuần 2: CRUD Section/CourseGroup
└── Tuần 3-4: CRUD Course + validation + export/import

Giai đoạn 5: Chuẩn bị phát hành v1 [2-3 tuần]
├── Tuần 1: Auto tests + icon/splash + metadata
├── Tuần 2: CI/CD + Crashlytics/Analytics
└── Tuần 3: QA smoke + submit build (tuỳ tiến độ)

Giai đoạn 6: Nâng cao (v2) [4-8 tuần]
├── Tuần 1-2: Advanced features (export/import, backup)
├── Tuần 3-4: Hiệu năng + xã hội + báo cáo
└── Tuần 5-8: Hoàn thiện & phát hành v2 (tuỳ phạm vi)
```

**Tổng thời gian: 14-20 tuần (3.5-5 tháng)**

---

## 🎯 SUCCESS METRICS

### Giai đoạn 1:
- [ ] Ứng dụng chạy ổn định trên Android/iOS
- [ ] Hiển thị đúng dữ liệu 138 tín chỉ
- [ ] Có thể quản lý tiến độ cơ bản

### Giai đoạn 2:
- [ ] Tính toán GPA chính xác
- [ ] Kế hoạch học tập hoạt động tốt
- [ ] Giao diện đẹp và responsive

### Giai đoạn 3:
- [ ] Course schedules & notifications hoạt động ổn định
- [ ] Mở link online tốt trên iOS/Android
- [ ] UX lịch mượt và dễ dùng

---

## 🚀 NEXT STEPS

1. **Bắt đầu Giai đoạn 1** với việc setup project structure
2. **Tạo wireframes** cho các màn hình chính
3. **Setup development environment** và dependencies
4. **Implement Dashboard cơ bản** trước
5. **Iterative development** với testing liên tục

**Dự án sẵn sàng để bắt đầu phát triển!** 🎉
