<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css"/> <!--  now we will be able to use CSS in our code -->
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

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

h1 {
	color: #0074D9;
  	font-family: geometric sans-serif;
  	font-size: 200%;
  	text-align: center;
}

p{
	font-size: 200%;
}
input{
	background-color: transparent;
	font-family: geometric sans-serif;
	font-size: 75%;
}

</style>

<title>User Page</title>
</head>
<body>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the login.jsp
		String userLogin = request.getParameter("Username");
		String userPassword = request.getParameter("Password");

		//Make a select statement for the User table:
		String select = "SELECT username, password FROM OnlineResTravelSystem.User WHERE username = ? AND password = ?";
		
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(select);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, userLogin);
		ps.setString(2, userPassword);
		//Run the query against the DB
		ResultSet result = ps.executeQuery();

		if (result.next() == false){
			out.print("<b id=\"otherBold\">No user by this username/password has been found. Please try again.</b1>");
			out.println("<br></br>");
			out.println("<br> <form method = \"post\" action = \"login.jsp\"> <input type = \"submit\" value = \"RETRY\"></form> <br>");
		}
		else{
			
			// Here I want to change this to send people to other screen based on the type of user that they are (Customer / Customer Rep / Admin)
			// I would first check for their number (type) and then redirect them to the correct page
			select = "SELECT User_Type FROM OnlineResTravelSystem.User WHERE username = ? AND password = ?";
			ps = con.prepareStatement(select);
			ps.setString(1, userLogin);
			ps.setString(2, userPassword);
			result = ps.executeQuery();
			
			if (result.next() == true) {
				int type_of_user = result.getInt("User_Type");
				if (type_of_user ==  1) {
					String redirectURL = "CustomerPage.jsp";
					session.setAttribute("CurrentUser", userLogin);
				    response.sendRedirect(redirectURL);
				} else if (type_of_user == 2) {
					// have to make a Customer-Rep page
					String redirectURL = "CustomerRepPage.jsp";
					session.setAttribute("CurrentUser", userLogin);
				    response.sendRedirect(redirectURL);
				} else {
					// have to make a Admin Page
					String redirectURL = "AdminDashboard.jsp";
					session.setAttribute("CurrentUser", userLogin);
				    response.sendRedirect(redirectURL);
				}
				
			} else {
				out.print("There seems to be some problem getting connected. Please try again.");
				out.println("<br></br>");
				out.println("<br> <form method = \"post\" action = \"login.jsp\"> <input type = \"submit\" value = \"RETRY\"></form> <br>");
				
			}
			
		}
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Connection failed!");
	}
%>

		
</body>
</html>