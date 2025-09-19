# 🚀 Router Logging & Stack Tracking Summary

## 🎯 Mục tiêu
Thêm logging chi tiết để debug và theo dõi tất cả router navigation, màn hình hiện tại trong stack, và các hành động làm UI render.

## ✅ Tính năng đã thêm

### **1. Navigation Stack Tracking**
```dart
/// Navigation stack tracking
static final List<String> _navigationStack = [];

/// Get current navigation stack
static List<String> get navigationStack => List.unmodifiable(_navigationStack);

/// Get current page name
static String get currentPage => _navigationStack.isNotEmpty ? _navigationStack.last : 'unknown';
```

### **2. Navigation Logging**
```dart
/// Log navigation action
static void _logNavigation(String action, String from, String to, {Map<String, String>? params}) {
  if (kDebugMode) {
    final timestamp = DateTime.now().toIso8601String();
    final paramsStr = params != null ? ' | Params: $params' : '';
    debugPrint('🚀 [ROUTER] $timestamp | $action | $from → $to$paramsStr');
    debugPrint('📚 [STACK] Current stack: $_navigationStack');
  }
}
```

### **3. Stack Management**
```dart
/// Update navigation stack
static void _updateStack(String pageName, String action) {
  switch (action) {
    case 'push':
      _navigationStack.add(pageName);
      break;
    case 'pop':
      if (_navigationStack.isNotEmpty) {
        _navigationStack.removeLast();
      }
      break;
    case 'replace':
      if (_navigationStack.isNotEmpty) {
        _navigationStack.removeLast();
      }
      _navigationStack.add(pageName);
      break;
    case 'clear':
      _navigationStack.clear();
      _navigationStack.add(pageName);
      break;
  }
}
```

### **4. Route Builders với Logging**
```dart
// Dashboard
GoRoute(
  path: dashboard,
  name: 'dashboard',
  builder: (context, state) {
    _updateStack('dashboard', 'push');
    _logNavigation('NAVIGATE', currentPage, 'dashboard');
    return const DashboardPage();
  },
),

// Course Detail với parameters
GoRoute(
  path: courseDetail,
  name: 'courseDetail',
  builder: (context, state) {
    final courseId = state.pathParameters['courseId']!;
    _updateStack('courseDetail', 'push');
    _logNavigation('NAVIGATE', currentPage, 'courseDetail', params: {'courseId': courseId});
    return CourseDetailPage(courseId: courseId);
  },
),
```

### **5. Navigation Methods với Logging**
```dart
static void goToDashboard(BuildContext context) {
  AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'dashboard');
  context.go(AppRouter.dashboard);
}

static void goToCourseDetail(BuildContext context, String courseId) {
  AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'courseDetail', params: {'courseId': courseId});
  context.go('/courses/$courseId');
}

static void goBack(BuildContext context) {
  if (context.canPop()) {
    AppRouter._logNavigation('POP', AppRouter.currentPage, 'previous');
    AppRouter._updateStack('', 'pop');
    context.pop();
  } else {
    AppRouter._logNavigation('GO_TO', AppRouter.currentPage, 'dashboard', params: {'reason': 'fallback'});
    context.go(AppRouter.dashboard);
  }
}
```

### **6. UI Render Logging**
```dart
/// Log UI render events
static void logUIRender(String widgetName, {Map<String, dynamic>? data}) {
  if (kDebugMode) {
    final timestamp = DateTime.now().toIso8601String();
    final dataStr = data != null ? ' | Data: $data' : '';
    debugPrint('🎨 [UI_RENDER] $timestamp | $widgetName$dataStr');
    debugPrint('📚 [STACK] Current page: ${AppRouter.currentPage}');
  }
}
```

### **7. State Change Logging**
```dart
/// Log state changes
static void logStateChange(String stateName, dynamic oldValue, dynamic newValue) {
  if (kDebugMode) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('🔄 [STATE] $timestamp | $stateName: $oldValue → $newValue');
    debugPrint('📚 [STACK] Current page: ${AppRouter.currentPage}');
  }
}
```

### **8. User Action Logging**
```dart
/// Log user actions
static void logUserAction(String action, {Map<String, dynamic>? data}) {
  if (kDebugMode) {
    final timestamp = DateTime.now().toIso8601String();
    final dataStr = data != null ? ' | Data: $data' : '';
    debugPrint('👆 [USER_ACTION] $timestamp | $action$dataStr');
    debugPrint('📚 [STACK] Current page: ${AppRouter.currentPage}');
  }
}
```

## 🔍 Log Format Examples

