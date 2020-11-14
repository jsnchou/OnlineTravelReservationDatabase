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
<title>Confirmation</title>
</head>
<body>

<%
ApplicationDB db = new ApplicationDB();

Connection con = db.getConnection();
String select;
PreparedStatement ps;
ResultSet result;

//id of the user to be deleted
int id = Integer.parseInt(request.getParameter("flight_number"));

// edit the information of the user in the User Table in the DB
PreparedStatement psInsert = con.prepareStatement("DELETE FROM OnlineResTravelSystem.Flight WHERE flight_number = ?");
psInsert.setInt(1,id);
try {
    psInsert.executeUpdate(); // the INSERT function in SQL needs to be run using the executeUpdate()
    psInsert.close();
    out.println("Flight deletion succeeded.<br><br>");
}
catch(SQLException e) {
    out.println("There was an error while deleting the flight in the database.");
}

%>

<form action = "ChooseFlightToDelete.jsp">
<input type = "submit" value = "Delete another flight">
</form>

<form method = "post" action = "CustomerRepPage.jsp">
<input type = "submit" value = "Go back to customer representative dashboard">
</form>

<%
con.close();
%>

</body>
</html>