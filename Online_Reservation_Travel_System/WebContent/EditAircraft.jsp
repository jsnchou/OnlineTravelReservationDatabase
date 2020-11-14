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
h3 {
	color: #000000;
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
<title>Create New Flight</title>
</head>
<body>

<%

ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

select = "SELECT * FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = ?";
ps = con.prepareStatement(select);
ps.setInt(1,Integer.parseInt(request.getParameter("aircraftID")));
result = ps.executeQuery();
result.next();
String aircraftName = result.getString("aircraft_name");


out.print("<b>You are currently editing:<br>" + aircraftName);
session.setAttribute("session_aircraft_id",request.getParameter("aircraftID"));
result.close();
ps.close();
con.close();
%>


<form method = "post" action = "EditAircraftDB.jsp">

Aircraft Name:
<input type = "text" name = "aircraftName" required = "required">
<br>
Number of Seats:
<input type = "text" name = "numberOfSeats" required="required">

<br>

<input type = "submit" value = "Edit this aircraft">

</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

</body>
</html>