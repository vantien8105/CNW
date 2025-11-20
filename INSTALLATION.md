# Hướng dẫn Cài đặt Thư viện

## 1. MySQL Connector/J

### Download:
Truy cập: https://dev.mysql.com/downloads/connector/j/

Hoặc Maven:
```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```

### Manual Installation:
1. Tải file `mysql-connector-java-8.0.33.jar`
2. Copy vào `src/main/webapp/WEB-INF/lib/`

---

## 2. Servlet API

### Download:
Truy cập: https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api/4.0.1

Hoặc Maven:
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>
```

**Lưu ý**: Tomcat đã có sẵn Servlet API, nên không cần thêm vào WEB-INF/lib.
Chỉ cần thêm vào build path để compile.

---

## 3. JSON Processing Library

### Option 1: JSON-Java (org.json)

**Download:**
Truy cập: https://mvnrepository.com/artifact/org.json/json/20230227

Hoặc Maven:
```xml
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20230227</version>
</dependency>
```

**Manual Installation:**
1. Tải file `json-20230227.jar`
2. Copy vào `src/main/webapp/WEB-INF/lib/`

### Option 2: Gson (Google)

**Download:**
Truy cập: https://mvnrepository.com/artifact/com.google.code.gson/gson/2.10.1

Hoặc Maven:
```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.10.1</version>
</dependency>
```

**Manual Installation:**
1. Tải file `gson-2.10.1.jar`
2. Copy vào `src/main/webapp/WEB-INF/lib/`

---

## 4. JSTL (JSP Standard Tag Library)

### Download:
Truy cập: https://mvnrepository.com/artifact/javax.servlet/jstl/1.2

Hoặc Maven:
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
    <version>1.2</version>
</dependency>
```

### Manual Installation:
1. Tải file `jstl-1.2.jar`
2. Copy vào `src/main/webapp/WEB-INF/lib/`

---

## 5. File Upload (Apache Commons FileUpload) - Optional

Nếu cần upload file đề thi:

### Download:
Truy cập: https://commons.apache.org/proper/commons-fileupload/download_fileupload.cgi

Hoặc Maven:
```xml
<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.5</version>
</dependency>
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.11.0</version>
</dependency>
```

---

## Cấu trúc thư mục WEB-INF/lib sau khi cài đặt:

```
WEB-INF/lib/
├── mysql-connector-java-8.0.33.jar
├── json-20230227.jar (hoặc gson-2.10.1.jar)
├── jstl-1.2.jar
├── commons-fileupload-1.5.jar (optional)
└── commons-io-2.11.0.jar (optional)
```

---

## Cấu hình Eclipse

### 1. Add JARs to Build Path:
1. Right-click project → Properties
2. Java Build Path → Libraries
3. Add JARs → Chọn các file JAR trong WEB-INF/lib
4. Apply and Close

### 2. Configure Tomcat:
1. Window → Preferences → Server → Runtime Environments
2. Add → Apache Tomcat v9.0
3. Chọn thư mục cài đặt Tomcat
4. Finish

### 3. Run Project:
1. Right-click project → Run As → Run on Server
2. Chọn Tomcat server
3. Finish

---

## Maven Configuration (Tùy chọn)

Nếu sử dụng Maven, tạo file `pom.xml`:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.onlineexam</groupId>
    <artifactId>OnlineExam</artifactId>
    <version>1.0.0</version>
    <packaging>war</packaging>
    
    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <dependencies>
        <!-- MySQL Connector -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.33</version>
        </dependency>
        
        <!-- Servlet API -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>4.0.1</version>
            <scope>provided</scope>
        </dependency>
        
        <!-- JSON Processing -->
        <dependency>
            <groupId>org.json</groupId>
            <artifactId>json</artifactId>
            <version>20230227</version>
        </dependency>
        
        <!-- JSTL -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
        
        <!-- File Upload (Optional) -->
        <dependency>
            <groupId>commons-fileupload</groupId>
            <artifactId>commons-fileupload</artifactId>
            <version>1.5</version>
        </dependency>
        
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.11.0</version>
        </dependency>
    </dependencies>
    
    <build>
        <finalName>OnlineExam</finalName>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.3.2</version>
            </plugin>
        </plugins>
    </build>
</project>
```

---

## Kiểm tra cài đặt

Sau khi cài đặt, kiểm tra:

1. **Database Connection:**
```java
DatabaseConnection.testConnection();
```

2. **Run Application:**
```
http://localhost:8080/OnlineExam/
```

3. **Login với tài khoản demo:**
- teacher1 / password123
- student1 / password123

---

## Troubleshooting

### ClassNotFoundException: com.mysql.cj.jdbc.Driver
→ Kiểm tra mysql-connector-java JAR đã được thêm vào WEB-INF/lib

### Cannot resolve javax.servlet
→ Thêm Servlet API vào Build Path (có sẵn trong Tomcat)

### JSON classes not found
→ Thêm json-xxx.jar hoặc gson-xxx.jar vào WEB-INF/lib

### 404 Error
→ Kiểm tra URL mapping trong web.xml và context path

---

## Link tải nhanh

1. MySQL Connector: https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar
2. JSON: https://repo1.maven.org/maven2/org/json/json/20230227/json-20230227.jar
3. JSTL: https://repo1.maven.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.jar
4. Gson: https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar
