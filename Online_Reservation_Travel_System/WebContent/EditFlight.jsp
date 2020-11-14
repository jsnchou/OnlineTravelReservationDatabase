<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
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
h3 {
	color: #000000;
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
<title>Edit Flight</title>
</head>
<body>

<%

ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE flight_number = ?";
ps = con.prepareStatement(select);
ps.setInt(1,Integer.parseInt(request.getParameter("flight_number")));
result = ps.executeQuery();
result.next();
String flight_number = result.getString("flight_number");
String date_of_flight = result.getString("date_of_flight");
String domestic_or_international = result.getString("domestic_or_international");
String days_of_operation = result.getString("days_of_operation");
String round_trip_or_one_way = result.getString("round_trip_or_one_way");
String aircraft_ID = result.getString("aircraft_ID");
String two_letter_ID = result.getString("2_letter_ID");
String arrival_time = result.getString("arrival_time");
String departure_time = result.getString("departure_time");
String departure_airport_ID = result.getString("departure_airport_ID");
String arrival_airport_ID = result.getString("arrival_airport_ID");

result.close();
ps.close();

out.print("<b>You are currently editing:<br>" + "Flight Number: " + flight_number + " Date of Flight: " + date_of_flight + " Departure Time: " + departure_time + " Arrival Time: " + arrival_time + " Departure Airport ID: " + departure_airport_ID + " Arrival_Airport_ID: " + arrival_airport_ID +"</b><br><br>"); 

session.setAttribute("session_flight_number",request.getParameter("flight_number"));

%>

<form method = "post" action = "EditFlightDB.jsp">

Airline Company: 
<select name = "airlineCompany">
<%
select = "SELECT CompName,2_letter_ID FROM OnlineResTravelSystem.Airline_Company";
ps = con.prepareStatement(select);
result = ps.executeQuery();

while(result.next()) {
	String compName = result.getString("compName");
	String id = result.getString("2_letter_ID");
	String s = "<option value = \"" + id + "\"";
	
	s = s + ">" + id + " - " + compName + "</option>";
	out.print(s); 
}
result.close();
ps.close();
%>
</select>

<br>
Flight Date (yyyy-mm-dd):
<input type = "text" name = "flightDate" required="required">

<br>
Departing from:
<select name = "departingAirport">
<%
select = "SELECT 3_letter_ID,AirportName FROM OnlineResTravelSystem.Airports";
ps = con.prepareStatement(select);
result = ps.executeQuery();
while(result.next()) {
	String airportName = result.getString("AirportName");
	String id = result.getString("3_letter_ID");
	out.print("<option value = \"" + id + "\">" + id + " - " + airportName + "</option>"); 
	
}
result.close();
ps.close();
%>
</select>

Arriving at:
<select name = "arrivalAirport">
<%
select = "SELECT 3_letter_ID,AirportName FROM OnlineResTravelSystem.Airports";
ps = con.prepareStatement(select);
result = ps.executeQuery();
while(result.next()) {
	String airportName = result.getString("AirportName");
	String id = result.getString("3_letter_ID");
	out.print("<option value = \"" + id + "\">" + id + " - " + airportName + "</option>"); 
}
result.close();
ps.close();
%>
</select>

<br>
Departure time:
<input type = "text" name = "departureTime" required="required">
Arrival time:
<input type = "text" name = "arrivalTime" required="required">

<br>

Price: <input type = "text" name = "flightPrice" required="required">

<br>
Choose an aircraft for this flight:
<select name = "aircraft">
<%
select = "SELECT aircraft_ID,aircraft_name FROM OnlineResTravelSystem.Aircrafts";
ps = con.prepareStatement(select);
result = ps.executeQuery();
while(result.next()) {
	
	String id = result.getString("aircraft_id");
	String name = result.getString("aircraft_name");
	out.print("<option value = \"" + id + "\">" + name + "</option>"); 
}
result.close();
ps.close();
%>
</select>

<br>
Days of operation:<br>
<input type = "checkbox" name = "monday" value = "monday">Monday<br>
<input type = "checkbox" name = "tuesday" value = "tuesday">Tuesday<br>
<input type = "checkbox" name = "wednesday" value = "wednesday">Wednesday<br>
<input type = "checkbox" name = "thursday" value = "thursday">Thursday<br>
<input type = "checkbox" name = "friday" value = "friday">Friday<br>
<input type = "checkbox" name = "saturday" value = "saturday">Saturday<br>
<input type = "checkbox" name = "sunday" value = "sunday">Sunday<br>

<br>
<input type = "radio" name = "roundTrip" value = "roundTrip" checked>Round Trip<br>
<input type = "radio" name = "roundTrip" value = "oneWay">One Way<br>

<br>
<input type = "radio" name = "domestic" value = "domestic" checked>Domestic<br>
<input type = "radio" name = "domestic" value = "international">International<br>


<input type = "submit" value = "Edit flight!">

</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

<%
con.close();
%>

</body>
</html>