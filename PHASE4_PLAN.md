# 📗 Phase 4 Plan — Multi-Program & Curriculum Editor

## 🎯 Mục tiêu
- Một user có thể học nhiều chuyên ngành/chương trình (Program)
- CRUD Section, CourseGroup, Course với ràng buộc tín chỉ & tiên quyết

## 📋 Backlog chi tiết
1) Multi-Program
- Model `Program` (id, name, totalCredits, outcomes)
- Chọn/chuyển Program đang hoạt động
- Scope dữ liệu theo Program (sections/courses riêng)

2) Curriculum Editor
- Thêm/Sửa/Xóa `Section`
- Thêm/Sửa/Xóa `CourseGroup`
- Thêm/Sửa/Xóa `Course`
- Validation: tổng tín chỉ, prerequisite, loại môn
- Export/Import JSON để chia sẻ curriculum

## 🛠️ Công nghệ
- Reusable forms & validators
- JSON encode/decode (export/import)

## 📊 Deliverables
- Quản lý nhiều chương trình học
- Trình chỉnh sửa curriculum hoàn chỉnh

## ⏱️ Timeline (3-4 tuần)
- Tuần 1: Model Program + switcher
- Tuần 2: CRUD Section/CourseGroup
- Tuần 3-4: CRUD Course + validation + export/import
