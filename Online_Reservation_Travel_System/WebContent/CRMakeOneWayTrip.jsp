<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/>
<meta charset="UTF-8">
<title>Customer Rep Find One-Way Flight</title>
</head>

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
button {
background-color: transparent;
font-weight: bold;
}

</style>
<body>

<button onclick="history.back()">GO BACK</button>
<%
	out.print("<h2> Let's Go On An Adventure! </h2>");
	out.print("<h3> Please select a departure airport and arrival airport. Departure date is optional. </h3>");
	
//connect to a DB and try to make a drop down table of all the contries and airports to start a flight from
	try {
		//Get the database connection
		//Get the database connection
				
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();
				
			//get the names of all the countries for now
			String select = "SELECT AirportName,3_letter_ID FROM OnlineResTravelSystem.Airports ORDER BY Country ASC";
						
			// put the results in the Result Set to be read
			PreparedStatement ps = con.prepareStatement(select);
			ResultSet result = ps.executeQuery();
			
			out.print("<form method=\"post\" action=\"CRSearchOneWayFlights.jsp\">");
			
			out.print("Airport of Departure  <select name= \"CountryOfDeparture\">");
			while (result.next()) {
				String CountryOfDepart = result.getString("AirportName");
				String CountryDepartID = result.getString("3_letter_ID");
				out.print( "<option value= \"" + CountryDepartID + "\">"+ CountryOfDepart  + " - " + CountryDepartID + "</option>" );
			}
			out.print("</select> ");
			
			
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement
			stmt = con.createStatement();
				
			//get the names of all the countries for now
			select = "SELECT AirportName,3_letter_ID FROM OnlineResTravelSystem.Airports ORDER BY Country ASC";
						
			// put the results in the Result Set to be read
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			out.print("Airport of Arrival <select name= \"CountryOfArrival\">");
			while (result.next()) {
				String CountryOfArrival = result.getString("AirportName");
				String CountryArrivalID = result.getString("3_letter_ID");
				out.print( "<option value= \"" + CountryArrivalID + "\">"+ CountryOfArrival + " - " + CountryArrivalID + "</option> " );
			}
			out.print("</select>");
			
			out.print("Departure date:  <input type=\"date\" name=\"departDate\" /input> <small> Format: YYYY-MM-DD </small>");
			
			%> 
			<br>Order By: (pick one)		
			<br> <input type="checkbox" name = "OrderBy" value = "price">Price
			<br> <input type="checkbox" name = "OrderBy" value = "departure_time">Take-off Time
			<br> <input type="checkbox" name = "OrderBy" value = "arrival_time">Landing Time
			<br> <br>OR <br>
			<br>Filter By: (select the checkbox and then type or select the value you want to filter by)
			<br> <input type="checkbox" name = "FilterByPriceCheck" value = "1">
			Price <= <input type="input" name = "FilterByPrice" value = ""> (Enter a decimal value)
			<br>
			<input type="checkbox" name = "FilterByCompNameCheck" value = "1">
			<%//get the names of all the countries for now
			select = "SELECT CompName, 2_letter_ID FROM OnlineResTravelSystem.Airline_Company ORDER BY CompName ASC";
						
			// put the results in the Result Set to be read
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			out.print("Airline Company:  <select name= \"AirComp\">");
			while (result.next()) {
				String airlineCompName = result.getString("CompName");
				String airlineCompID = result.getString("2_letter_ID");
				out.print( "<option value= \"" + airlineCompID + "\">"+ airlineCompName + " - " + airlineCompID + "</option> " );
			}
			out.print("</select>");
			%>
			<br>
			<% 
			
			out.print("<input name = \"CustomerToHelp\" type = \"hidden\" value = \""+request.getParameter("CustomerToHelp")+"\">");
			
			out.print("<br><input type = \"submit\" value = \"FIND FLIGHTS\"style=\"font-weight:bold;\" >");
			
			out.print("</form>");
				
			result.close();
			ps.close();
			stmt.close();
			con.close();
		
	} 
	catch (Exception ex) {
		out.print("Could not establish a connection.");
	}
%>


</body>
</html>