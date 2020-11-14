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
  	text-align: left;
  	
}
h2 {
	color: #0074D9;
  	font-family: geometric sans-serif;
  	font-size: 200%;
  	text-align: left;
}
table{
border: solid black;
}

tr {
border: solid black;
}

td{
text-align: center;
}

div {
	text-align: center;
	
	height: 50px;

}
input {

font-family: geometric sans-serif;
	text-size: 200%;
background-color: transparent;

}
button {
background-color: transparent;
font-weight: bold;
}




</style>
<title>Customer Rep Finding One-Way Flights</title>
</head>
<body>
<button onclick="history.back()">GO BACK</button>


<form method = "post" action = "CRBookOrReserveOneWayTrip.jsp">

<%

	String OrderBy = request.getParameter("OrderBy");
	
	String filterPriceCheck = request.getParameter("FilterByPriceCheck");
	String FliterPrice = request.getParameter("FilterByPrice");
	
	String filterAirCompCheck = request.getParameter("FilterByCompNameCheck");
	String AirComp = request.getParameter("AirComp");

	// list all the global variables that need to be used in order to find the flights
	String DepartureDate = null;
	
	String DepartureCountry = null;
	String DeparutreCountryID = null;
	
	String ArrivalCountry = null;
	String ArrivalCountryID = null;
	
	// variables used to connect to the DB and send SQL quereies
	ApplicationDB db;
	Connection con;
	Statement stmt;
	String select;
	PreparedStatement ps;
	ResultSet result;
	
	
	try {
		
		if (OrderBy != null) {

			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			
			//check the dates to make sure that they are in the right format
			java.sql.Date.valueOf(DepartureDate);
		
			//grab the Departure country ID from the customer
			DeparutreCountryID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalCountryID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND ( (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\")) ORDER BY "+ OrderBy +"";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					//check the results
					if (result.next() == false) {
						out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
						// make a back button to the previous page for the user to search for flights ... 
						
					} else {
						// make a table of the flights that have been found
						out.print("<h1> Here are your results:</h1>"); 
						%>
						<table border = "1">
						
						<tr> 
							<th>Flight Number</th>
							<th>Date Of Flight</th>
							<th>Domestic(0) / International(1)</th>
							<th>Days of Operation</th>
							<th>Round-Trip(0) / One-Way(1)</th>
							<th>Aircraft ID</th>
							<th>Airline Company ID</th>
							<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
							<th>Arrival Time</th>
							<th>Departure Airport ID</th>
							<th>Arrival Airport ID</th>
							<th>Price</th>
							<th>Choice</th>
						</tr>
						
						<%
						out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
						out.print("<br><b>You may choose one of the flights.</b>");
						do {	
						%>
					
						<tr>
							<td><%out.print(result.getString(1));%></td>
							<td><%out.print(result.getString(2));%></td>
							<td><%out.print(result.getString(3));%></td>
							<td><%out.print(result.getString(4));%></td>
							<td><%out.print(result.getString(5));%></td>
							<td><%out.print(result.getString(6));%></td>
							<td><%out.print(result.getString(7));%></td>
							<td><%out.print(result.getString(9));%></td>
							<td><%out.print(result.getString(8));%></td>
							<td><%out.print(result.getString(10));%></td>
							<td><%out.print(result.getString(11));%></td>
							<td><%out.print(result.getString(12));%></td>
							<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>	
						</tr>
									
					<%			
						} while (result.next());
					%> </table> <%
						
					out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
					}
					
					//make sure to close the connection to the DB
					result.close();
					ps.close();
					stmt.close();
					con.close();	
			
		} else if (filterPriceCheck != null) {
			
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			
			//check the dates to make sure that they are in the right format
			java.sql.Date.valueOf(DepartureDate);
		
			//grab the Departure country ID from the customer
			DeparutreCountryID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalCountryID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND ( (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\")) AND price <= "+ FliterPrice +" ORDER BY price";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					//check the results
					if (result.next() == false) {
						out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
						// make a back button to the previous page for the user to search for flights ... 
						
					} else {
						// make a table of the flights that have been found
						out.print("<h1> Here are your results:</h1>"); 
						%>
						<table border = "1">
						
						<tr> 
							<th>Flight Number</th>
							<th>Date Of Flight</th>
							<th>Domestic(0) / International(1)</th>
							<th>Days of Operation</th>
							<th>Round-Trip(0) / One-Way(1)</th>
							<th>Aircraft ID</th>
							<th>Airline Company ID</th>
							<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
							<th>Arrival Time</th>
							<th>Departure Airport ID</th>
							<th>Arrival Airport ID</th>
							<th>Price</th>
							<th>Choice</th>
						</tr>
						
						<%
						out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
						out.print("<br><b>You may choose one of the flights.</b>");
						do {	
						%>
					
						<tr>
							<td><%out.print(result.getString(1));%></td>
							<td><%out.print(result.getString(2));%></td>
							<td><%out.print(result.getString(3));%></td>
							<td><%out.print(result.getString(4));%></td>
							<td><%out.print(result.getString(5));%></td>
							<td><%out.print(result.getString(6));%></td>
							<td><%out.print(result.getString(7));%></td>
							<td><%out.print(result.getString(9));%></td>
							<td><%out.print(result.getString(8));%></td>
							<td><%out.print(result.getString(10));%></td>
							<td><%out.print(result.getString(11));%></td>
							<td><%out.print(result.getString(12));%></td>
							<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>	
						</tr>
									
					<%			
						} while (result.next());
					%> </table> <%
						
					out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
					}
					
					//make sure to close the connection to the DB
					result.close();
					ps.close();
					stmt.close();
					con.close();
			
		} else if (filterAirCompCheck != null) {
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			
			//check the dates to make sure that they are in the right format
			java.sql.Date.valueOf(DepartureDate);
		
			//grab the Departure country ID from the customer
			DeparutreCountryID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalCountryID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND ( (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\")) AND 2_letter_ID = '"+ AirComp +"' ORDER BY price ";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					//check the results
					if (result.next() == false) {
						out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
						// make a back button to the previous page for the user to search for flights ... 
						
					} else {
						// make a table of the flights that have been found
						out.print("<h1> Here are your results:</h1>"); 
						%>
						<table border = "1">
						
						<tr> 
							<th>Flight Number</th>
							<th>Date Of Flight</th>
							<th>Domestic(0) / International(1)</th>
							<th>Days of Operation</th>
							<th>Round-Trip(0) / One-Way(1)</th>
							<th>Aircraft ID</th>
							<th>Airline Company ID</th>
							<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
							<th>Arrival Time</th>
							<th>Departure Airport ID</th>
							<th>Arrival Airport ID</th>
							<th>Price</th>
							<th>Choice</th>
						</tr>
						
						<%
						out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
						out.print("<br><b>You may choose one of the flights.</b>");
						do {	
						%>
					
						<tr>
							<td><%out.print(result.getString(1));%></td>
							<td><%out.print(result.getString(2));%></td>
							<td><%out.print(result.getString(3));%></td>
							<td><%out.print(result.getString(4));%></td>
							<td><%out.print(result.getString(5));%></td>
							<td><%out.print(result.getString(6));%></td>
							<td><%out.print(result.getString(7));%></td>
							<td><%out.print(result.getString(9));%></td>
							<td><%out.print(result.getString(8));%></td>
							<td><%out.print(result.getString(10));%></td>
							<td><%out.print(result.getString(11));%></td>
							<td><%out.print(result.getString(12));%></td>
							<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>	
						</tr>
									
					<%			
						} while (result.next());
					%> </table> <%
						
					out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
					}
					
					//make sure to close the connection to the DB
					result.close();
					ps.close();
					stmt.close();
					con.close();
			
		} else {
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			
			//check the dates to make sure that they are in the right format
			java.sql.Date.valueOf(DepartureDate);
		
			//grab the Departure country ID from the customer
			DeparutreCountryID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalCountryID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND ( (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\") )";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					//check the results
					if (result.next() == false) {
						out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
						// make a back button to the previous page for the user to search for flights ... 
						
					} else {
						// make a table of the flights that have been found
						out.print("<h1> Here are your results:</h1>"); 
						%>
						<table border = "1">
						
						<tr> 
							<th>Flight Number</th>
							<th>Date Of Flight</th>
							<th>Domestic(0) / International(1)</th>
							<th>Days of Operation</th>
							<th>Round-Trip(0) / One-Way(1)</th>
							<th>Aircraft ID</th>
							<th>Airline Company ID</th>
							<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
							<th>Arrival Time</th>
							<th>Departure Airport ID</th>
							<th>Arrival Airport ID</th>
							<th>Price</th>
							<th>Choice</th>
						</tr>
						
						<%
						out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
						out.print("<br><b>You may choose one of the flights.</b>");
						do {	
						%>
					
						<tr>
							<td><%out.print(result.getString(1));%></td>
							<td><%out.print(result.getString(2));%></td>
							<td><%out.print(result.getString(3));%></td>
							<td><%out.print(result.getString(4));%></td>
							<td><%out.print(result.getString(5));%></td>
							<td><%out.print(result.getString(6));%></td>
							<td><%out.print(result.getString(7));%></td>
							<td><%out.print(result.getString(9));%></td>
							<td><%out.print(result.getString(8));%></td>
							<td><%out.print(result.getString(10));%></td>
							<td><%out.print(result.getString(11));%></td>
							<td><%out.print(result.getString(12));%></td>
							<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>	
						</tr>
									
					<%			
						} while (result.next());
					%> </table> <%
						
					out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
					}
					
					//make sure to close the connection to the DB
					result.close();
					ps.close();
					stmt.close();
					con.close();	
		
		} // ends the main if-else-if statements
		
		
		
	} catch (Exception e) {
		
		
		if (OrderBy != null) {
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			
			//grab the Departure country ID from the customer
			DeparutreCountryID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalCountryID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE ( (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\") ) ORDER BY "+ OrderBy +"";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					//check the results
					if (result.next() == false) {
						out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
						// make a back button to the previous page for the user to search for flights ... 
						
					} else {
						// make a table of the flights that have been found
						out.print("<h1> Here are your results:</h1>"); 
						%>
						<table border = "1">
						
						<tr> 
							<th>Flight Number</th>
							<th>Date Of Flight</th>
							<th>Domestic(0) / International(1)</th>
							<th>Days of Operation</th>
							<th>Round-Trip(0) / One-Way(1)</th>
							<th>Aircraft ID</th>
							<th>Airline Company ID</th>
							<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
							<th>Arrival Time</th>
							<th>Departure Airport ID</th>
							<th>Arrival Airport ID</th>
							<th>Price</th>
							<th>Choice</th>
						</tr>
						
						<%
						out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
						out.print("<br><b>You may choose one of the flights.</b>");
						do {	
						%>
					
						<tr>
							<td><%out.print(result.getString(1));%></td>
							<td><%out.print(result.getString(2));%></td>
							<td><%out.print(result.getString(3));%></td>
							<td><%out.print(result.getString(4));%></td>
							<td><%out.print(result.getString(5));%></td>
							<td><%out.print(result.getString(6));%></td>
							<td><%out.print(result.getString(7));%></td>
							<td><%out.print(result.getString(9));%></td>
							<td><%out.print(result.getString(8));%></td>
							<td><%out.print(result.getString(10));%></td>
							<td><%out.print(result.getString(11));%></td>
							<td><%out.print(result.getString(12));%></td>
							<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>	
						</tr>
									
					<%			
						} while (result.next());
					%> </table> <%
						
					out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
					}
					
					//make sure to close the connection to the DB
					result.close();
					ps.close();
					stmt.close();
					con.close();	
			
		} else if (filterPriceCheck != null) {
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
		
			//grab the Departure country ID from the customer
			DeparutreCountryID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalCountryID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE ( (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\") ) AND price <= "+ FliterPrice +" ORDER BY price";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					//check the results
					if (result.next() == false) {
						out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
						// make a back button to the previous page for the user to search for flights ... 
						
					} else {
						// make a table of the flights that have been found
						out.print("<h1> Here are your results:</h1>"); 
						%>
						<table border = "1">
						
						<tr> 
							<th>Flight Number</th>
							<th>Date Of Flight</th>
							<th>Domestic(0) / International(1)</th>
							<th>Days of Operation</th>
							<th>Round-Trip(0) / One-Way(1)</th>
							<th>Aircraft ID</th>
							<th>Airline Company ID</th>
							<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
							<th>Arrival Time</th>
							<th>Departure Airport ID</th>
							<th>Arrival Airport ID</th>
							<th>Price</th>
							<th>Choice</th>
						</tr>
						
						<%
						out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
						out.print("<br><b>You may choose one of the flights.</b>");
						do {	
						%>
					
						<tr>
							<td><%out.print(result.getString(1));%></td>
							<td><%out.print(result.getString(2));%></td>
							<td><%out.print(result.getString(3));%></td>
							<td><%out.print(result.getString(4));%></td>
							<td><%out.print(result.getString(5));%></td>
							<td><%out.print(result.getString(6));%></td>
							<td><%out.print(result.getString(7));%></td>
							<td><%out.print(result.getString(9));%></td>
							<td><%out.print(result.getString(8));%></td>
							<td><%out.print(result.getString(10));%></td>
							<td><%out.print(result.getString(11));%></td>
							<td><%out.print(result.getString(12));%></td>
							<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>	
						</tr>
									
					<%			
						} while (result.next());
					%> </table> <%
						
					out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
					}
					
					//make sure to close the connection to the DB
					result.close();
					ps.close();
					stmt.close();
					con.close();	
			
			
		} else if (filterAirCompCheck != null) {
			
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			
			//grab the Departure country ID from the customer
			DeparutreCountryID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalCountryID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE ( (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\") ) AND 2_letter_ID = '"+ AirComp +"' ORDER BY price ";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					//check the results
					if (result.next() == false) {
						out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
						// make a back button to the previous page for the user to search for flights ... 
						
					} else {
						// make a table of the flights that have been found
						out.print("<h1> Here are your results:</h1>"); 
						%>
						<table border = "1">
						
						<tr> 
							<th>Flight Number</th>
							<th>Date Of Flight</th>
							<th>Domestic(0) / International(1)</th>
							<th>Days of Operation</th>
							<th>Round-Trip(0) / One-Way(1)</th>
							<th>Aircraft ID</th>
							<th>Airline Company ID</th>
							<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
							<th>Arrival Time</th>
							<th>Departure Airport ID</th>
							<th>Arrival Airport ID</th>
							<th>Price</th>
							<th>Choice</th>
						</tr>
						
						<%
						out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
						out.print("<br><b>You may choose one of the flights.</b>");
						do {	
						%>
					
						<tr>
							<td><%out.print(result.getString(1));%></td>
							<td><%out.print(result.getString(2));%></td>
							<td><%out.print(result.getString(3));%></td>
							<td><%out.print(result.getString(4));%></td>
							<td><%out.print(result.getString(5));%></td>
							<td><%out.print(result.getString(6));%></td>
							<td><%out.print(result.getString(7));%></td>
							<td><%out.print(result.getString(9));%></td>
							<td><%out.print(result.getString(8));%></td>
							<td><%out.print(result.getString(10));%></td>
							<td><%out.print(result.getString(11));%></td>
							<td><%out.print(result.getString(12));%></td>
							<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>	
						</tr>
									
					<%			
						} while (result.next());
					%> </table> <%
						
					out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
					}
					
					//make sure to close the connection to the DB
					result.close();
					ps.close();
					stmt.close();
					con.close();
			
			
		} else {
			
				// here the date was not given, thus we assume a flexible date and let the user decide what flights to book based only on the countries chosen
				//grab the Departure country ID from the customer
						DeparutreCountryID = request.getParameter("CountryOfDeparture");
						
						//grab the Departure country from the customer
						ArrivalCountryID = request.getParameter("CountryOfArrival");
						
						//connect to the database
								db = new ApplicationDB();	
								con = db.getConnection();

								//Create a SQL statement and execute
								stmt = con.createStatement();
								select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (departure_airport_ID = \"" + DeparutreCountryID + "\") AND (arrival_airport_ID = \"" + ArrivalCountryID + "\")";
								ps = con.prepareStatement(select);
								result = ps.executeQuery();
								
								//check the results
								if (result.next() == false) {
									out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
									// make a back button to the previous page for the user to search for flights ... 
									
								} else {
									// make a table of the flights that have been found
									%>
									<table border = "1">
									
									<tr> 
										<th>Flight Number</th>
										<th>Date Of Flight</th>
										<th>Domestic(0) / International(1)</th>
										<th>Days of Operation</th>
										<th>Round-Trip(0) / One-Way(1)</th>
										<th>Aircraft ID</th>
										<th>Airline Company ID</th>
										<th>Departure Time</th>						<!-- This is flipped in the DB so don't forget to change this when adding in values -->
										<th>Arrival Time</th>
										<th>Departure Airport ID</th>
										<th>Arrival Airport ID</th>
										<th>Price</th>
										<th>Choice</th>
									</tr>
									
									<%
									out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " </b>");
									out.print("<br><b>You may choose one of the flights.</b>");
									do {	
									%>
								
									<tr>
										<td><%out.print(result.getString(1));%></td>
										<td><%out.print(result.getString(2));%></td>
										<td><%out.print(result.getString(3));%></td>
										<td><%out.print(result.getString(4));%></td>
										<td><%out.print(result.getString(5));%></td>
										<td><%out.print(result.getString(6));%></td>
										<td><%out.print(result.getString(7));%></td>
										<td><%out.print(result.getString(9));%></td>
										<td><%out.print(result.getString(8));%></td>
										<td><%out.print(result.getString(10));%></td>
										<td><%out.print(result.getString(11));%></td>
										<td><%out.print(result.getString(12));%></td>
										<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>"></td>		
									</tr>
												
								<%			
									} while (result.next());
								%> </table> <%
								out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px; font-weight:bold;\"></div>");
								}
								
								//make sure to close the connection to the DB
								result.close();
								ps.close();
								stmt.close();
								con.close();
								
			} // ends the main if-else-if
		
	
	} // ends the catch
	
	out.print("<input name = \"CustomerToHelp\" type = \"hidden\" value = \""+request.getParameter("CustomerToHelp")+"\">");
	
%>

</form>

</body>
</html>