# 🏗️ Cấu trúc Dự án Grad Tracker

## 📁 Cấu trúc thư mục dự án

```
lib/
├── app/                          # App configuration
│   └── app.dart
├── core/                         # Core functionality
│   ├── data/                     # Data layer
│   │   ├── curriculum_template.dart
│   │   ├── curriculum_test.dart
│   │   └── local_storage.dart
│   ├── models/                   # Data models
│   │   ├── section.dart
│   │   ├── course.dart
│   │   ├── course_group.dart
│   │   ├── progress_model.dart
│   │   └── gpa_model.dart
│   ├── repositories/             # Data repositories
│   │   └── curriculum_repository.dart
│   ├── state/                    # State management
│   │   ├── curriculum_state.dart
│   │   ├── progress_state.dart
│   │   └── gpa_state.dart
│   ├── theme/                    # UI theme
│   │   ├── app_theme.dart
│   │   ├── brand_colors.dart
│   │   └── text_styles.dart
│   └── utils/                    # Utilities
│       ├── gpa_calculator.dart
│       ├── progress_calculator.dart
│       └── validators.dart
├── features/                     # Feature modules
│   ├── dashboard/                # Dashboard feature
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── dashboard_page.dart
│   │   │   └── widgets/
│   │   │       ├── progress_chart.dart
│   │   │       ├── section_summary.dart
│   │   │       └── gpa_display.dart
│   │   └── domain/
│   │       └── dashboard_service.dart
│   ├── courses/                  # Courses feature
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   ├── courses_list_page.dart
│   │   │   │   └── course_detail_page.dart
│   │   │   └── widgets/
│   │   │       ├── course_card.dart
│   │   │       ├── course_filter.dart
│   │   │       └── course_status_chip.dart
│   │   └── domain/
│   │       └── courses_service.dart
│   ├── progress/                 # Progress tracking
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── progress_page.dart
│   │   │   └── widgets/
│   │   │       ├── section_progress.dart
│   │   │       └── progress_timeline.dart
│   │   └── domain/
│   │       └── progress_service.dart
│   ├── gpa/                      # GPA calculation
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── gpa_page.dart
│   │   │   └── widgets/
│   │   │       ├── gpa_chart.dart
│   │   │       ├── gpa_predictor.dart
│   │   │       └── grade_suggestions.dart
│   │   └── domain/
│   │       └── gpa_service.dart
│   ├── planning/                 # Study planning
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── planning_page.dart
│   │   │   └── widgets/
│   │   │       ├── semester_plan.dart
│   │   │       └── course_scheduler.dart
│   │   └── domain/
│   │       └── planning_service.dart
│   └── graduation/               # Graduation checklist
│       ├── presentation/
│       │   ├── pages/
│       │   │   └── graduation_page.dart
│       │   └── widgets/
│       │       ├── checklist_item.dart
│       │       └── requirement_card.dart
│       └── domain/
│           └── graduation_service.dart
├── shared/                       # Shared components
│   ├── widgets/                  # Reusable widgets
│   │   ├── custom_app_bar.dart
│   │   ├── loading_widget.dart
│   │   ├── error_widget.dart
│   │   └── custom_button.dart
│   └── constants/                # App constants
│       ├── app_constants.dart
│       └── route_constants.dart
└── main.dart                     # App entry point
```

## 🎨 Wireframes & UI Flow

### 📱 Màn hình chính

#### 1. **Dashboard Page**
```
┌─────────────────────────────────┐
│ [≡] Grad Tracker        [⚙️]    │
├─────────────────────────────────┤
│ 📊 Tiến độ tổng thể             │
│ ┌─────────────────────────────┐ │
│ │     [Progress Circle]       │ │
│ │     45/138 tín chỉ          │ │
│ │        (32.6%)              │ │
│ └─────────────────────────────┘ │
│                                 │
│ 📚 Khối kiến thức               │
│ ┌─────────────────────────────┐ │
│ │ Đại cương: 20/56 (35%)      │ │
│ │ Cơ sở ngành: 15/38 (39%)    │ │
│ │ Chuyên ngành: 10/34 (29%)   │ │
│ │ Tốt nghiệp: 0/10 (0%)       │ │
│ └─────────────────────────────┘ │
│                                 │
│ 🎯 GPA hiện tại: 3.2/4.0        │
│                                 │
│ [📖 Xem môn học] [📈 Chi tiết]  │
└─────────────────────────────────┘
```

