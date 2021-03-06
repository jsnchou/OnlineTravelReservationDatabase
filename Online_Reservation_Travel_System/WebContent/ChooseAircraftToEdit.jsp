<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<html>
<head>
<meta charset="ISO-8859-1">
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
</style>

<title>Choose Aircraft To Edit</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;
%>

<h2>Choose the flight to edit:</h2>
<form method = "post" action = "EditAircraft.jsp">
<select name = "aircraftID">
<%
select = "SELECT * FROM OnlineResTravelSystem.Aircrafts";
ps = con.prepareStatement(select);
result = ps.executeQuery();


while(result.next()) {
	String aircraftID = result.getString("aircraft_ID");
	String aircraftName = result.getString("aircraft_name");
	String numberOfSeats = result.getString("number_of_seats");
	
	
	out.print("<h2><option value = \"" + aircraftID + "\">" + aircraftName + "</h2>"); 
}

result.close();
ps.close();
con.close();
%>
</select>
<input type = "submit" value = "Edit this aircraft">
</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

</body>
</html>