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
<title>Confirmation</title>
</head>
<body>



<%
int aircraftID = Integer.parseInt((String)session.getAttribute("session_aircraft_id"));
String aircraftName = request.getParameter("aircraftName");
int numberOfSeats = Integer.parseInt(request.getParameter("numberOfSeats"));

ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

try {
	ps = con.prepareStatement("UPDATE OnlineResTravelSystem.Aircrafts SET aircraft_name = ?," + 
"number_of_seats = ? WHERE aircraft_ID = ?");
	ps.setString(1,aircraftName);
	ps.setInt(2,numberOfSeats);
	ps.setInt(3,aircraftID);
	
	
	ps.executeUpdate();
	out.println("Aircraft edit successful.");
	ps.close();
}
catch (Exception e) {
	response.sendRedirect("ErrorPage.jsp");
}

con.close();
%>

<form method = "post" action = "ChooseAircraftToEdit.jsp">
<input type = "submit" value = "Edit another aircraft">
</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>


</body>
</html>