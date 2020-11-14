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
<title>Edit Airport</title>
</head>
<body>

<%

ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

select = "SELECT * FROM OnlineResTravelSystem.Airports WHERE 3_letter_ID = ?";
ps = con.prepareStatement(select);
ps.setString(1,request.getParameter("airportID"));
result = ps.executeQuery();
result.next();
String airportID = result.getString("3_letter_ID");
String airportName = result.getString("AirportName");
String airportCountry = result.getString("Country");

out.print("<b>You are currently editing:<br>" + "ID: " + airportID + " Name: " + airportName + " (" + airportCountry + ")" +"</b><br>"); 

session.setAttribute("session_airport_number",request.getParameter("airportID"));
result.close();
ps.close();
con.close();
%>

<form method = "post" action = "EditAirportDB.jsp">

<br>
Airport ID:
<input type = "text" name = "airportID" required="required">

<br>
Airport Name:
<input type = "text" name = "airportName" required="required">

<br>
Airport Country:
<input type = "text" name = "airportCountry" required="required">

<br><br>
<input type = "submit" value = "Edit airport!">

</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

</body>
</html>