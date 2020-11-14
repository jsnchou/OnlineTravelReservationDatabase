<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Registration Post Processing Page</title>
	
	<style>
	body {
  	background-image: url("CloudImage.jpeg");
  	background-repeat: no-repeat;
  	background-size: cover;
  	text-align: center;
  	background-position: fixed;
  	background-top:0;
  	background-left:0;
  	background-min-width: 100%;
  	background-min-height: 100%;
	}
	input {
	background-color: transparent;
	font-family: geometric sans-serif;
	font-size: 90%;
	}
	</style>
	
	</head>
	<body>
	<%
	try {

		//Get the database connection (get this all from ApplicationDB.java)
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		// get the username that the new user wants to use and check it against the DB to find a match
		String username = request.getParameter("Username");
		
		// SQL query to find a match for the username
		Statement s = con.createStatement();
		PreparedStatement ps = con.prepareStatement("SELECT Username FROM OnlineResTravelSystem.User WHERE Username = ?");
		ps.setString(1,username);
		ResultSet M = ps.executeQuery(); //the SELECT function in SQL needs to be run using executeQuery()
		
		// the username of the new user is not used by anyone else, so now continue to add the other info into the DB
		if (M.next() == false) {
			
			//Create a SQL statement to find the current max user ID
			Statement stmt = con.createStatement();
			
			//store the result of the query in the ResultSet
			ResultSet S = stmt.executeQuery("SELECT MAX(User_ID) as max FROM OnlineResTravelSystem.User");
			
			//the index of the ResultSet starts at a NULL value, need to go to the next value in in order to get to the first query
			S.next();
			int maxID = S.getInt("max");
			
			//this new maxID number will be the ID of the new Customer added
			maxID++;
					
			//Get parameters from the HTML form at the index.jsp
			//String username = request.getParameter("username");
			String password = request.getParameter("Password");
			String address = request.getParameter("Address");
			String firstname = request.getParameter("First Name");
			String lastname = request.getParameter("Last Name");
			String phonenumber = request.getParameter("Phone Number");
			
			// insert the information of the new user in the User Table in the DB
			PreparedStatement psInsert = con.prepareStatement("INSERT INTO OnlineResTravelSystem.User VALUES (" + maxID + ",?,?,?,?,?,?,1)");
			psInsert.setString(1,username);
			psInsert.setString(2,password);
			psInsert.setString(3,address);
			psInsert.setString(4,firstname);
			psInsert.setString(5,lastname);
			psInsert.setString(6,phonenumber);
			psInsert.executeUpdate(); // the INSERT function in SQL needs to be run using the executeUpdate()
			
			out.println("<b>User has been created. You can now go and log in to your new account.</b>");
			out.println("<br></br>");
			out.println("<br> <form method = \"post\" action = \"login.jsp\"> <input type = \"submit\" value = \"Log In Page\"></form> <br>");
			
		} else {
			// here the query has found that the username already exists, so tell the user to use another
			out.println("<b>It seems that the the username (\"" + username + "\") is already taken. Please try another username.</b>");
			out.println("<br></br>");
			out.println("<br> <form method = \"post\" action = \"registerInfo.jsp\"> <input type = \"submit\" value = \"RETRY\"></form> <br>");
		}
		
		//Close the connection.
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Problems occurred when trying to register new user.");
	}
	%>
	</body>
</html>