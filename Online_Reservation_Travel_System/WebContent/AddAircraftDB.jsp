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

String aircraftName;
int numberOfSeats;
int aircraftID;

aircraftName = request.getParameter("aircraftName");
numberOfSeats = Integer.parseInt(request.getParameter("numberOfSeats"));

ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

Statement stmt = con.createStatement();
ResultSet S = stmt.executeQuery("Select Max(aircraft_ID) as max FROM OnlineResTravelSystem.Aircrafts");
S.next();
aircraftID = S.getInt("max") + 1;
S.close();
stmt.close();

try {
	ps = con.prepareStatement("INSERT INTO OnlineResTravelSystem.Aircrafts VALUES (?,?,?)");
	ps.setInt(1,aircraftID);
	ps.setString(2,aircraftName);
	
	ps.setInt(3,numberOfSeats);
	
	ps.executeUpdate();
	out.println("Aircraft successfully added.");
	ps.close();
}
catch (Exception e) {
	e.printStackTrace();
	response.sendRedirect("ErrorPage.jsp");
	
}

con.close();

%>

<form method = "post" action = "AddAircraft.jsp">
<input type = "submit" value = "Add another aircraft">
</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

</body>
</html>