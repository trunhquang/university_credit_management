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

## 🚀 BLUEPRINT 3 GIAI ĐOẠN

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

## 🌟 GIAI ĐOẠN 3: ENHANCEMENT & POLISH (4-6 tuần)
*Mục tiêu: Hoàn thiện ứng dụng và chuẩn bị phát hành*

### 🎯 Mục tiêu chính
- Tối ưu hiệu suất và ổn định
- Thêm tính năng nâng cao
- Chuẩn bị phát hành

### 📋 Tính năng cần phát triển

#### 3.1 **Tính năng nâng cao**
- [ ] Export/Import dữ liệu (JSON, CSV)
- [ ] Backup và restore dữ liệu
- [ ] Chia sẻ tiến độ học tập
- [ ] Tích hợp lịch học từ hệ thống trường
- [ ] Thống kê chi tiết và báo cáo

#### 3.2 **Tối ưu hiệu suất**
- [ ] Lazy loading cho danh sách môn học
- [ ] Caching dữ liệu thông minh
- [ ] Tối ưu memory usage
- [ ] Fast startup time
- [ ] Smooth scrolling và animations

#### 3.3 **Tính năng xã hội**
- [ ] So sánh tiến độ với bạn bè (nếu có)
- [ ] Chia sẻ thành tích học tập
- [ ] Community features (nếu cần)
- [ ] Feedback và rating system

#### 3.4 **Chuẩn bị phát hành**
- [ ] Unit tests và integration tests
- [ ] Performance testing
- [ ] Security audit
- [ ] App store optimization
- [ ] Documentation và user guide

#### 3.5 **Tính năng bổ sung**
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

### 📊 Deliverables
- [ ] Ứng dụng hoàn chỉnh và ổn định
- [ ] Test coverage > 80%
- [ ] Performance optimization
- [ ] App store ready
- [ ] Documentation đầy đủ

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

Giai đoạn 3: Enhancement       [4-6 tuần]
├── Tuần 1-2: Tính năng nâng cao
├── Tuần 3-4: Tối ưu hiệu suất
└── Tuần 5-6: Chuẩn bị phát hành
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
- [ ] Performance tốt (< 2s startup)
- [ ] Test coverage > 80%
- [ ] Sẵn sàng phát hành app store

---

## 🚀 NEXT STEPS

1. **Bắt đầu Giai đoạn 1** với việc setup project structure
2. **Tạo wireframes** cho các màn hình chính
3. **Setup development environment** và dependencies
4. **Implement Dashboard cơ bản** trước
5. **Iterative development** với testing liên tục

**Dự án sẵn sàng để bắt đầu phát triển!** 🎉
