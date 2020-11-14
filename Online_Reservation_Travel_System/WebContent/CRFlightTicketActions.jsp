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
<title>Flight Ticket Actions Page</title>
</head>
<body>

<%
ApplicationDB db;
Connection con;
Statement stmt;
String select;
PreparedStatement ps;
ResultSet result;

String ticket_number = request.getParameter("ticket_number");


try {

	if (ticket_number == null) {
		throw new NullPointerException();
	}
	
	try{
		
		//connect to the database
		db = new ApplicationDB();	
		con = db.getConnection();

		//Create a SQL statement and execute
		stmt = con.createStatement();
		select = "DELETE FROM OnlineResTravelSystem.Flight_Ticket WHERE ticket_number = "+ ticket_number +"";
		ps = con.prepareStatement(select);
		ps.execute();
						
		//make sure to close the connection to the DB
		ps.close();
		stmt.close();
		con.close();
	} catch (Exception ex) {
		out.print("<h3>There was a problem when trying to delete the reservation. Please go back to the Dashboard and try again.");
	}
	
	out.print("<br><b>The ticket has been deleted. Please go back to the Dashboard to view the changes. </b><br>");
	
} catch (Exception ex) {
	out.print("<h2>Make sure to choose a checkbox when making a selection!</h2>");
}


%>
<br><form method = "post" action = "CustomerRepUserEdit.jsp"> <input type = "submit" value = "Customer Dashboard"><input type = "hidden" name = "User" value = "<%out.print(request.getParameter("CustomerToHelp"));%>"> </form>  <br>
</body>
</html>