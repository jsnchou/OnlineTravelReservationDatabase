<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<style>
body {
  	background-image: url("CloudImage.jpeg");
  	background-repeat: no-repeat;
  	background-size: cover;
  	text-align: center;
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
  	text-align: center;
}

p{
	font-size: 200%;
}
input{
	background-color: transparent;
	font-family: geometric sans-serif;
	font-size: 75%;
}

</style>

<title></title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

%>

<form method="post" action="AdminDashboard.jsp">
	<input type="submit" value="Go back to administrator dashboard">
</form>

<%
String airportID = request.getParameter("Airport");
			/*
ps = con.prepareStatement("SELECT * FROM OnlineResTravelSystem.Airports WHERE 3_letter_ID = ?");
ps.setString(1,airportID);
result = ps.executeQuery();
result.next();
String airportName = result.getString("AirportName");
String country = result.getString("Country");
out.println("<h2>Flights for: " + airportID + " - " + airportName + " (" + country + ")");*/

String numFlights = request.getParameter("numFlights");

ps = con.prepareStatement("SELECT * FROM OnlineResTravelSystem.Flight NATURAL JOIN OnlineResTravelSystem.Flight_Ticket GROUP BY flight_number ORDER BY COUNT(flight_number) DESC LIMIT ?");
ps.setInt(1,Integer.parseInt(numFlights));


result = ps.executeQuery();
%>

<table border="1">

<tr>
	<td>Airline Company/Flight Number</td>
	<td>Date of Flight</td>
	<td>Departure Airport</td>
	<td>Arrival Airport</td>
	<td>Departure Time</td>
	<td>Arrival Time</td>
	<td>Aircraft Name</td>
	<td>Days of Operation</td>
	<td>Round Trip or One Way</td>
	<td>Domestic or International</td>
</tr>



<%
while(result.next()) {
	out.println("<tr>");
	
	int flightNumber = result.getInt("flight_number");
	java.sql.Date dateOfFlight = result.getDate("date_of_flight");
	String domesticInternational = result.getString("domestic_or_international");
	String daysOfOperation = result.getString("days_of_operation");
	String roundTripOneWay = result.getString("round_trip_or_one_way");
	int aircraftID = result.getInt("aircraft_ID");
	String companyID = result.getString("2_letter_ID");
	Time arrivalTime = result.getTime("arrival_time");
	Time departureTime = result.getTime("departure_time");
	String departureAirportID = result.getString("departure_airport_ID");
	String arrivalAirportID = result.getString("arrival_airport_ID");
	
	String output = "";
	ResultSet result2;
	
	//airline company/flight number
	output = companyID + " " + flightNumber;
	out.println("<td>" + output + "</td>");
	
	//date of flight
	output = dateOfFlight.toString();
	out.println("<td>" + output + "</td>");
	
	//departure airport
	ps = con.prepareStatement("SELECT AirportName FROM OnlineResTravelSystem.Airports WHERE 3_letter_ID = ?");
	ps.setString(1,departureAirportID);
	result2 = ps.executeQuery();
	result2.next();
	output = result2.getString(1);
	out.println("<td>" + output + "</td>");
	
	//arrival airport
	ps = con.prepareStatement("SELECT AirportName FROM OnlineResTravelSystem.Airports WHERE 3_letter_ID = ?");
	ps.setString(1,arrivalAirportID);
	result2 = ps.executeQuery();
	result2.next();
	output = result2.getString(1);
	out.println("<td>" + output + "</td>");
	
	//departure time
	output = departureTime.toString();
	out.println("<td>" + output + "</td>");
	
	//arrival time
	output = arrivalTime.toString();
	out.println("<td>" + output + "</td>");
	
	//aircraft name
	ps = con.prepareStatement("SELECT aircraft_name FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = ?");
	ps.setInt(1,aircraftID);
	result2 = ps.executeQuery();
	result2.next();
	output = result2.getString(1);
	out.println("<td>" + output + "</td>");
	
	//days of operation
	output = "";
	if(daysOfOperation.charAt(0) == '1') {
		output += ", Mon";
	}
	if(daysOfOperation.charAt(1) == '1') {
		output += ", Tue";
	}
	if(daysOfOperation.charAt(2) == '1') {
		output += ", Wed";
	}
	if(daysOfOperation.charAt(3) == '1') {
		output += ", Thurs";
	}
	if(daysOfOperation.charAt(4) == '1') {
		output += ", Fri";
	}
	if(daysOfOperation.charAt(5) == '1') {
		output += ", Sat";
	}
	if(daysOfOperation.charAt(6) == '1') {
		output += ", Sun";
	}
	if(output.length() > 0) {
		output = output.substring(2);
	}
	out.println("<td>" + output + "</td>");
	
	//round trip or one way
	if(roundTripOneWay.charAt(0) == '0') {
		output = "Round Trip";
	}
	else {
		output = "One Way";
	}
	out.println("<td>" + output + "</td>");
	
	//domestic or international
	if(domesticInternational.charAt(0) == '0') {
		output = "Domestic";
	}
	else {
		output = "International";
	}
	out.println("<td>" + output + "</td>");
	
	out.println("</tr>");
}
result.close();
ps.close();
con.close();
%>

</table>

</body>
</html>