<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*" import="java.text.SimpleDateFormat"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<meta charset="UTF-8">
<style> 

body {
  background-image: url("CloudImage.jpeg");
  background-repeat: no-repeat;
  background-size: cover;
  background-position: fixed;
  background-top:0;
  background-left:0;
  background-min-width: 100%;
  background-min-height: 100%;
  
}
h1 {
    color: #0074D9;
      font-family: geometric sans-serif;
      font-size: 200%;
      text-align: right;
      
}
h2 {
    color: #0074D9;
      font-family: geometric sans-serif;
      font-size: 200%;
      text-align: left;
      
}
p {
    font-size: 200%;
    text-align: left;
}
input {
    background-color: transparent;
    font-family: geometric sans-serif;
    font-size: 90%;
    border-style: solid;
      border-width: 1px;
      border-color: black;
}
div {
    text-align:right; 
}
hr {
border-color: black;
}
option {
font-family: geometric sans-serif;
font-size: 150%;
}

</style>
<title>Confirmation</title>
</head>
<body>


<%
int flightNumber = Integer.parseInt((String)session.getAttribute("session_flight_number"));
out.println("Flight Number: " + flightNumber);
String dateOfFlight;
String domestic;
String daysOfOperation;
String roundTrip;
String aircraftID;
String companyID;
String departureTime;
String arrivalTime;
String departureAirportID;
String arrivalAirportID;
double flightPrice;

dateOfFlight = request.getParameter("flightDate");

domestic = request.getParameter("domestic");
roundTrip = request.getParameter("roundTrip");
aircraftID = request.getParameter("aircraft");
companyID = request.getParameter("airlineCompany");

departureTime = request.getParameter("departureTime");

arrivalTime = request.getParameter("arrivalTime");

departureAirportID = request.getParameter("departingAirport");
arrivalAirportID = request.getParameter("arrivalAirport");

//for days of operation, it's 7 characters of 0's and 1's

char[] days = {'0','0','0','0','0','0','0'};
if(request.getParameter("monday")!=null) {
    days[0] = '1';
}
if(request.getParameter("tuesday")!=null) {
    days[1] = '1';
}
if(request.getParameter("wednesday")!=null) {
    days[2] = '1';
}
if(request.getParameter("thursday")!=null) {
    days[3] = '1';
}
if(request.getParameter("friday")!=null) {
    days[4] = '1';
}
if(request.getParameter("saturday")!=null) {
    days[5] = '1';
}
if(request.getParameter("sunday")!=null) {
    days[6] = '1';
}
daysOfOperation = String.valueOf(days);

flightPrice = Double.parseDouble(request.getParameter("flightPrice"));

ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

try {
    ps = con.prepareStatement("UPDATE OnlineResTravelSystem.Flight SET date_of_flight = ?," + 
"domestic_or_international = ?,days_of_operation = ?,round_trip_or_one_way = ?,aircraft_ID = ?,2_letter_ID = ?,departure_time = ?," +
    "arrival_time = ?, departure_airport_ID = ?, arrival_airport_ID = ?, price = ? WHERE flight_number = ?");
    ps.setDate(1,java.sql.Date.valueOf(dateOfFlight));
    if(domestic.equals("domestic")) {
        ps.setInt(2,0);
    }
    else {
        ps.setInt(2,1);
    }
    ps.setString(3,daysOfOperation);
    if(roundTrip.equals("roundTrip")) {
        ps.setInt(4,0);
    }
    else {
        ps.setInt(4,1);
    }
    ps.setInt(5,Integer.parseInt(aircraftID));
    ps.setString(6,companyID);
    ps.setTime(7,Time.valueOf(departureTime+":00"));
    ps.setTime(8,Time.valueOf(arrivalTime+":00"));
    ps.setString(9,departureAirportID);
    ps.setString(10,arrivalAirportID);
    ps.setDouble(11, flightPrice);
    ps.setInt(12,flightNumber);
    
    ps.executeUpdate();
    ps.close();
    out.println("<br>Flight update successful.<br><br>");
}
catch (Exception e) {
    response.sendRedirect("ErrorPage.jsp");
}
%>

<form method = "post" action = "ChooseFlightToEdit.jsp">
<input type = "submit" value = "Edit another flight">
</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

<%
con.close();
%>

</body>
</html>
