<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*, java.text.NumberFormat"%>
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

<title>Administrator: View Sales Report</title>
</head>
<body>

<form method="post" action="AdminSalesReportSelection.jsp">
	<input type="submit" value="View a different sales report">
</form>

<form method="post" action="AdminDashboard.jsp">
	<input type="submit" value="Go back to administrator dashboard">
</form>

<h2>You are currently viewing a sales report for:</h2>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();


String selectTickets = ""; 
String selectReservations = "";
PreparedStatement ps;
ResultSet result;
PreparedStatement psTickets = con.prepareStatement(selectTickets);
PreparedStatement psReservations = con.prepareStatement(selectReservations);
//we give select and ps empty values for now so that their are no compile errors

//based on which parameter is not null, we will set the select string to an appropriate query, then feed it into the prepared statement
boolean isAirline = request.getParameter("airlineCompany") != null;
boolean isFlight = request.getParameter("flightNumber") != null;
boolean isCustomer = request.getParameter("userID") != null;
boolean isMonth = request.getParameter("date") != null;

//each option should assign select to a string for both queries (tickets and reservations), initialize ps, and set the appropriate parameters
if(isAirline) {
	String airlineCompany = request.getParameter("airlineCompany");
	
	selectTickets = "SELECT * FROM OnlineResTravelSystem.Flight NATURAL JOIN OnlineResTravelSystem.Flight_Ticket NATURAL JOIN OnlineResTravelSystem.Airline_Company WHERE 2_letter_ID = ?";
	psTickets = con.prepareStatement(selectTickets);
	psTickets.setString(1,airlineCompany);
	
	selectReservations = "SELECT * FROM OnlineResTravelSystem.Flight NATURAL JOIN OnlineResTravelSystem.Reservations NATURAL JOIN OnlineResTravelSystem.Airline_Company WHERE 2_letter_ID = ?";
	psReservations = con.prepareStatement(selectTickets);
	psReservations.setString(1,airlineCompany);
	
	//display the selected airline company at the top of the page
	ps = con.prepareStatement("SELECT * FROM OnlineResTravelSystem.Airline_Company WHERE 2_letter_ID = ?");
	ps.setString(1,airlineCompany);
	result = ps.executeQuery();
	result.next();
	String airlineName = result.getString("CompName");
	String country = result.getString("Country");
	out.println(airlineCompany + " - " + airlineName + " (" + country + ")");
	result.close();
	ps.close();
}
else if(isFlight) {
	int flightNumber = Integer.parseInt(request.getParameter("flightNumber"));
	
	selectTickets = "SELECT * FROM OnlineResTravelSystem.Flight NATURAL JOIN OnlineResTravelSystem.Flight_Ticket WHERE flight_number = ?";
	psTickets = con.prepareStatement(selectTickets);
	psTickets.setInt(1,flightNumber);
	
	selectReservations = "SELECT * FROM OnlineResTravelSystem.Reservation NATURAL JOIN OnlineResTravelSystem.Flight WHERE flight_number = ?";
	psReservations = con.prepareStatement(selectReservations);
	psReservations.setInt(1,flightNumber);
	
	//display the selected flight at the top of the page
	String select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE flight_number = ?";
	ps = con.prepareStatement(select);
	ps.setInt(1,flightNumber);
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


	out.print("Flight Number: " + flight_number + " Date of Flight: " + date_of_flight + " Departure Time: " + departure_time + " Arrival Time: " + arrival_time + " Departure Airport ID: " + departure_airport_ID + " Arrival_Airport_ID: " + arrival_airport_ID); 
	result.close();
	ps.close();
}
else if(isCustomer) {
	int userID = Integer.parseInt(request.getParameter("userID"));
	
	selectTickets = "SELECT * FROM OnlineResTravelSystem.User NATURAL JOIN OnlineResTravelSystem.Flight_Ticket WHERE User_ID = ?";
	psTickets = con.prepareStatement(selectTickets);
	psTickets.setInt(1,userID);
	
	selectReservations = "SELECT * FROM OnlineResTravelSystem.Reservation NATURAL JOIN OnlineResTravelSystem.User WHERE User_ID = ?";
	psReservations = con.prepareStatement(selectReservations);
	psReservations.setInt(1,userID);
	
	//display the selected customer at the top of the page

	ps = con.prepareStatement("SELECT * FROM OnlineResTravelSystem.User WHERE User_ID = ?");
	ps.setInt(1,userID);
	ResultSet currentInfo = ps.executeQuery();
	currentInfo.next();
	out.println(currentInfo.getString("First_Name") + " " + currentInfo.getString("Last_Name") + " - " + currentInfo.getString("Username"));
	currentInfo.close();
	ps.close();
}
else if(isMonth) {
	//java.sql.Date month = request.getParameter("date");
	selectTickets = "SELECT * FROM OnlineResTravelSystem.Flight_Ticket WHERE purchase_date LIKE ?";
	psTickets = con.prepareStatement(selectTickets);
	psTickets.setString(1,request.getParameter("date")+"-%");
	
	selectReservations = "SELECT * FROM OnlineResTravelSystem.Reservation WHERE purchase_date LIKE ?";
	psReservations = con.prepareStatement(selectReservations);
	psReservations.setString(1,request.getParameter("date")+"-%");
	
	//display the month/year at the top of the page
	out.println(request.getParameter("date"));
}
else {
	
}

