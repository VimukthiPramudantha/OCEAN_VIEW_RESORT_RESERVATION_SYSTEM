<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Availability - ${yearMonth}</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f8f9fa; }
        h1 { text-align: center; color: #0077b6; }
        .calendar { width: 100%; border-collapse: collapse; margin: 20px 0; background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .calendar th, .calendar td { border: 1px solid #ddd; padding: 8px; text-align: center; vertical-align: top; height: 100px; }
        .calendar th { background: #0077b6; color: white; }
        .day-header { font-weight: bold; background: #e9ecef; }
        .available { background: #d4edda; color: #155724; }
        .booked { background: #f8d7da; color: #721c24; }
        .checked-in { background: #fff3cd; color: #856404; }
        .day-number { font-size: 1.2em; font-weight: bold; margin-bottom: 6px; }
        .tooltip { position: relative; display: inline-block; cursor: pointer; }
        .tooltip .tooltiptext {
            visibility: hidden;
            width: 220px;
            background-color: #555;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 8px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            margin-left: -110px;
            opacity: 0;
            transition: opacity 0.3s;
        }
        .tooltip:hover .tooltiptext { visibility: visible; opacity: 1; }
        .nav { text-align: center; margin: 20px 0; font-size: 1.2em; }
        .nav a { margin: 0 20px; color: #0077b6; text-decoration: none; }
    </style>
</head>
<body>

<h1>Room Availability Calendar - ${yearMonth}</h1>

<div class="nav">
    <a href="?month=${yearMonth.minusMonths(1)}">&lt; Previous Month</a>
    <a href="?month=${YearMonth.now()}">Current Month</a>
    <a href="?month=${yearMonth.plusMonths(1)}">Next Month &gt;</a>
</div>

<table class="calendar">
    <thead>
    <tr>
        <th>Room</th>
        <c:forEach var="day" begin="1" end="${daysInMonth}">
            <th class="day-header">${day}</th>
        </c:forEach>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="room" items="${rooms}">
        <tr>
            <td style="font-weight:bold; background:#f1f3f5;">${room.type} - ${room.roomNumber}</td>
            <c:forEach var="day" begin="1" end="${daysInMonth}">
                <%
                    LocalDate currentDate = yearMonth.atDay(day);
                    Integer roomId = room.getId();
                    List<LocalDate> occupiedDates = occupancy.get(roomId);
                    String statusClass = "available";
                    String tooltip = "Available";

                    if (occupiedDates != null && occupiedDates.contains(currentDate)) {
                        statusClass = "booked";
                        tooltip = "Booked";
                        // Could fetch more details here if needed (guest name, nights, etc.)
                    }
                %>
                <td class="<%=statusClass%> tooltip">
                    <div class="day-number"><%=day%></div>
                    <span class="tooltiptext"><%=tooltip%></span>
                </td>
            </c:forEach>
        </tr>
    </c:forEach>
    </tbody>
</table>

<div style="text-align:center; margin-top:30px;">
    <a href="dashboard">Back to Dashboard</a>
</div>

</body>
</html>