import '../models/category.dart';
import '../models/course.dart';

List<Category> seedCategories() {
  const corePolitics = [
    Course(code: 'BAA00101', name: 'Triết học Mác – Lênin', credits: 3, elective: false),
    Course(code: 'BAA00102', name: 'Kinh tế chính trị Mác – Lênin', credits: 2, elective: false),
    Course(code: 'BAA00103', name: 'Chủ nghĩa xã hội khoa học', credits: 2, elective: false),
    Course(code: 'BAA00104', name: 'Lịch sử Đảng CSVN', credits: 2, elective: false),
    Course(code: 'BAA00003', name: 'Tư tưởng Hồ Chí Minh', credits: 2, elective: false),
    Course(code: 'BAA00004', name: 'Pháp luật đại cương', credits: 3, elective: false),
  ];

  const csMath = [
    Course(code: 'MTH00003', name: 'Vi tích phân 1B', credits: 3, elective: false),
    Course(code: 'MTH00040', name: 'Xác suất thống kê', credits: 3, elective: false),
    Course(code: 'MTH00041', name: 'Toán rời rạc', credits: 3, elective: false),
  ];

  const csItIntro = [
    Course(code: 'CSC00004', name: 'Nhập môn CNTT', credits: 4, elective: true),
    Course(code: 'CSC00006', name: 'Tin học cơ sở', credits: 4, elective: true),
  ];

  const foundation = [
    Course(code: 'CSC10001', name: 'Nhập môn lập trình', credits: 4, elective: false),
    Course(code: 'CSC10002', name: 'Kỹ thuật lập trình', credits: 4, elective: false),
    Course(code: 'CSC10003', name: 'OOP', credits: 4, elective: false),
    Course(code: 'CSC10004', name: 'Cấu trúc dữ liệu & GT', credits: 4, elective: false),
    Course(code: 'CSC10006', name: 'Cơ sở dữ liệu', credits: 4, elective: false),
    Course(code: 'CSC10007', name: 'Hệ điều hành', credits: 4, elective: false),
    Course(code: 'CSC10008', name: 'Mạng máy tính', credits: 4, elective: false),
    Course(code: 'CSC10009', name: 'Hệ thống máy tính', credits: 2, elective: false),
    Course(code: 'CSC13002', name: 'Nhập môn CN phần mềm', credits: 4, elective: false),
    Course(code: 'CSC14003', name: 'Cơ sở trí tuệ nhân tạo', credits: 4, elective: false),
  ];

  const major = [
    Course(code: 'CSC13008', name: 'Phát triển ứng dụng web', credits: 4, elective: true),
    Course(code: 'CSC13009', name: 'Phát triển phần mềm cho thiết bị di động', credits: 4, elective: true),
    Course(code: 'CSC13010', name: 'Thiết kế phần mềm', credits: 4, elective: true),
    Course(code: 'CSC13119', name: 'Lập trình Web 1', credits: 4, elective: true),
    Course(code: 'CSC13120', name: 'Lập trình Web 2', credits: 4, elective: true),
    Course(code: 'CSC13121', name: 'Lập trình ứng dụng quản lý 1', credits: 4, elective: true),
    Course(code: 'CSC13122', name: 'Lập trình ứng dụng quản lý 2', credits: 4, elective: true),
    Course(code: 'CSC15004', name: 'Học thống kê', credits: 4, elective: true),
    Course(code: 'CSC15007', name: 'Thống kê máy tính và ứng dụng', credits: 4, elective: true),
  ];

  const graduation = [
    Course(code: 'CSC10251', name: 'Khóa luận tốt nghiệp', credits: 10, elective: true),
    Course(code: 'CSC10252', name: 'Thực tập tốt nghiệp', credits: 10, elective: true),
  ];

  return [
    Category(id: 'gen-politics', title: 'Lý luận chính trị – Pháp luật', requiredCredits: 14, courses: corePolitics),
    Category(id: 'gen-it', title: 'Tin học (chọn 1 học phần 4 TC)', requiredCredits: 4, courses: csItIntro, minChoiceCredits: 4),
    Category(id: 'gen-math', title: 'Toán – KHTN', requiredCredits: 12, courses: csMath),
    Category(id: 'foundation', title: 'Kiến thức cơ sở ngành', requiredCredits: 38, courses: foundation),
    Category(id: 'major', title: 'Kiến thức ngành/chuyên ngành (tích lũy ≥34 TC)', requiredCredits: 34, courses: major),
    Category(id: 'graduation', title: 'Kiến thức tốt nghiệp (≥10 TC, chọn 1 phương án)', requiredCredits: 10, courses: graduation, minChoiceCredits: 10),
  ];
}


