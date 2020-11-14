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
<title>Search For Muli-Stop Flights</title>
</head>
<body>

<button onclick="history.back()">GO BACK</button>

<form method = "post" action = "CRBookOrReserveMultiStopFlights.jsp">

<%

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
				select = "SELECT * FROM OnlineResTravelSystem.Flight AS T1,OnlineResTravelSystem.Flight AS T2 WHERE T1.flight_number != T2.flight_number AND  T1.date_of_flight = '"+ DepartureDate +"' AND T1.departure_airport_ID = '"+ DeparutreCountryID +"' AND T2.arrival_airport_ID = '"+ ArrivalCountryID +"' AND T1.arrival_airport_ID = T2.departure_airport_ID;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>"); 
					
				} else {
					// make a table of the flights that have been found
					out.print("<h1> Here are your results:</h1>"); 
					%>
					
					<%
					out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " | Departure Date: "+DepartureDate+"  </b>");
					out.print("<br><b>You may CHOOSE ONE OF THE PAIRS of flights.</b> <br>");
					do {
						out.print("<br><b> CHOOSE BOTH </b>");
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
					
					<tr>
						<td><%out.print(result.getString(13));%></td>
						<td><%out.print(result.getString(14));%></td>
						<td><%out.print(result.getString(15));%></td>
						<td><%out.print(result.getString(16));%></td>
						<td><%out.print(result.getString(17));%></td>
						<td><%out.print(result.getString(18));%></td>
						<td><%out.print(result.getString(19));%></td>
						<td><%out.print(result.getString(21));%></td>
						<td><%out.print(result.getString(20));%></td>
						<td><%out.print(result.getString(22));%></td>
						<td><%out.print(result.getString(23));%></td>
						<td><%out.print(result.getString(24));%></td>
						<td><input type="checkbox" name = "choice2" value = "<%out.print(result.getString(1));%>"></td>	
					</tr>
					
					 </table> 
								
				<%		
					out.print("<br>");
					} while (result.next());
				%><%
				
				out.print("<input name = \"CustomerToHelp\" value = \""+request.getParameter("CustomerToHelp")+"\" type = \"hidden\">");
				out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
				}
				
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
		
		
		
	} catch (Exception e) {
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
						select = "SELECT * FROM OnlineResTravelSystem.Flight AS T1,OnlineResTravelSystem.Flight AS T2 WHERE T1.flight_number != T2.flight_number AND T1.departure_airport_ID = '"+ DeparutreCountryID +"' AND T2.arrival_airport_ID = '"+ ArrivalCountryID +"' AND T1.arrival_airport_ID = T2.departure_airport_ID;";
						ps = con.prepareStatement(select);
						result = ps.executeQuery();
						
						//check the results
						if (result.next() == false) {
							out.print("<b> Seems like there are no flights that match your exact choice of depature and arrival airports and dates. Sorry. </b>");
							// make a back button to the previous page for the user to search for flights ... 
							
						} else {
							// make a table of the flights that have been found
							%>
							
							<%
							out.print("<b> Here are all the flights that match info given: Departure Country: " +DeparutreCountryID+ " | Arrival Country: " +ArrivalCountryID+ " </b>");
							out.print("<br><b>You may CHOOSE ONE OF THE PAIRS of flights.</b> <br>");
							do {
								
								out.print("<br><b> CHOOSE BOTH </b>");
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
								<tr>
									<td><%out.print(result.getString(13));%></td>
									<td><%out.print(result.getString(14));%></td>
									<td><%out.print(result.getString(15));%></td>
									<td><%out.print(result.getString(16));%></td>
									<td><%out.print(result.getString(17));%></td>
									<td><%out.print(result.getString(18));%></td>
									<td><%out.print(result.getString(19));%></td>
									<td><%out.print(result.getString(21));%></td>
									<td><%out.print(result.getString(20));%></td>
									<td><%out.print(result.getString(22));%></td>
									<td><%out.print(result.getString(23));%></td>
									<td><%out.print(result.getString(24));%></td>
									<td><input type="checkbox" name = "choice2" value = "<%out.print(result.getString(13));%>"></td>	
								</tr>
								
								 </table> 
											
							<%		
								out.print("<br>");
							} while (result.next());
							
						out.print("<input name = \"CustomerToHelp\" value = \""+request.getParameter("CustomerToHelp")+"\" type = \"hidden\">");
						out.print("<br><div><input  type = \"submit\" value = \"BOOK!\" style=\"font-size:100%; height:40px; width:80px;\"></div>");
						}
						
						//make sure to close the connection to the DB
						result.close();
						ps.close();
						stmt.close();
						con.close();
						
	}
	
%>

</form>

</body>
</html>