# Simple Web Project for Firebase Hosting

## Cấu trúc
- `index.html`: Trang chủ
- `support.html`: Trang hỗ trợ
- `policy.html`: Trang chính sách
- `style.css`: Giao diện chung

## Hướng dẫn deploy lên Firebase Hosting

1. Cài đặt Firebase CLI nếu chưa có:
   ```bash
   npm install -g firebase-tools
   ```
2. Đăng nhập Firebase:
   ```bash
   firebase login
   ```
3. Khởi tạo project (chạy trong thư mục này):
   ```bash
   firebase init
   ```
   - Chọn **Hosting**
   - Chọn project trên Firebase hoặc tạo mới
   - Nhập thư mục public là `.` (dấu chấm, nếu bạn deploy từ thư mục này)
   - Không overwrite file nếu được hỏi
4. Deploy:
   ```bash
   firebase deploy
   ```

Sau khi deploy thành công, bạn sẽ nhận được link website trên Firebase Hosting. 