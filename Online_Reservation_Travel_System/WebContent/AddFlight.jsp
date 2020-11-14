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
<title>Add Flight</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;
%>

<form method = "post" action = "AddFlightDB.jsp">

Airline Company: 
<select name = "airlineCompany">
<%
select = "SELECT CompName,2_letter_ID FROM OnlineResTravelSystem.Airline_Company";
ps = con.prepareStatement(select);
result = ps.executeQuery();

while(result.next()) {
	String compName = result.getString("compName");
	String id = result.getString("2_letter_ID");
	out.print("<option value = \"" + id + "\">" + id + " - " + compName + "</option>"); 
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

Departure time (hh:mm):
<input type = "text" name = "departureTime" required="required">
Arrival time (hh:mm):
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


<input type = "submit" value = "Add new flight!">

</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

<%
con.close();
%>

</body>
</html>