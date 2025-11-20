# Hướng dẫn Deploy và Vận hành

## Yêu cầu hệ thống

### Phần mềm cần thiết:
- **JDK**: 8 hoặc cao hơn
- **Apache Tomcat**: 9.0 hoặc cao hơn
- **MySQL**: 5.7 hoặc cao hơn
- **Eclipse/IntelliJ IDEA**: IDE để phát triển (tùy chọn)

---

## Bước 1: Chuẩn bị Database

### 1.1. Cài đặt MySQL
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install mysql-server

# macOS (Homebrew)
brew install mysql
brew services start mysql

# Windows: Tải MySQL Installer từ mysql.com
```

### 1.2. Tạo Database
```bash
# Đăng nhập MySQL
mysql -u root -p

# Tạo database
CREATE DATABASE online_exam_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Tạo user cho ứng dụng (khuyến nghị)
CREATE USER 'examuser'@'localhost' IDENTIFIED BY 'exam@2024';
GRANT ALL PRIVILEGES ON online_exam_db.* TO 'examuser'@'localhost';
FLUSH PRIVILEGES;

# Thoát MySQL
EXIT;
```

### 1.3. Import Schema
```bash
mysql -u root -p online_exam_db < /path/to/database/schema.sql
```

---

## Bước 2: Cấu hình ứng dụng

### 2.1. Cập nhật Database Connection
Chỉnh sửa file `src/main/java/com/onlineexam/util/DatabaseConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/online_exam_db";
private static final String USERNAME = "examuser";  // Hoặc "root"
private static final String PASSWORD = "exam@2024"; // Password của bạn
```

### 2.2. Cấu hình web.xml (nếu cần)
File `src/main/webapp/WEB-INF/web.xml` đã được cấu hình sẵn.

---

## Bước 3: Thêm thư viện

### Option 1: Manual (không dùng Maven)

Tải và copy các file JAR vào `src/main/webapp/WEB-INF/lib/`:

1. **mysql-connector-java-8.0.33.jar**
   - Link: https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/

2. **json-20230227.jar**
   - Link: https://repo1.maven.org/maven2/org/json/json/20230227/

3. **jstl-1.2.jar**
   - Link: https://repo1.maven.org/maven2/javax/servlet/jstl/1.2/

### Option 2: Maven

Nếu dùng Maven, chỉ cần chạy:
```bash
mvn clean install
```

---

## Bước 4: Deploy lên Tomcat

### Option 1: Sử dụng Eclipse

1. **Cấu hình Tomcat trong Eclipse:**
   - Window → Preferences → Server → Runtime Environments
   - Add → Apache Tomcat v9.0
   - Chọn thư mục cài đặt Tomcat
   - Apply and Close

2. **Deploy project:**
   - Right-click project → Run As → Run on Server
   - Chọn Tomcat server
   - Finish

3. **Truy cập ứng dụng:**
   ```
   http://localhost:8080/OnlineExam/
   ```

### Option 2: Manual Deploy

1. **Export WAR file:**
   - Right-click project → Export → WAR file
   - Chọn đường dẫn lưu file
   - Finish

2. **Copy WAR vào Tomcat:**
   ```bash
   cp OnlineExam.war /path/to/tomcat/webapps/
   ```

3. **Khởi động Tomcat:**
   ```bash
   # Linux/macOS
   /path/to/tomcat/bin/startup.sh
   
   # Windows
   C:\tomcat\bin\startup.bat
   ```

4. **Truy cập ứng dụng:**
   ```
   http://localhost:8080/OnlineExam/
   ```

### Option 3: Maven Tomcat Plugin

Nếu dùng Maven với Tomcat plugin:
```bash
mvn tomcat7:run
```

---

## Bước 5: Kiểm tra và Test

### 5.1. Kiểm tra Database Connection
Truy cập trang login và thử đăng nhập với tài khoản demo:
- **Giảng viên**: teacher1 / password123
- **Sinh viên**: student1 / password123

### 5.2. Test các chức năng chính

**Với tài khoản Giảng viên:**
1. Đăng nhập
2. Xem dashboard
3. Quản lý lớp học phần
4. Tạo bài kiểm tra (upload file JSON mẫu)
5. Xem danh sách điểm

**Với tài khoản Sinh viên:**
1. Đăng nhập
2. Xem dashboard
3. Xem lớp học phần
4. Làm bài thi (nếu có bài thi mở)
5. Xem lịch sử thi và điểm số

---

## Bước 6: Production Deployment

### 6.1. Cấu hình cho môi trường Production

**Thay đổi password mặc định:**
```sql
-- Cập nhật password cho các user demo
UPDATE users SET password_hash = 'new_hashed_password' WHERE username = 'teacher1';
```

**Tắt debug mode:**
- Xóa hoặc comment các dòng `System.out.println()` và `e.printStackTrace()`
- Sử dụng logging framework (Log4j, SLF4J)

**Cấu hình HTTPS:**
Chỉnh sửa `server.xml` của Tomcat để enable HTTPS

**Backup database:**
```bash
mysqldump -u root -p online_exam_db > backup_$(date +%Y%m%d).sql
```

### 6.2. Performance Tuning

**Tomcat:**
Chỉnh sửa `catalina.sh` hoặc `catalina.bat`:
```bash
JAVA_OPTS="-Xms512m -Xmx2048m -XX:PermSize=256m -XX:MaxPermSize=512m"
```

**MySQL:**
Chỉnh sửa `my.cnf`:
```ini
[mysqld]
max_connections = 200
innodb_buffer_pool_size = 1G
```

**Connection Pool:**
Sử dụng Apache DBCP hoặc HikariCP thay vì connection đơn giản

---

## Bước 7: Monitoring và Maintenance

### 7.1. Log Files

**Tomcat logs:**
```
/path/to/tomcat/logs/catalina.out
/path/to/tomcat/logs/localhost.log
```

**MySQL logs:**
```bash
tail -f /var/log/mysql/error.log
```

### 7.2. Regular Maintenance

**Backup database hàng ngày:**
```bash
# Tạo cron job
0 2 * * * mysqldump -u root -p'password' online_exam_db > /backups/exam_$(date +\%Y\%m\%d).sql
```

**Clean up old data:**
```sql
-- Xóa notifications cũ hơn 90 ngày
DELETE FROM notifications WHERE created_at < DATE_SUB(NOW(), INTERVAL 90 DAY);
```

---

## Troubleshooting

### Lỗi kết nối Database
```
Error: Communications link failure
```
**Giải pháp:**
- Kiểm tra MySQL đang chạy: `systemctl status mysql`
- Kiểm tra firewall
- Verify username/password trong DatabaseConnection.java

### Lỗi 404 Not Found
```
HTTP Status 404 – Not Found
```
**Giải pháp:**
- Kiểm tra context path
- Verify servlet mapping trong web.xml
- Xem Tomcat logs

### Lỗi OutOfMemoryError
```
java.lang.OutOfMemoryError: Java heap space
```
**Giải pháp:**
- Tăng heap size trong JAVA_OPTS
- Kiểm tra memory leaks
- Restart Tomcat

### Lỗi Session timeout
**Giải pháp:**
Tăng session timeout trong web.xml:
```xml
<session-config>
    <session-timeout>60</session-timeout>
</session-config>
```

---

## Security Checklist

- [ ] Thay đổi password mặc định
- [ ] Sử dụng HTTPS
- [ ] Validate và sanitize user input
- [ ] Implement CSRF protection
- [ ] Regular security updates
- [ ] Restrict database user privileges
- [ ] Enable SQL injection protection
- [ ] Implement rate limiting
- [ ] Regular backup

---

## Contact & Support

Để được hỗ trợ:
1. Kiểm tra logs
2. Xem documentation
3. Tạo issue trên GitHub
4. Liên hệ admin

---

## License
Educational project - Free to use and modify
