# Ocean View Resort Reservation System

Welcome to the **Ocean View Resort Reservation System**, a robust and user-friendly web application designed to manage hotel bookings, guest information, and room availability seamlessly.

## 🌟 Features

- **User Authentication**: Secure login and logout for administrators and staff.
- **Dashboard**: High-level overview of system activities and quick access to management tools.
- **Room Management**: Add, update, and manage room types, pricing, and availability.
- **Reservation System**: Create, search, update, and cancel reservations with ease.
- **Guest History**: Maintain detailed records of guests and their previous stays.
- **Checkout Process**: Streamlined checkout workflow with success notifications.
- **Search Functionality**: Advanced search for reservations and guest history.

## 🛠️ Tech Stack

- **Backend**: Java 17+ (Jakarta EE 10)
- **Web Framework**: Java Servlets & JSP (Jakarta Servlet 6.0)
- **Database**: MySQL 8.0+ / 9.1.0 (Connector/J)
- **Connection Pooling**: Tomcat JDBC Pool (JNDI)
- **Build Tool**: Maven
- **Testing**: JUnit 5, AssertJ, Mockito
- **Frontend**: HTML5, CSS3, JSTL

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- [JDK 17 or higher](https://www.oracle.com/java/technologies/downloads/)
- [Apache Tomcat 10.1.x](https://tomcat.apache.org/download-10.cgi)
- [MySQL Server](https://dev.mysql.com/downloads/mysql/)
- [Maven](https://maven.apache.org/download.cgi)

## 🚀 Setup & Installation

### 1. Clone the repository
```bash
git clone https://github.com/VimukthiPramudantha/OCEAN_VIEW_RESORT_RESERVATION_SYSTEM.git
cd OCEAN_VIEW_RESORT_RESERVATION_SYSTEM
```

### 2. Database Configuration
1. Log into your MySQL server.
2. Create a database named `hoteldb`:
   ```sql
   CREATE DATABASE hoteldb;
   ```
3. Update the database credentials in `src/main/webapp/META-INF/context.xml`:
   ```xml
   <Resource name="jdbc/hotelDB"
             username="your_username"
             password="your_password"
             ... />
   ```

### 3. Build the Project
Use Maven to build the WAR file:
```bash
mvn clean package
```

### 4. Deploy to Tomcat
- Copy the generated `resort.war` from the `target` directory to your Tomcat `webapps` folder.
- Start Tomcat. The application will be accessible at `http://localhost:8080/resort`.

## 📂 Project Structure

- `src/main/java`: Backend logic organized by package (`config`, `dao`, `model`, `servlet`).
- `src/main/webapp`: JSP pages, CSS, images, and configuration files (`META-INF`, `WEB-INF`).
- `pom.xml`: Project dependencies and build configuration.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---
Developed by [Vimukthi Pramudantha](https://github.com/VimukthiPramudantha)
