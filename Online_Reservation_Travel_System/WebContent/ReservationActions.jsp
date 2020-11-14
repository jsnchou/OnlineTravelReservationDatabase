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
button {
background-color: transparent;
}
button {
background-color: transparent;
font-weight: bold;
}
input {
background-color: transparent;
font-weight: bold;
font-size: 15px;
}


</style>
<title>Reservation Actions Page</title>
</head>
<body>
<button onclick="history.back()">GO BACK</button> <br>

<% 
ApplicationDB db;
Connection con;
Statement stmt;
String select;
PreparedStatement ps;
ResultSet result;

String action = request.getParameter("Action");

String User_ID = request.getParameter("User_ID");

String flight_number = request.getParameter("flight_number");

String reservation_number = request.getParameter("reservation_number");

try {
	
	if (flight_number == null) {
		throw new NullPointerException();
	}

	
	if (reservation_number == null) {
		throw new NullPointerException();
	}

	if (action.equals("DELETE")){
		
		try{
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "DELETE FROM OnlineResTravelSystem.Reservation WHERE reservation_number = "+ reservation_number +"";
			ps = con.prepareStatement(select);
			ps.execute();
							
			//make sure to close the connection to the DB
			ps.close();
			stmt.close();
			con.close();
		} catch (Exception ex) {
			out.print("<h3>There was a problem when trying to delete the reservation. Please go back to the Dashboard and try again.");
		}
		
		out.print("<br><b>The reservation has been deleted. Please go back to the Dashboard to view the changes. </b><br>");

					
	} else {
		
		try{
		
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "DELETE FROM OnlineResTravelSystem.Reservation WHERE reservation_number = "+ reservation_number +"";
			ps = con.prepareStatement(select);
			ps.execute();
							
			//make sure to close the connection to the DB
			ps.close();
			stmt.close();
			con.close();
			out.print("<br><b>The reservation has been deleted. You can now purchase this ticket. </b><br>");
		} catch (Exception ex) {
			out.print("<h3>There was a problem when trying to delete the reservation. Please go back to the Dashboard and try again.");
		}
		
		%> <form method = "post" action = "BookOrReserveOneWayTrip.jsp"> <% 
		// the reservation is deleted, now try to make a ticket : Info we are given; User_ID , flight_number
		//connect to the database
		db = new ApplicationDB();	
		con = db.getConnection();

		//Create a SQL statement and execute
		stmt = con.createStatement();
		select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE flight_number = "+flight_number+"";
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
			out.print("<br><b>Here is the flight you want to buy a ticket for:</b>");
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
				<td><input type="checkbox" name = "choice" value = "<%out.print(result.getString(1));%>" checked></td>		
			</tr>
						
		<%			
			} while (result.next());
		%> </table> 
		<br><div><input  type = "submit" value = "BOOK!" style="font-size:100%; height:40px; width:80px; font-weight:bold;"></div>
		</form>
		<% 
		}
		
		//make sure to close the connection to the DB
		result.close();
		ps.close();
		stmt.close();
		con.close();
		
	}
} catch (Exception ex) {
	out.print("<h2>Make sure to choose both the checkboxes when making a selection!</h2>");
}


%>

<br><form method = "post" action = "CustomerPage.jsp"> <input type = "submit" value = "Dashboard"></form>  <br>
</body>
</html>