### **Navigation Logs:**
```
🚀 [ROUTER] 2024-01-15T10:30:45.123Z | NAVIGATE | dashboard → courses
📚 [STACK] Current stack: [dashboard, courses]

🚀 [ROUTER] 2024-01-15T10:30:50.456Z | GO_TO | courses → courseDetail | Params: {courseId: CS101}
📚 [STACK] Current stack: [dashboard, courses, courseDetail]

🚀 [ROUTER] 2024-01-15T10:31:00.789Z | POP | courseDetail → previous
📚 [STACK] Current stack: [dashboard, courses]
```

### **UI Render Logs:**
```
🎨 [UI_RENDER] 2024-01-15T10:30:45.123Z | DashboardPage | Data: {isLoading: false, error: null}
📚 [STACK] Current page: dashboard

🎨 [UI_RENDER] 2024-01-15T10:30:50.456Z | CourseCard | Data: {courseId: CS101, status: completed}
📚 [STACK] Current page: courses
```

### **State Change Logs:**
```
🔄 [STATE] 2024-01-15T10:30:45.123Z | isLoading: true → false
📚 [STACK] Current page: dashboard

🔄 [STATE] 2024-01-15T10:30:50.456Z | selectedCourse: null → CS101
📚 [STACK] Current page: courses
```

### **User Action Logs:**
```
👆 [USER_ACTION] 2024-01-15T10:30:45.123Z | button_tap | Data: {button: settings, page: dashboard}
📚 [STACK] Current page: dashboard

👆 [USER_ACTION] 2024-01-15T10:30:50.456Z | course_select | Data: {courseId: CS101, page: courses}
📚 [STACK] Current page: courses
```

### **Error Logs:**
```
🚀 [ROUTER] 2024-01-15T10:30:45.123Z | ERROR | courses → error | Params: {uri: /invalid-route}
📚 [STACK] Current stack: [dashboard, courses]
```

## 🎯 Cách sử dụng

### **1. Navigation Logging (Tự động)**
- Tất cả navigation đều được log tự động
- Stack được cập nhật tự động
- Không cần thêm code

### **2. UI Render Logging (Manual)**
```dart
@override
Widget build(BuildContext context) {
  AppNavigation.logUIRender('DashboardPage', data: {
    'isLoading': provider.isLoading,
    'error': provider.error,
  });
  
  return Scaffold(
    // ... widget content
  );
}
```

### **3. State Change Logging (Manual)**
```dart
void _updateScore(double newScore) {
  final oldScore = _currentScore;
  _currentScore = newScore;
  
  AppNavigation.logStateChange('score', oldScore, newScore);
}
```

### **4. User Action Logging (Manual)**
```dart
IconButton(
  onPressed: () {
    AppNavigation.logUserAction('settings_tap', data: {
      'page': 'dashboard',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    AppNavigation.goToSettings(context);
  },
  icon: const Icon(Icons.settings),
)
```

## 🔧 Debug Features

### **1. Stack Inspection**
```dart
// Get current navigation stack
final stack = AppRouter.navigationStack;
print('Current stack: $stack');

// Get current page
final currentPage = AppRouter.currentPage;
print('Current page: $currentPage');
```

### **2. Navigation History**
- Tất cả navigation actions được log với timestamp
- Stack được track real-time
- Parameters được log chi tiết

### **3. Error Tracking**
- Navigation errors được log
- Invalid routes được track
- Fallback navigation được log

## 🎨 Log Categories

### **🚀 [ROUTER]** - Navigation events
- `NAVIGATE` - Route navigation
- `GO_TO` - Programmatic navigation
- `POP` - Back navigation
- `ERROR` - Navigation errors

### **🎨 [UI_RENDER]** - UI rendering events
- Widget builds
- UI updates
- Render cycles

### **🔄 [STATE]** - State changes
- Provider state changes
- Local state updates
- Data mutations

### **👆 [USER_ACTION]** - User interactions
- Button taps
- Form submissions
- Gesture recognitions

### **📚 [STACK]** - Navigation stack info
- Current stack state
- Current page
- Stack depth

## 🎉 Kết quả

**Router logging và stack tracking đã được thêm thành công!**

- ✅ **Complete navigation logging** - Tất cả navigation được log
- ✅ **Stack tracking** - Theo dõi màn hình hiện tại trong stack
- ✅ **UI render logging** - Log khi có hành động làm UI render
- ✅ **State change logging** - Theo dõi state changes
- ✅ **User action logging** - Log user interactions
- ✅ **Error tracking** - Theo dõi navigation errors
- ✅ **Debug-friendly** - Dễ debug và troubleshoot
- ✅ **Performance optimized** - Chỉ log trong debug mode

**Giờ đây bạn có thể dễ dàng debug và theo dõi tất cả navigation và UI events!** 🚀

---

*Added on: $(date)*
*Status: ✅ COMPLETED*
