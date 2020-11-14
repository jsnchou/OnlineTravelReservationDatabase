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
table{
border: solid black;
}
td {
text-align: center;

}

</style>
<title>Customer Rep Make User Flights and Reservations Page</title>
</head>
<body>

<% 
String CustomerToHelp = request.getParameter("User");

String currentUserName = session.getAttribute("CurrentUser").toString();
out.print("<h1> Customer Representative: " + currentUserName + " ... Helping Customer: "+ CustomerToHelp +"</h1> ");
out.println("<div> <form method = \"post\" action = \"CustomerRepPage.jsp\"> <input type = \"submit\" value = \"CUSTOMER REP DASHBOARD\"></form> </div>");

out.print("<h3> Choose a type of flight: </h3>");

out.print("<form method = \"post\" action = \"CRMakeOneWayTrip.jsp\"> <input type = \"submit\" value = \"ONE-WAY\"> <input name = \"CustomerToHelp\" type = \"hidden\" value = \""+CustomerToHelp+"\"> </form><br>");
out.print("<form method = \"post\" action = \"CRMakeRoundTrip.jsp\"> <input type = \"submit\" value = \"ROUND-TRIP\"><input name = \"CustomerToHelp\" type = \"hidden\" value = \""+CustomerToHelp+"\"></form><br>");
out.print("<form method = \"post\" action = \"CRMakeMultiStopTrip.jsp\"> <input type = \"submit\" value = \"MULTI-STOP-TRIP\"><input name = \"CustomerToHelp\" type = \"hidden\" value = \""+CustomerToHelp+"\"></form><br>");


%>

