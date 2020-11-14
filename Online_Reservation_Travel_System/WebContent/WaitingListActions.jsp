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
<title>Waiting List Actions Page</title>
</head>
<body>

<%
ApplicationDB db;
Connection con;
Statement stmt;
String select;
PreparedStatement ps;
ResultSet result;

String flight_number = request.getParameter("flight_number");
String User_ID = request.getParameter("User_ID");


try {

	if (flight_number == null) {
		throw new NullPointerException();
	}
	
	if (User_ID == null) {
		throw new NullPointerException();
	}
	try{
		
		//connect to the database
		db = new ApplicationDB();	
		con = db.getConnection();

		//Create a SQL statement and execute
		stmt = con.createStatement();
		select = "DELETE FROM OnlineResTravelSystem.waiting_list WHERE flight_number = "+ flight_number +" AND User_ID = "+User_ID+"";
		ps = con.prepareStatement(select);
		ps.execute();
						
		//make sure to close the connection to the DB
		ps.close();
		stmt.close();
		con.close();
	} catch (Exception ex) {
		out.print("<h3>There was a problem when trying to delete the reservation. Please go back to the Dashboard and try again.");
	}
	
	out.print("<br><b>Your spot in the waiting list for the flight has been deleted. Please go back to the Dashboard to view the changes. </b><br>");
	
} catch (Exception ex) {
	out.print("<h2>Make sure to choose a checkbox when making a selection!</h2>");
}


%>
<br><form method = "post" action = "CustomerPage.jsp"> <input type = "submit" value = "Dashboard"></form>  <br>
</body>
</html>