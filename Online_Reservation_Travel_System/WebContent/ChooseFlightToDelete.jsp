<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
<meta charset="ISO-8859-1">
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
<title>Delete Flight</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;
%>

<h2>Choose the flight to delete:</h2>
<form method = "post" action = "DeleteFlightDB.jsp">
<select name = "flight_number">
<%
select = "SELECT * FROM OnlineResTravelSystem.Flight";
ps = con.prepareStatement(select);
result = ps.executeQuery();

while(result.next()) {
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
	out.print("<option value = \"" + flight_number + "\">" + "Flight Number: " + flight_number + " Date of Flight: " + date_of_flight + " Departure Time: " + departure_time + " Arrival Time: " + arrival_time + " Departure Airport ID: " + departure_airport_ID + " Arrival_Airport_ID: " + arrival_airport_ID + "</option>"); 
}
result.close();
ps.close();
%>

</select>
<input type = "submit" value = "Select">
</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

<%
con.close();
%>

</body>
</html>