<hr />
	
	<h2> Flight Reservations </h2>
	
	<%
	out.print("<form method = \"post\" action = \"CRReservationActions.jsp\">");
	
	ApplicationDB db;
	Connection con;
	Statement stmt;
	String select;
	PreparedStatement ps;
	ResultSet result;
	
	//find User_ID using username
	String UserID = null;
	int intUserID = 0;

	//connect to the database
	db = new ApplicationDB();	
	con = db.getConnection();

	//Create a SQL statement and execute
	stmt = con.createStatement();
	select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
	ps = con.prepareStatement(select);
	ps.setString(1,CustomerToHelp);
	result = ps.executeQuery();
					
	//check the results
	if (result.next() == false) {
		out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
	} else {
		do {		
			intUserID = result.getInt(1);
		} while (result.next());
	}
	//make sure to close the connection to the DB
	result.close();
	ps.close();
	stmt.close();
	con.close();

	//list the reservations
	db = new ApplicationDB();	
	con = db.getConnection();

	//Create a SQL statement and execute
	stmt = con.createStatement();
	select = "SELECT reservation_number,t1.flight_number,purchase_date,purchase_time,date_of_flight,2_letter_ID,departure_time,arrival_time,departure_airport_ID,arrival_airport_ID,price FROM OnlineResTravelSystem.Reservation AS t1 JOIN OnlineResTravelSystem.Flight AS t2 on t1.flight_number = t2.flight_number WHERE User_ID = "+ intUserID +" ORDER BY purchase_date";
	ps = con.prepareStatement(select);
	result = ps.executeQuery();
	
	//check the results
	if (result.next() == false) {
		out.print("<b> NO RESERVATIONS AT THE MOMENT </b>");
		out.print("</form>");
		
	} else {
		out.print("<b>In order to delete a reservation or buy the ticket, check both the boxes and then click the DELETE or BUY TICKET button</b>");
		// make a table of the flights that have been found
		%>
		<table border = "1">
		
		<tr> 
			<th>Flight Number</th>
			<th>Purchase Date</th>
			<th>Purchase Time</th>
			<th>Date of Flight</th>
			<th>Airline ID</th>
			<th>Departure Time</th>
			<th>Arrival Time</th>
			<th>Departure Airport ID</th>						
			<th>Arrival Airport ID</th>
			<th>Price</th>
			<th>Choice: (pick both)</th>
		</tr>
		
		<%
		do {	
		%>
	
		<tr>
			<td><%out.print(result.getString(2));%></td>
			<td><%out.print(result.getString(3));%></td>
			<td><%out.print(result.getString(4));%></td>
			<td><%out.print(result.getString(5));%></td>
			<td><%out.print(result.getString(6));%></td>
			<td><%out.print(result.getString(7));%></td>
			<td><%out.print(result.getString(8));%></td>
			<td><%out.print(result.getString(9));%></td>
			<td><%out.print(result.getString(10));%></td>
			<td><%out.print(result.getString(11));%></td>
			<td>
			<input type="checkbox" name="reservation_number" value = "<%out.print(result.getString(1));%>" >
			<input type="checkbox" name="flight_number" value = "<%out.print(result.getString(2));%>" >
			</td>	
		</tr>
				
	<%			
		} while (result.next());
	%>	</table> <%
	
	
	//make sure to close the connection to the DB
	result.close();
	ps.close();
	stmt.close();
	con.close();
	
	out.print("<input type=\"submit\" name = \"Action\" value = \"DELETE\" >");
	out.print("<input type=\"submit\" name = \"Action\" value = \"BUY TICKET\">");
	out.print("<input name=\"User_ID\" type=\"hidden\" value=\""+intUserID+"\">");
	out.print("<input name=\"CustomerToHelp\" type=\"hidden\" value=\""+CustomerToHelp+"\">");
	out.print("</form>");
	 } 
	%>
	<br>
	<hr />

	
	<h2> Flight Tickets </h2>
	<%
	out.print("<form method = \"post\" action = \"CRFlightTicketActions.jsp\">");
	//find User_ID using username
	UserID = null;
	intUserID = 0;

	//connect to the database
	db = new ApplicationDB();	
	con = db.getConnection();

	//Create a SQL statement and execute
	stmt = con.createStatement();
	select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
	ps = con.prepareStatement(select);
	ps.setString(1,CustomerToHelp);
	result = ps.executeQuery();
					
	//check the results
	if (result.next() == false) {
		out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
	} else {
		do {		
			intUserID = result.getInt(1);
		} while (result.next());
	}
	//make sure to close the connection to the DB
	result.close();
	ps.close();
	stmt.close();
	con.close();

	//list the reservations
	db = new ApplicationDB();	
	con = db.getConnection();

	//Create a SQL statement and execute
	stmt = con.createStatement();
	select = "SELECT ticket_number,flight_number , purchase_date, purchase_time, departure_date, departure_time,class,seat_number FROM OnlineResTravelSystem.Flight_Ticket WHERE User_ID = "+intUserID+" ORDER BY purchase_date";
	ps = con.prepareStatement(select);
	result = ps.executeQuery();
	
	//check the results
	if (result.next() == false) {
		out.print("<b> NO FLIGHT TICKETS AT THE MOMENT </b>");
		out.print("</form>"); 
		
	} else {
		out.print("<b>In order to delete a ticket, check the box(ONLY ONE BOX) and then click the DELETE button</b>");
		// make a table of the flights that have been found
		%>
		<table border = "1">
		
		<tr> 
			<th>Flight Number</th>
			<th>Purchase Date</th>
			<th>Purchase Time</th>
			<th>Date of Flight</th>
			<th>Departure Time</th>
			<th>Class</th>
			<th>Seat Number</th>						
			<th>Choice:</th>
		</tr>
		
		<%
		do {	
		%>
	
		<tr>
			<td><%out.print(result.getString(2));%></td>
			<td><%out.print(result.getString(3));%></td>
			<td><%out.print(result.getString(4));%></td>
			<td><%out.print(result.getString(5));%></td>
			<td><%out.print(result.getString(6));%></td>
			<td><%out.print(result.getString(7));%></td>
			<td><%out.print(result.getString(8));%></td>
			<td>
			<input type="checkbox" name="ticket_number" value = "<%out.print(result.getString(1));%>" >
			</td>	
		</tr>
				
	<%			
		} while (result.next());
	%>	</table> <%
	
	
	//make sure to close the connection to the DB
	result.close();
	ps.close();
	stmt.close();
	con.close();

	out.print("<input type=\"submit\" name = \"Action\" value = \"DELETE\" >");
	out.print("<input name=\"CustomerToHelp\" type=\"hidden\" value=\""+CustomerToHelp+"\">");
	out.print("</form>");
	 } %>
	<br>
	<hr />
	
	<h2> Waiting List </h2>
	<%
	out.print("<form method = \"post\" action = \"CRWaitingListActions.jsp\"> ");
	
	//find User_ID using username
	UserID = null;
	intUserID = 0;

	//connect to the database
	db = new ApplicationDB();	
	con = db.getConnection();

	//Create a SQL statement and execute
	stmt = con.createStatement();
	select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
	ps = con.prepareStatement(select);
	ps.setString(1,CustomerToHelp);
	result = ps.executeQuery();
					
	//check the results
	if (result.next() == false) {
		out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
	} else {
		do {		
			intUserID = result.getInt(1);
		} while (result.next());
	}
	//make sure to close the connection to the DB
	result.close();
	ps.close();
	stmt.close();
	con.close();

	//list the reservations
	db = new ApplicationDB();	
	con = db.getConnection();

	//Create a SQL statement and execute
	stmt = con.createStatement();
	select = "SELECT t1.flight_number,date_of_flight,2_letter_ID,departure_time,arrival_time,departure_airport_ID,arrival_airport_ID,price FROM OnlineResTravelSystem.waiting_list AS t1 JOIN OnlineResTravelSystem.Flight AS t2 on t1.flight_number = t2.flight_number WHERE User_ID = "+intUserID+"  ORDER BY date_of_flight";
	ps = con.prepareStatement(select);
	result = ps.executeQuery();
	
	//check the results
	if (result.next() == false) {
		out.print("<b> NO WAITING LISTS FOR ANY FLIGHTS AT THE MOMENT </b>");
		out.print("</form>");
		
	} else {
		out.print("<b>Mark the check-box (ONLY ONE CHECKBOX) and press the DELETE button to get out of the waiting list for the flight</b>");
		// make a table of the flights that have been found
		%>
		<table border = "1">
		
		<tr> 
			<th>Flight Number</th>
			<th>Date Of Flight</th>
			<th>Airline Company ID</th>
			<th>Departure Time</th>
			<th>Arrival Time</th>
			<th>Departure Airport ID</th>
			<th>Arrival Airport ID</th>	
			<th>Price</th>					
			<th>Choice:</th>
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
			<td><%out.print(result.getString(8));%></td>
			<td>
			<input type="checkbox" name="flight_number" value = "<%out.print(result.getString(1));%>" >
			</td>	
		</tr>
				
	<%			
		} while (result.next());
	%>	</table> <%
	
	
	//make sure to close the connection to the DB
	result.close();
	ps.close();
	stmt.close();
	con.close();
	
	out.print("<input type=\"submit\" name = \"Action\" value = \"DELETE\" >");
	out.print("<input type=\"hidden\" name = \"User_ID\" value = \""+intUserID+"\">");
	out.print("<input name=\"CustomerToHelp\" type=\"hidden\" value=\""+CustomerToHelp+"\">");
	out.print("</form>");
	 
	} %>
	<br>
	

</body>
</html>