#### 2. **Courses List Page**
```
┌─────────────────────────────────┐
│ [←] Môn học            [🔍] [⚙️] │
├─────────────────────────────────┤
│ [Tất cả] [Đã học] [Đang học]    │
│                                 │
│ 📚 Kiến thức giáo dục đại cương │
│ ┌─────────────────────────────┐ │
│ │ ✅ Triết học Mác-Lênin      │ │
│ │    3 tín chỉ • 5.6 điểm     │ │
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │ 🔄 Lịch sử Đảng CSVN        │ │
│ │    2 tín chỉ • Đang học     │ │
│ └─────────────────────────────┘ │
│                                 │
│ 📚 Kiến thức cơ sở ngành        │
│ ┌─────────────────────────────┐ │
│ │ ✅ Nhập môn lập trình       │ │
│ │    4 tín chỉ • 8.5 điểm     │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

#### 3. **Course Detail Page**
```
┌─────────────────────────────────┐
│ [←] Chi tiết môn học            │
├─────────────────────────────────┤
│ 📖 Nhập môn lập trình           │
│                                 │
│ Mã môn: CSC10001                │
│ Tín chỉ: 4                      │
│ Loại: Bắt buộc                  │
│ Trạng thái: ✅ Đã hoàn thành    │
│                                 │
│ Điểm số: 8.5/10                 │
│ GPA: 3.4/4.0                    │
│                                 │
│ Mô tả:                          │
│ Môn học cơ bản về lập trình...  │
│                                 │
│ [✏️ Chỉnh sửa] [📊 Thống kê]   │
└─────────────────────────────────┘
```

#### 4. **GPA Page**
```
┌─────────────────────────────────┐
│ [←] GPA & Điểm số      [📊]     │
├─────────────────────────────────┤
│ 🎯 GPA hiện tại                 │
│ ┌─────────────────────────────┐ │
│ │     [GPA Chart]             │ │
│ │     3.2/4.0                 │ │
│ │     (Khá)                   │ │
│ └─────────────────────────────┘ │
│                                 │
│ 📈 Dự đoán GPA                  │
│ Để đạt Giỏi (3.5):              │
│ Cần trung bình 8.5 cho 15 môn   │
│ còn lại                         │
│                                 │
│ 🎯 Gợi ý điểm:                  │
│ • Xuất sắc (3.7+): 9.0+        │
│ • Giỏi (3.5+): 8.5+            │
│ • Khá (3.0+): 7.5+             │
│                                 │
│ [📊 Biểu đồ] [🎯 Kế hoạch]     │
└─────────────────────────────────┘
```

## 🔄 Navigation Flow

```
main.dart
    ↓
Dashboard (Home)
    ├── Courses List
    │   └── Course Detail
    ├── Progress Tracking
    ├── GPA Calculator
    ├── Study Planning
    ├── Graduation Checklist
    └── Settings
```

## 🎯 Key Features Implementation

### 1. **State Management**
```dart
// Using Provider pattern
class CurriculumProvider extends ChangeNotifier {
  List<Section> _sections = [];
  Map<String, Course> _courses = {};
  
  // Getters and methods
}
```

### 2. **Data Models**
```dart
class GPAModel {
  final double currentGPA;
  final int totalCredits;
  final Map<String, double> gradePredictions;
  
  // GPA calculation methods
}
```

### 3. **Services**
```dart
class GPAService {
  static double calculateGPA(List<Course> courses);
  static Map<String, double> predictRequiredGrades(
    double targetGPA, 
    List<Course> remainingCourses
  );
}
```

## 📊 Data Flow

```
UI Layer (Pages/Widgets)
    ↓
State Management (Providers)
    ↓
Services (Business Logic)
    ↓
Repositories (Data Access)
    ↓
Data Sources (Local Storage/API)
```

## 🚀 Development Priorities

### Phase 1 Focus:
1. **Dashboard** - Core progress display
2. **Courses List** - Basic course management
3. **Course Detail** - Individual course info
4. **Basic GPA** - Simple calculation

### Phase 2 Focus:
1. **Advanced GPA** - Predictions and suggestions
2. **Study Planning** - Semester planning
3. **Progress Charts** - Visual representations
4. **Graduation Checklist** - Requirements tracking

### Phase 3 Focus:
1. **Performance** - Optimization
2. **Testing** - Comprehensive coverage
3. **Polish** - UI/UX improvements
4. **Deployment** - App store preparation

---

**Cấu trúc này đảm bảo:**
- ✅ **Scalability** - Dễ mở rộng tính năng
- ✅ **Maintainability** - Dễ bảo trì code
- ✅ **Testability** - Dễ viết unit tests
- ✅ **Clean Architecture** - Tách biệt các layer
- ✅ **Reusability** - Tái sử dụng components
