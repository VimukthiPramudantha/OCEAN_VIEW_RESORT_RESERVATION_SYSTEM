<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Availability - ${yearMonth}</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f8fbff; padding: 30px; }
        h1 { text-align: center; color: #0077b6; }
        .nav { text-align: center; margin: 20px 0; font-size: 1.3rem; }
        .nav a { margin: 0 20px; color: #0077b6; text-decoration: none; }
        .calendar {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 8px;
            max-width: 1100px;
            margin: 0 auto;
        }
        .day {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
            min-height: 120px;
        }
        .day-header { font-weight: bold; text-align: center; background: #f0f8ff; padding: 10px; border-radius: 6px; }
        .day-number { font-size: 1.4rem; text-align: center; margin-bottom: 6px; }
        .available { background: #e6ffe6; border-color: #b3ffb3; }
        .booked   { background: #ffe6e6; border-color: #ffb3b3; }
        .partial  { background: #fff3cd; border-color: #ffecb3; }
        .room-list { font-size: 0.9rem; margin-top: 6px; }
        .other-month { opacity: 0.5; }
    </style>
</head>
<body>

<h1>Room Availability - <fmt:formatDate value="${firstDayOfMonth}" pattern="MMMM yyyy"/></h1>

<div class="nav">
    <a href="?month=${yearMonth.minusMonths(1)}">&lt; Previous</a>
    <strong><fmt:formatDate value="${firstDayOfMonth}" pattern="MMMM yyyy"/></strong>
    <a href="?month=${yearMonth.plusMonths(1)}">Next &gt;</a>
</div>

<div class="calendar">
    <!-- Weekday headers -->
    <div class="day-header">Sun</div>
    <div class="day-header">Mon</div>
    <div class="day-header">Tue</div>
    <div class="day-header">Wed</div>
    <div class="day-header">Thu</div>
    <div class="day-header">Fri</div>
    <div class="day-header">Sat</div>

    <c:forEach var="date" items="${calendarDays}">
        <c:set var="rooms" value="${availability[date]}" />
        <c:set var="isCurrentMonth" value="${date.month == yearMonth.month}" />

        <!-- Determine day class using choose/when (no streams in EL) -->
        <c:set var="dayClass" value="available" />
        <c:if test="${not empty rooms and not empty rooms}">
            <c:set var="hasAvailable" value="false" />
            <c:set var="allAvailable" value="true" />

            <c:forEach var="room" items="${rooms}">
                <c:if test="${room.status eq 'available'}">
                    <c:set var="hasAvailable" value="true" />
                </c:if>
                <c:if test="${room.status ne 'available'}">
                    <c:set var="allAvailable" value="false" />
                </c:if>
            </c:forEach>

            <c:choose>
                <c:when test="${allAvailable}">
                    <c:set var="dayClass" value="available" />
                </c:when>
                <c:when test="${hasAvailable}">
                    <c:set var="dayClass" value="partial" />
                </c:when>
                <c:otherwise>
                    <c:set var="dayClass" value="booked" />
                </c:otherwise>
            </c:choose>
        </c:if>

        <div class="day ${dayClass} ${!isCurrentMonth ? 'other-month' : ''}">
                ${date.dayOfMonth}

            <c:if test="${not empty rooms}">
                <div class="room-list">
                    <c:forEach var="room" items="${rooms}">
                        <div>${room.roomId} (${room.roomType}) - ${room.status}</div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </c:forEach>
</div>

<a href="dashboard" style="display:block; text-align:center; margin-top:40px;">Back to Dashboard</a>

</body>
</html>