ResultSet tickets = psTickets.executeQuery();
ResultSet reservations = psReservations.executeQuery();
%>

<br>
<br>
<table border = "1">

<tr>
	
	<td>Username</td>
	<td>Flight Number</td>
	<td>Ticket Number</td>
	<td>Ticket Cost</td>
	<td>Booking Fee</td>
</tr>

<%
Double totalFlightRevenue = 0.0;
ResultSet temp;//use when you have to query
while(tickets.next()) {
	
	out.println("<tr>");
	
	//Username
	int userID = tickets.getInt("User_ID");
	ps = con.prepareStatement("SELECT Username FROM OnlineResTravelSystem.User WHERE User_ID = ?");
	ps.setInt(1,userID);
	temp = ps.executeQuery();
	temp.next();
	out.println("<td>" + temp.getString("Username") + "</td>");
	temp.close();
	
	//Flight Number and airline company
	int flightNumber = tickets.getInt("flight_number");
	ps = con.prepareStatement("SELECT 2_letter_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = ?");
	ps.setInt(1,flightNumber);
	temp = ps.executeQuery();
	temp.next();
	out.println("<td>" + temp.getString("2_letter_ID") + " " + tickets.getInt("flight_number") + "</td>");
	temp.close();
	
	//Ticket number
	out.println("<td>" + tickets.getString("ticket_number") + "</td>");
	
	//Ticket Cost
	out.println("<td>$" + tickets.getString("total_fare") + "</td>");
	totalFlightRevenue += Double.parseDouble(tickets.getString("total_fare"));
	
	//Booking Fee
	out.println("<td>$15</td>");
	totalFlightRevenue += 15.0;
	
	out.println("</tr>");
}


%>

</table>
<br>
Revenue from flights:
<%
NumberFormat formatter = NumberFormat.getCurrencyInstance();
out.println(formatter.format(totalFlightRevenue));

%>


<br>
<br>
<table border = "1">

<tr>
	<td>Username</td>
	<td>Flight Number</td>
	<td>Reservation Fee</td>
</tr>
<%
Double totalResRevenue = 0.0;
while(reservations.next()) {
	
	out.println("<tr>");
	
	//Username
	int userID = reservations.getInt("User_ID");
	ps = con.prepareStatement("SELECT Username FROM OnlineResTravelSystem.User WHERE User_ID = ?");
	ps.setInt(1,userID);
	temp = ps.executeQuery();
	temp.next();
	out.println("<td>" + temp.getString("Username") + "</td>");
	temp.close();
	
	//Flight Number and airline company
	int flightNumber = reservations.getInt("flight_number");
	ps = con.prepareStatement("SELECT 2_letter_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = ?");
	ps.setInt(1,flightNumber);
	temp = ps.executeQuery();
	temp.next();
	out.println("<td>" + temp.getString("2_letter_ID") + " " + reservations.getInt("flight_number") + "</td>");
	temp.close();
	
	//Reservation Fee
	out.println("<td>$25</td>");
	totalResRevenue += 25.0;
	
	out.println("</tr>");
}


%>


</table>
<br>
Revenue from reservations: <%out.print(formatter.format(totalResRevenue)); %>
<br><br><b>
Total revenue: <%out.print(formatter.format(totalFlightRevenue + totalResRevenue)); %>
</b>
<%
con.close();
%>
</body>
</html>