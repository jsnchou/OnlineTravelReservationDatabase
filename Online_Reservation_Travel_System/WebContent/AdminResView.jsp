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

<title>Administrator: View Reservations</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();
String select = "SELECT * FROM OnlineResTravelSystem.Reservation NATURAL JOIN OnlineResTravelSystem.Flight NATURAL JOIN OnlineResTravelSystem.User WHERE ";
PreparedStatement ps = con.prepareStatement("");
ResultSet result;

%>

<form method="post" action="AdminRes.jsp">
	<input type="submit" value="View a different set of reservations">
</form>

<form method="post" action="AdminDashboard.jsp">
	<input type="submit" value="Go back to administrator dashboard">
</form>

<%
//determine if using flight number or customer name
String flightNum = request.getParameter("flightNumber");
if(flightNum != null) {
	//using flight number
	//display current flight
	int flightNumber = Integer.parseInt(request.getParameter("flightNumber"));
	out.println("<h2>You are currently viewing the reservations for:</h2>Flight Number: " + flightNumber);
	select = select + "flight_number = ?";
	ps = con.prepareStatement(select);
	ps.setInt(1,flightNumber);
}
else {
	//using customer name
	int id = Integer.parseInt(request.getParameter("id"));
	
	//get customer name from database
	ps = con.prepareStatement("SELECT * FROM OnlineResTravelSystem.User WHERE User_ID = ?");
	ps.setInt(1,id);
	result = ps.executeQuery();
	result.next();
	String firstName = result.getString("First_Name");
	String lastName = result.getString("Last_Name");
	String username = result.getString("Username");
	String output = firstName + " " + lastName + " (Username: " + username + ")";
	
	out.println("<h2>You are currently viewing the reservations for user:</h2>" + output);
	select = select + "User_ID = ?";
	ps.close();
	ps = con.prepareStatement(select);
	ps.setInt(1,id);
}

result = ps.executeQuery();


%>

<br>
<br>
<table border = "1">

<tr>
	<td>First Name</td>
	<td>Last Name</td>
	<td>Username</td>
	<td>Airline Company/Flight Number</td>
	<td>Date</td>
	<td>Departure Airport</td>
	<td>Arrival Airport</td>
	<td>Departure Time</td>
	<td>Arrival Time</td>
</tr>

<%
while(result.next()) {
	ResultSet result2;
	out.println("<tr>");
	
	//First name
	
	out.println("<td>" + result.getString("First_Name") + "</td>");
	
	//last name
	
	out.println("<td>" +  result.getString("Last_Name") + "</td>");

	//username
	
	out.println("<td>" + result.getString("Username") + "</td>");

	//airline company/flight number
	
	out.println("<td>" + result.getString("2_letter_ID") + " " + result.getString("flight_number") + "</td>");

	//date
	java.sql.Date dateOfFlight = result.getDate("date_of_flight");
	out.println("<td>" + dateOfFlight.toString() + "</td>");

	//departure airport
	String departureAirportID = result.getString("departure_airport_ID");
	ps = con.prepareStatement("SELECT AirportName FROM OnlineResTravelSystem.Airports WHERE 3_letter_ID = ?");
	ps.setString(1,departureAirportID);
	result2 = ps.executeQuery();
	result2.next();
	out.println("<td>" + result2.getString(1) + "</td>");
	result2.close();

	//arrival airport
	String arrivalAirportID = result.getString("arrival_airport_ID");
	ps = con.prepareStatement("SELECT AirportName FROM OnlineResTravelSystem.Airports WHERE 3_letter_ID = ?");
	ps.setString(1,arrivalAirportID);
	result2 = ps.executeQuery();
	result2.next();
	out.println("<td>" + result2.getString(1) + "</td>");
	result2.close();

	//departure time
	
	out.println("<td>" + result.getTime("departure_time").toString() + "</td>");

	//arrival time
	
	out.println("<td>" + result.getTime("arrival_time").toString() + "</td>");
	
	
	out.println("</tr>");
}

result.close();
ps.close();

%>


</table>

<%
con.close();
%>
</body>
</html>