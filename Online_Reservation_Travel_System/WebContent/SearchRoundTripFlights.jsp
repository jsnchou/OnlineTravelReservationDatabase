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
}



</style>
<title>Finding Round Trip Flights</title>
</head>
<body>

<button onclick="history.back()">GO BACK</button>

<form method = "post" action = "BookOrReserveRoundTrips.jsp"> 

	<%
	
	String OrderBy = request.getParameter("OrderBy");
	
	String filterPriceCheck = request.getParameter("FilterByPriceCheck");
	String FliterPrice = request.getParameter("FilterByPrice");

	// list all the global variables that need to be used in order to find the flights
	String DepartureDate = null;
	String ReturningDate = null;
	
	String DepartureAirport = null;
	String DeparutreAirportID = null;
	
	String ArrivalAirport = null;
	String ArrivalAirportID = null;
	
	// variables used to connect to the DB and send SQL quereies
	ApplicationDB db;
	Connection con;
	Statement stmt;
	String select;
	PreparedStatement ps;
	ResultSet result;
	
	boolean isThereFlight1 = false;
	boolean isThereFlight2 = false;
	
	try {
		
		if (OrderBy != null) {
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			ReturningDate = request.getParameter("returnDate");
			
			//check the dates to make sure that they are in the right format
			java.sql.Date.valueOf(DepartureDate);
			java.sql.Date.valueOf(ReturningDate);
		
			//grab the Departure country ID from the customer
			DeparutreAirportID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalAirportID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					
					// check to see if there are departing flights for that day
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND (departure_airport_ID = \"" + DeparutreAirportID + "\") AND (arrival_airport_ID = \"" + ArrivalAirportID + "\") ORDER BY "+ OrderBy +"";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					if (result.next() == false) {
						isThereFlight1 = false;
					} else {
						isThereFlight1 = true;
					}
					
					//check to see if there are returning flights for the day
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + ReturningDate + "\") AND (departure_airport_ID = \"" + ArrivalAirportID + "\") AND (arrival_airport_ID = \"" + DeparutreAirportID + "\") ORDER BY "+ OrderBy +"";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					if (result.next() == false) {
						isThereFlight2 = false;
					} else {
						isThereFlight2 = true;
					}
					
					if ((isThereFlight1 == true) && (isThereFlight2 == true)) {
						
						// check to see if there are departing flights for that day
						stmt = con.createStatement();
						select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND (departure_airport_ID = \"" + DeparutreAirportID + "\") AND (arrival_airport_ID = \"" + ArrivalAirportID + "\") ORDER BY "+ OrderBy +"";
						ps = con.prepareStatement(select);
						result = ps.executeQuery();
						
						out.print("<h2> Here are the departing flights:</h2>"); 
						//check the results
						if (result.next() == false) {
							out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>"); 
							
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
							out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreAirportID+ " | Arrival Country: " +ArrivalAirportID+ " | Departure Date: "+DepartureDate+ "  </b>");
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
								<td><input type="checkbox" name = "choice1" value = "<%out.print(result.getString(1));%>"></td>	
							</tr>
										
						<%			
							} while (result.next());
						%> 
						</table> 
						<%
							
						}
						//make sure to close the connection to the DB
						result.close();
						ps.close();
						stmt.close();
						con.close();
						
					//----------------------------------------------------------------------------------------------------------------------------------------------------------//		
					
						//connect to the database
						db = new ApplicationDB();	
						con = db.getConnection();

						//Create a SQL statement and execute
						stmt = con.createStatement();
						select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + ReturningDate + "\") AND (departure_airport_ID = \"" + ArrivalAirportID + "\") AND (arrival_airport_ID = \"" + DeparutreAirportID + "\") ORDER BY "+ OrderBy +"";
						ps = con.prepareStatement(select);
						result = ps.executeQuery();
						
						out.print("<h2> Here are the returning flights:</h2>");
						//check the results
						if (result.next() == false) {
							out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
							
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
							out.print("<br><b> Here are all the flights that match info given: Departure Country: " +ArrivalAirportID+ " | Arrival Country: " +DeparutreAirportID+ " | Returning Date: "+ReturningDate+ "  </b>");
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
								<td><input type="checkbox" name = "choice2" value = "<%out.print(result.getString(1));%>"></td>	
							</tr>
										
						<%			
							} while (result.next());
						%> </table> <%
							
						}
						
						//make sure to close the connection to the DB
						result.close();
						ps.close();
						stmt.close();
						con.close();
						
						
						out.print("<br><br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
						
						
						// cannot show any flights since we cannot provide BOTH a departure and returning flights
					} else {
						out.print("<h3> It seems that there are no flights available for the the departing and returning dates. Sorry for the inconvenience. Please try again later or talk to a Customer Representative to get this issue cleared.");
					}

			
		} else if(filterPriceCheck != null) {
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			ReturningDate = request.getParameter("returnDate");
			
			//check the dates to make sure that they are in the right format
			java.sql.Date.valueOf(DepartureDate);
			java.sql.Date.valueOf(ReturningDate);
		
			//grab the Departure country ID from the customer
			DeparutreAirportID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalAirportID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					
					// check to see if there are departing flights for that day
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND (departure_airport_ID = \"" + DeparutreAirportID + "\") AND (arrival_airport_ID = \"" + ArrivalAirportID + "\") AND price <= "+ FliterPrice +" ORDER BY price";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					if (result.next() == false) {
						isThereFlight1 = false;
					} else {
						isThereFlight1 = true;
					}
					
					//check to see if there are returning flights for the day
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + ReturningDate + "\") AND (departure_airport_ID = \"" + ArrivalAirportID + "\") AND (arrival_airport_ID = \"" + DeparutreAirportID + "\") AND price <= "+ FliterPrice +" ORDER BY price";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					if (result.next() == false) {
						isThereFlight2 = false;
					} else {
						isThereFlight2 = true;
					}
					
					if ((isThereFlight1 == true) && (isThereFlight2 == true)) {
						
						// check to see if there are departing flights for that day
						stmt = con.createStatement();
						select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND (departure_airport_ID = \"" + DeparutreAirportID + "\") AND (arrival_airport_ID = \"" + ArrivalAirportID + "\") AND price <= "+ FliterPrice +" ORDER BY price";
						ps = con.prepareStatement(select);
						result = ps.executeQuery();
						
						out.print("<h2> Here are the departing flights:</h2>"); 
						//check the results
						if (result.next() == false) {
							out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>"); 
							
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
							out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreAirportID+ " | Arrival Country: " +ArrivalAirportID+ " | Departure Date: "+DepartureDate+ "  </b>");
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
								<td><input type="checkbox" name = "choice1" value = "<%out.print(result.getString(1));%>"></td>	
							</tr>
										
						<%			
							} while (result.next());
						%> 
						</table> 
						<%
							
						}
						//make sure to close the connection to the DB
						result.close();
						ps.close();
						stmt.close();
						con.close();
						
					//----------------------------------------------------------------------------------------------------------------------------------------------------------//		
					
						//connect to the database
						db = new ApplicationDB();	
						con = db.getConnection();

						//Create a SQL statement and execute
						stmt = con.createStatement();
						select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + ReturningDate + "\") AND (departure_airport_ID = \"" + ArrivalAirportID + "\") AND (arrival_airport_ID = \"" + DeparutreAirportID + "\") AND price <= "+ FliterPrice +" ORDER BY price";
						ps = con.prepareStatement(select);
						result = ps.executeQuery();
						
						out.print("<h2> Here are the returning flights:</h2>");
						//check the results
						if (result.next() == false) {
							out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
							
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
							out.print("<br><b> Here are all the flights that match info given: Departure Country: " +ArrivalAirportID+ " | Arrival Country: " +DeparutreAirportID+ " | Returning Date: "+ReturningDate+ "  </b>");
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
								<td><input type="checkbox" name = "choice2" value = "<%out.print(result.getString(1));%>"></td>	
							</tr>
										
						<%			
							} while (result.next());
						%> </table> <%
							
						}
						
						//make sure to close the connection to the DB
						result.close();
						ps.close();
						stmt.close();
						con.close();
						
						
						out.print("<br><br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
						
						
						// cannot show any flights since we cannot provide BOTH a departure and returning flights
					} else {
						out.print("<h3> It seems that there are no flights available for the the departing and returning dates. Sorry for the inconvenience. Please try again later or talk to a Customer Representative to get this issue cleared.");
					}
					
		} else {
			//grab the DepartureDate and the ArrivalDate
			DepartureDate = request.getParameter("departDate");
			ReturningDate = request.getParameter("returnDate");
			
			//check the dates to make sure that they are in the right format
			java.sql.Date.valueOf(DepartureDate);
			java.sql.Date.valueOf(ReturningDate);
		
			//grab the Departure country ID from the customer
			DeparutreAirportID = request.getParameter("CountryOfDeparture");
			
			//grab the Departure country from the customer
			ArrivalAirportID = request.getParameter("CountryOfArrival");
			
			//connect to the database
					db = new ApplicationDB();	
					con = db.getConnection();

					//Create a SQL statement and execute
					
					// check to see if there are departing flights for that day
					stmt = con.createStatement();
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND (departure_airport_ID = \"" + DeparutreAirportID + "\") AND (arrival_airport_ID = \"" + ArrivalAirportID + "\")";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					if (result.next() == false) {
						isThereFlight1 = false;
					} else {
						isThereFlight1 = true;
					}
					
					//check to see if there are returning flights for the day
					select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + ReturningDate + "\") AND (departure_airport_ID = \"" + ArrivalAirportID + "\") AND (arrival_airport_ID = \"" + DeparutreAirportID + "\")";
					ps = con.prepareStatement(select);
					result = ps.executeQuery();
					
					if (result.next() == false) {
						isThereFlight2 = false;
					} else {
						isThereFlight2 = true;
					}
					
					if ((isThereFlight1 == true) && (isThereFlight2 == true)) {
						
						// check to see if there are departing flights for that day
						stmt = con.createStatement();
						select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + DepartureDate + "\") AND (departure_airport_ID = \"" + DeparutreAirportID + "\") AND (arrival_airport_ID = \"" + ArrivalAirportID + "\")";
						ps = con.prepareStatement(select);
						result = ps.executeQuery();
						
						out.print("<h2> Here are the departing flights:</h2>"); 
						//check the results
						if (result.next() == false) {
							out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>"); 
							
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
							out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreAirportID+ " | Arrival Country: " +ArrivalAirportID+ " | Departure Date: "+DepartureDate+ "  </b>");
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
								<td><input type="checkbox" name = "choice1" value = "<%out.print(result.getString(1));%>"></td>	
							</tr>
										
						<%			
							} while (result.next());
						%> 
						</table> 
						<%
							
						}
						//make sure to close the connection to the DB
						result.close();
						ps.close();
						stmt.close();
						con.close();
						
					//----------------------------------------------------------------------------------------------------------------------------------------------------------//		
					
						//connect to the database
						db = new ApplicationDB();	
						con = db.getConnection();

						//Create a SQL statement and execute
						stmt = con.createStatement();
						select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE (date_of_flight = \"" + ReturningDate + "\") AND (departure_airport_ID = \"" + ArrivalAirportID + "\") AND (arrival_airport_ID = \"" + DeparutreAirportID + "\")";
						ps = con.prepareStatement(select);
						result = ps.executeQuery();
						
						out.print("<h2> Here are the returning flights:</h2>");
						//check the results
						if (result.next() == false) {
							out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
							
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
							out.print("<br><b> Here are all the flights that match info given: Departure Country: " +ArrivalAirportID+ " | Arrival Country: " +DeparutreAirportID+ " | Returning Date: "+ReturningDate+ "  </b>");
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
								<td><input type="checkbox" name = "choice2" value = "<%out.print(result.getString(1));%>"></td>	
							</tr>
										
						<%			
							} while (result.next());
						%> </table> <%
							
						}
						
						//make sure to close the connection to the DB
						result.close();
						ps.close();
						stmt.close();
						con.close();
						
						
						out.print("<br><br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
						
						
						// cannot show any flights since we cannot provide BOTH a departure and returning flights
					} else {
						out.print("<h3> It seems that there are no flights available for the the departing and returning dates. Sorry for the inconvenience. Please try again later or talk to a Customer Representative to get this issue cleared.");
					}
		} // ends the main if-else if -else statements
		
		
		
				
				
	} catch (Exception e) {
		out.print("<h3> SOMETHING WENT WRONG! MAKE SURE TO FILL IN ALL FIELDS. PLEASE TRY AGAIN. </h3>");
	}
%>

<br>

</form>
</body>
</html>