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
h3 {
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
font-weight: bold;
}



</style>
<title>Buy/Reserve One-Way Trip Tickets Page</title>
</head>
<body>
<button onclick="history.back()">GO BACK</button>
<%
String Choice;

try {
	
	Choice = request.getParameter("choice");
	if (Choice == null) {
		throw new NullPointerException();
	}
	%>
	<h3>Please check below to make sure this is the ticket that you chose:</h3>
	<%
	
	// variables used to connect to the DB and send SQL quereies
	ApplicationDB db;
	Connection con;
	Statement stmt;
	String select;
	PreparedStatement ps;
	ResultSet result;
	int intChoice = Integer.parseInt(Choice);
	
	try {
		
		//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
	
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT * FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intChoice+ "";
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
					</tr>
					
					<%
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
							
		%>
		
		<br>
		<b> First Class Fee: $100</b>
		<br>
		<b> Business Class Fee: $75</b>
		<br>
		<b> Economy Class Fee: $50</b>
		<br>
		<b>-------------------------------</b>
		<br>
		<b>Booking Fee: $15</b>
		<br>
		<b>-------------------------------</b>
		<br>
		<b>Reservation Fee: $25</b>
		<br>
		<b>-------------------------------</b>
		<br>
		<b>Fee for ticket purchase: Base Price + Class Price + Booking Fee</b>
		<br>
		<br>

		<form action = "BookOrReserveOneWayConfirmation.jsp" method="post">
		
		Would you like a complementary special meal? (check box for YES)
		<input type="checkbox" name = "special_meal" value = 1>
		<br>
		<br>
		Choose an option:
		<button name="Class" type="submit" value="First Class">Purchase First Class Ticket</button>
		<button name="Class" type="submit" value="Business Class">Purchase Business Class Ticket</button>
		<button name="Class" type="submit" value="Economy Class">Purchase Economy Class Ticket</button>
		<button name="Class" type="submit" value="Reserve">Reserve Ticket</button>
		<input name="flight_number" type="hidden" value="<%out.print(intChoice);%>">
		</form>

		<% 
			
		
	} catch (Exception ex) {
		out.print("<h3>Hmmm. Something went wrong. Please go back and try again.</h3>");
	}
	
} catch (Exception ex) {
	out.print("<h3>Please go back and make sure that you chose ONE departure flight.</h3>");
}

%>


</body>
</html>