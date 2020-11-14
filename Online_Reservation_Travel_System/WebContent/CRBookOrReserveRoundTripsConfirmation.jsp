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
h3 {
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
b {
font-size: 20px;
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
font-weight: bold;
}
input {
background-color: transparent;
font-weight: bold;
font-size: 15px;
}



</style>
<title>Customer Rep Round-Trip Confirmation Page</title>
</head>
<body>
<button onclick="history.back()">GO BACK</button> <br>

<% 
String choice = request.getParameter("Class");

String flight_number1 = request.getParameter("flight_number1");
int intFlight_Number1 = Integer.parseInt(flight_number1);

String flight_number2 = request.getParameter("flight_number2");
int intFlight_Number2 = Integer.parseInt(flight_number2);

String special_meal = request.getParameter("special_meal");
int intSpecialMeal = 0;
if (special_meal != null) {
	intSpecialMeal = 1;
}

//list all the global variables that need to be used in order to find the flights
String DepartureDate = null;

String DepartureCountry = null;
String DeparutreCountryID = null;

String ArrivalCountry = null;
String ArrivalCountryID = null;

//variables used to connect to the DB and send SQL quereies
ApplicationDB db = null;
Connection con = null;
Statement stmt = null;
String select = null;
PreparedStatement ps = null;
ResultSet result = null;

String seatsBought = null;
String aircraftNum = null;
String seatsReserved = null;
String totalSeats = null;

int intSeatsBought = 0;
int intAircraftNum = 0;
int intSeatsReserved = 0;
int intTotalSeats = 0;

int difference = 0;
int seatNum = 0;

boolean departureFlightGood = false;
boolean returningFlightGood = false;

if (choice.equals("First Class")) {
	/*
	0. Search Flights and get the info for the aircraft number
	1. Search aircrafts and get find the number of total seats and store that info
	2. Search Flight Ticket and add up number of people that alreay booked the same flight and Stroe that number
	3. Search the Reservation list for people that have reserved the a seat in the same flight and store that number
	4. Subtract the total number of seats by the sum of the number of seats taken by those that booked the flight and those that reserved
	5. check the difference make sure that it is > 0  , if not, then put this person in the waitlist
	6. If > 0 , then ((total number of seats) - (difference)) + 1 = Seat number given to the new customer purchasing/reserving
	
	// testing out the algorithm to get seat numbers
	 A , S
4-0: 4 , 1
4-1: 3 , 2
4-2: 2 , 3
4-3: 1 , 4
4-4: 0 , waitlist
	*/
	
	//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				departureFlightGood = false;
			} else {
				departureFlightGood = true;
			}
//-----------------------------------------------------------------------------------------------------------------------------------
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				returningFlightGood = false;
			} else {
				returningFlightGood = true;
			}
			
				// if both flights are not available, then put the customer on the waiting list for both flights
			if ((departureFlightGood == false) && (returningFlightGood == false)) {
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number1);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the departing flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard.</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the departing flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number2);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the returning flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard/</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the returning flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
							
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == true) && (returningFlightGood == false)) {
				out.print("<br><b>The departure flight is available, however, the returning flight is fully booked/reserved at this time. Thus, you cannot purchase a ticket for both. Sorry for this inconvenience.");
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == false) && (returningFlightGood == true)) {
				out.print("<br><b>The returning flight is available, however, the departing flight is fully booked/reserved at this time. Thus, you cannot purchase a ticket for both. Sorry for this inconvenience.");
				// make two seperate flight tickets under the customer ID
			} else {
				
			// make the ticket for the first flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				// seat number
				seatNum = (intTotalSeats - difference) + 1;
				
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// use the flight number to pull the rest of the important dates to use to make a ticket
				
				String departureDate = null;
				String departureTime = null;
				String basePrice = null;
				int intBasePrice = 0;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT date_of_flight,departure_time,price FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						departureDate = result.getString(1);
						departureTime = result.getString(2);
						basePrice = result.getString(3);
					} while (result.next());
				}
				intBasePrice = Integer.parseInt(basePrice);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// now figure out the total fair: basePrice + firstClass (100) + bookingfee (15)
				int totalFare = 0;
				totalFare = intBasePrice + 100 + 15;
				
				//class => First
				String ticketClass = null;
				ticketClass = "FIR";
				
				//get current date and time from database
				String curDate = null;
				String curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				String maxTickets = null;
				int intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(ticket_number) FROM OnlineResTravelSystem.Flight_Ticket;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Flight_Ticket VALUES (?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setDate(2,java.sql.Date.valueOf(departureDate));
				ps.setTime(3,Time.valueOf(departureTime));
				ps.setInt(4,seatNum);
			 	ps.setDouble(5,(double)totalFare);
			 	ps.setTime(6,Time.valueOf(curTime));
			 	ps.setDate(7,java.sql.Date.valueOf(curDate));
			 	ps.setString(8,ticketClass);
			 	ps.setInt(9,intSpecialMeal);
			 	ps.setInt(10,intUserID);
			 	ps.setInt(11,intFlight_Number1);
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
		//----------------------------------------------------------------------------------------------------------------------------------------
				// make the ticket for the second flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				// seat number
				seatNum = (intTotalSeats - difference) + 1;
				
				//username
				currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				UserID = null;
				intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// use the flight number to pull the rest of the important dates to use to make a ticket
				
				departureDate = null;
				departureTime = null;
				basePrice = null;
				intBasePrice = 0;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT date_of_flight,departure_time,price FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						departureDate = result.getString(1);
						departureTime = result.getString(2);
						basePrice = result.getString(3);
					} while (result.next());
				}
				intBasePrice = Integer.parseInt(basePrice);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// now figure out the total fair: basePrice + firstClass (100) + bookingfee (15)
				totalFare = 0;
				totalFare = intBasePrice + 100 + 15;
				
				//class => First
				ticketClass = null;
				ticketClass = "FIR";
				
				//get current date and time from database
				curDate = null;
				curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				maxTickets = null;
				intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(ticket_number) FROM OnlineResTravelSystem.Flight_Ticket;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Flight_Ticket VALUES (?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setDate(2,java.sql.Date.valueOf(departureDate));
				ps.setTime(3,Time.valueOf(departureTime));
				ps.setInt(4,seatNum);
			 	ps.setDouble(5,(double)totalFare);
			 	ps.setTime(6,Time.valueOf(curTime));
			 	ps.setDate(7,java.sql.Date.valueOf(curDate));
			 	ps.setString(8,ticketClass);
			 	ps.setInt(9,intSpecialMeal);
			 	ps.setInt(10,intUserID);
			 	ps.setInt(11,intFlight_Number2);
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<br><b>Your first class tickets have been booked. We have updated your queue of tickets. You can view this change on your Dashboard. </b>");
				out.print("<br>");
				
				//get the User Address
				String userAddress = null;
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT Address FROM OnlineResTravelSystem.User WHERE User_ID = ?";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						userAddress = result.getString(1);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<b>Your bill was sent to your address: "+ userAddress +"</b>");
				
			} // ends the inner if-elseIf statements
	
	
} else if (choice.equals("Business Class")) {
	/*
	0. Search Flights and get the info for the aircraft number
	1. Search aircrafts and get find the number of total seats and store that info
	2. Search Flight Ticket and add up number of people that alreay booked the same flight and Stroe that number
	3. Search the Reservation list for people that have reserved the a seat in the same flight and store that number
	4. Subtract the total number of seats by the sum of the number of seats taken by those that booked the flight and those that reserved
	5. check the difference make sure that it is > 0  , if not, then put this person in the waitlist
	6. If > 0 , then ((total number of seats) - (difference)) + 1 = Seat number given to the new customer purchasing/reserving
	
	// testing out the algorithm to get seat numbers
	 A , S
4-0: 4 , 1
4-1: 3 , 2
4-2: 2 , 3
4-3: 1 , 4
4-4: 0 , waitlist
	*/
	
	//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				departureFlightGood = false;
			} else {
				departureFlightGood = true;
			}
//-----------------------------------------------------------------------------------------------------------------------------------
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				returningFlightGood = false;
			} else {
				returningFlightGood = true;
			}
			
				// if both flights are not available, then put the customer on the waiting list for both flights
			if ((departureFlightGood == false) && (returningFlightGood == false)) {
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number1);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the departing flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard.</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the departing flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number2);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the returning flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard/</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the returning flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
							
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == true) && (returningFlightGood == false)) {
				out.print("<br><b>The departure flight is available, however, the returning flight is fully booked/reserved at this time. Thus, you cannot purchase a ticket for both. Sorry for this inconvenience.");
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == false) && (returningFlightGood == true)) {
				out.print("<br><b>The returning flight is available, however, the departing flight is fully booked/reserved at this time. Thus, you cannot purchase a ticket for both. Sorry for this inconvenience.");
				// make two seperate flight tickets under the customer ID
			} else {
				
			// make the ticket for the first flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				// seat number
				seatNum = (intTotalSeats - difference) + 1;
				
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// use the flight number to pull the rest of the important dates to use to make a ticket
				
				String departureDate = null;
				String departureTime = null;
				String basePrice = null;
				int intBasePrice = 0;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT date_of_flight,departure_time,price FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						departureDate = result.getString(1);
						departureTime = result.getString(2);
						basePrice = result.getString(3);
					} while (result.next());
				}
				intBasePrice = Integer.parseInt(basePrice);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// now figure out the total fair: basePrice + firstClass (100) + bookingfee (15)
				int totalFare = 0;
				totalFare = intBasePrice + 100 + 15;
				
				//class => First
				String ticketClass = null;
				ticketClass = "BUS";
				
				//get current date and time from database
				String curDate = null;
				String curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				String maxTickets = null;
				int intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(ticket_number) FROM OnlineResTravelSystem.Flight_Ticket;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Flight_Ticket VALUES (?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setDate(2,java.sql.Date.valueOf(departureDate));
				ps.setTime(3,Time.valueOf(departureTime));
				ps.setInt(4,seatNum);
			 	ps.setDouble(5,(double)totalFare);
			 	ps.setTime(6,Time.valueOf(curTime));
			 	ps.setDate(7,java.sql.Date.valueOf(curDate));
			 	ps.setString(8,ticketClass);
			 	ps.setInt(9,intSpecialMeal);
			 	ps.setInt(10,intUserID);
			 	ps.setInt(11,intFlight_Number1);
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
		//----------------------------------------------------------------------------------------------------------------------------------------
				// make the ticket for the second flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				// seat number
				seatNum = (intTotalSeats - difference) + 1;
				
				//username
				currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				UserID = null;
				intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// use the flight number to pull the rest of the important dates to use to make a ticket
				
				departureDate = null;
				departureTime = null;
				basePrice = null;
				intBasePrice = 0;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT date_of_flight,departure_time,price FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						departureDate = result.getString(1);
						departureTime = result.getString(2);
						basePrice = result.getString(3);
					} while (result.next());
				}
				intBasePrice = Integer.parseInt(basePrice);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// now figure out the total fair: basePrice + firstClass (100) + bookingfee (15)
				totalFare = 0;
				totalFare = intBasePrice + 100 + 15;
				
				//class => First
				ticketClass = null;
				ticketClass = "BUS";
				
				//get current date and time from database
				curDate = null;
				curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				maxTickets = null;
				intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(ticket_number) FROM OnlineResTravelSystem.Flight_Ticket;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Flight_Ticket VALUES (?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setDate(2,java.sql.Date.valueOf(departureDate));
				ps.setTime(3,Time.valueOf(departureTime));
				ps.setInt(4,seatNum);
			 	ps.setDouble(5,(double)totalFare);
			 	ps.setTime(6,Time.valueOf(curTime));
			 	ps.setDate(7,java.sql.Date.valueOf(curDate));
			 	ps.setString(8,ticketClass);
			 	ps.setInt(9,intSpecialMeal);
			 	ps.setInt(10,intUserID);
			 	ps.setInt(11,intFlight_Number2);
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<br><b>Your business class tickets have been booked. We have updated your queue of tickets. You can view this change on your Dashboard. </b>");
				out.print("<br>");
				
				//get the User Address
				String userAddress = null;
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT Address FROM OnlineResTravelSystem.User WHERE User_ID = ?";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						userAddress = result.getString(1);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<b>Your bill was sent to your address: "+ userAddress +"</b>");
				
			} // ends the inner if-elseIf statements
	
} else if (choice.equals("Economy Class")) {
	/*
	0. Search Flights and get the info for the aircraft number
	1. Search aircrafts and get find the number of total seats and store that info
	2. Search Flight Ticket and add up number of people that alreay booked the same flight and Stroe that number
	3. Search the Reservation list for people that have reserved the a seat in the same flight and store that number
	4. Subtract the total number of seats by the sum of the number of seats taken by those that booked the flight and those that reserved
	5. check the difference make sure that it is > 0  , if not, then put this person in the waitlist
	6. If > 0 , then ((total number of seats) - (difference)) + 1 = Seat number given to the new customer purchasing/reserving
	
	// testing out the algorithm to get seat numbers
	 A , S
4-0: 4 , 1
4-1: 3 , 2
4-2: 2 , 3
4-3: 1 , 4
4-4: 0 , waitlist
	*/
	
	//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				departureFlightGood = false;
			} else {
				departureFlightGood = true;
			}
//-----------------------------------------------------------------------------------------------------------------------------------
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				returningFlightGood = false;
			} else {
				returningFlightGood = true;
			}
			
				// if both flights are not available, then put the customer on the waiting list for both flights
			if ((departureFlightGood == false) && (returningFlightGood == false)) {
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number1);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the departing flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard.</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the departing flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number2);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the returning flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard/</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the returning flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
							
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == true) && (returningFlightGood == false)) {
				out.print("<br><b>The departure flight is available, however, the returning flight is fully booked/reserved at this time. Thus, you cannot purchase a ticket for both. Sorry for this inconvenience.");
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == false) && (returningFlightGood == true)) {
				out.print("<br><b>The returning flight is available, however, the departing flight is fully booked/reserved at this time. Thus, you cannot purchase a ticket for both. Sorry for this inconvenience.");
				// make two seperate flight tickets under the customer ID
			} else {
				
			// make the ticket for the first flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				// seat number
				seatNum = (intTotalSeats - difference) + 1;
				
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// use the flight number to pull the rest of the important dates to use to make a ticket
				
				String departureDate = null;
				String departureTime = null;
				String basePrice = null;
				int intBasePrice = 0;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT date_of_flight,departure_time,price FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						departureDate = result.getString(1);
						departureTime = result.getString(2);
						basePrice = result.getString(3);
					} while (result.next());
				}
				intBasePrice = Integer.parseInt(basePrice);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// now figure out the total fair: basePrice + firstClass (100) + bookingfee (15)
				int totalFare = 0;
				totalFare = intBasePrice + 100 + 15;
				
				//class => First
				String ticketClass = null;
				ticketClass = "BUS";
				
				//get current date and time from database
				String curDate = null;
				String curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				String maxTickets = null;
				int intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(ticket_number) FROM OnlineResTravelSystem.Flight_Ticket;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Flight_Ticket VALUES (?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setDate(2,java.sql.Date.valueOf(departureDate));
				ps.setTime(3,Time.valueOf(departureTime));
				ps.setInt(4,seatNum);
			 	ps.setDouble(5,(double)totalFare);
			 	ps.setTime(6,Time.valueOf(curTime));
			 	ps.setDate(7,java.sql.Date.valueOf(curDate));
			 	ps.setString(8,ticketClass);
			 	ps.setInt(9,intSpecialMeal);
			 	ps.setInt(10,intUserID);
			 	ps.setInt(11,intFlight_Number1);
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
		//----------------------------------------------------------------------------------------------------------------------------------------
				// make the ticket for the second flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				// seat number
				seatNum = (intTotalSeats - difference) + 1;
				
				//username
				currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				UserID = null;
				intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// use the flight number to pull the rest of the important dates to use to make a ticket
				
				departureDate = null;
				departureTime = null;
				basePrice = null;
				intBasePrice = 0;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT date_of_flight,departure_time,price FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						departureDate = result.getString(1);
						departureTime = result.getString(2);
						basePrice = result.getString(3);
					} while (result.next());
				}
				intBasePrice = Integer.parseInt(basePrice);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// now figure out the total fair: basePrice + firstClass (100) + bookingfee (15)
				totalFare = 0;
				totalFare = intBasePrice + 100 + 15;
				
				//class => First
				ticketClass = null;
				ticketClass = "ECO";
				
				//get current date and time from database
				curDate = null;
				curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				maxTickets = null;
				intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(ticket_number) FROM OnlineResTravelSystem.Flight_Ticket;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Flight_Ticket VALUES (?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setDate(2,java.sql.Date.valueOf(departureDate));
				ps.setTime(3,Time.valueOf(departureTime));
				ps.setInt(4,seatNum);
			 	ps.setDouble(5,(double)totalFare);
			 	ps.setTime(6,Time.valueOf(curTime));
			 	ps.setDate(7,java.sql.Date.valueOf(curDate));
			 	ps.setString(8,ticketClass);
			 	ps.setInt(9,intSpecialMeal);
			 	ps.setInt(10,intUserID);
			 	ps.setInt(11,intFlight_Number2);
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<br><b>Your economy class tickets have been booked. We have updated your queue of tickets. You can view this change on your Dashboard. </b>");
				out.print("<br>");
				
				//get the User Address
				String userAddress = null;
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT Address FROM OnlineResTravelSystem.User WHERE User_ID = ?";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						userAddress = result.getString(1);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<b>Your bill was sent to your address: "+ userAddress +"</b>");
				
			} // ends the inner if-elseIf statements
			
	// reseve a seat
} else {
	/*
	0. Search Flights and get the info for the aircraft number
	1. Search aircrafts and get find the number of total seats and store that info
	2. Search Flight Ticket and add up number of people that alreay booked the same flight and Stroe that number
	3. Search the Reservation list for people that have reserved the a seat in the same flight and store that number
	4. Subtract the total number of seats by the sum of the number of seats taken by those that booked the flight and those that reserved
	5. check the difference make sure that it is > 0  , if not, then put this person in the waitlist
	6. If > 0 , then ((total number of seats) - (difference)) + 1 = Seat number given to the new customer purchasing/reserving
	
	// testing out the algorithm to get seat numbers
	 A , S
4-0: 4 , 1
4-1: 3 , 2
4-2: 2 , 3
4-3: 1 , 4
4-4: 0 , waitlist
	*/
	
	//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				departureFlightGood = false;
			} else {
				departureFlightGood = true;
			}
//-----------------------------------------------------------------------------------------------------------------------------------
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();
		
			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
		
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					aircraftNum = result.getString(1);
				} while (result.next());
			}
			intAircraftNum = Integer.parseInt(aircraftNum);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
		
			// Aircraft number acquired, now find out the total number of seats in the aircraft
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
			
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {			
					totalSeats = result.getString(1);
				} while (result.next());
			}
			intTotalSeats = Integer.parseInt(totalSeats);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();	
			
			// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
					
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsBought = result.getString(1);
				} while (result.next());
			}
			intSeatsBought = Integer.parseInt(seatsBought);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// Number of Seats bought aquired, now find out the number of seats reserved
			
			//connect to the database
			db = new ApplicationDB();	
			con = db.getConnection();

			//Create a SQL statement and execute
			stmt = con.createStatement();
			select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
			ps = con.prepareStatement(select);
			result = ps.executeQuery();
							
			//check the results
			if (result.next() == false) {
				out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
			} else {
				do {		
					seatsReserved = result.getString(1);
				} while (result.next());
			}
			intSeatsReserved = Integer.parseInt(seatsReserved);
			//make sure to close the connection to the DB
			result.close();
			ps.close();
			stmt.close();
			con.close();
			
			// total number of seats reserved acquired , now see if there are any available seats
			
			difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
			
			if (difference == 0) {
				returningFlightGood = false;
			} else {
				returningFlightGood = true;
			}
			
				// if both flights are not available, then put the customer on the waiting list for both flights
			if ((departureFlightGood == false) && (returningFlightGood == false)) {
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number1);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the departing flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard.</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the departing flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				// we have the User_ID and the flight number. Add this user to the waitlist
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.waiting_list VALUES (?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				ps.setInt(2,intFlight_Number2);
				
				try {
					ps.executeUpdate();
					out.print("<br><b>Sorry. It seems that the returning flight that you want to book is currently full. We have added you to the waiting list for the flight. You can see this change on your Dashboard/</b><br>");
				} catch (Exception ex) {
					out.print("<br><b>You are still on the waitlist for the returning flight. Please wait until more seats are available. Thank you.</b>");
				}
				
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
							
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == true) && (returningFlightGood == false)) {
				out.print("<br><b>The departure flight is available, however, the returning flight is fully booked/reserved at this time. Thus, you cannot reserve a seat for both. Sorry for this inconvenience.");
				// cannot do anything if one flight is good and the other is not
			} else if ((departureFlightGood == false) && (returningFlightGood == true)) {
				out.print("<br><b>The returning flight is available, however, the departing flight is fully booked/reserved at this time. Thus, you cannot reserve a seat for both. Sorry for this inconvenience.");
				// make two seperate flight tickets under the customer ID
			} else {
				
			// make the ticket for the first flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number1 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				//username
				String currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				String UserID = null;
				int intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				
				//get current date and time from database
				String curDate = null;
				String curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				String maxTickets = null;
				int intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(reservation_number) FROM OnlineResTravelSystem.Reservation;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Reservation VALUES (?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setInt(2,intUserID);
				ps.setInt(3,intFlight_Number1);
				ps.setDate(4,java.sql.Date.valueOf(curDate));
			 	ps.setTime(5,Time.valueOf(curTime));
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
		//----------------------------------------------------------------------------------------------------------------------------------------
				// make the ticket for the second flight
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT aircraft_ID FROM OnlineResTravelSystem.Flight WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						aircraftNum = result.getString(1);
					} while (result.next());
				}
				intAircraftNum = Integer.parseInt(aircraftNum);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
			
				// Aircraft number acquired, now find out the total number of seats in the aircraft
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT number_of_seats FROM OnlineResTravelSystem.Aircrafts WHERE aircraft_ID = "+ intAircraftNum +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
				
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						totalSeats = result.getString(1);
					} while (result.next());
				}
				intTotalSeats = Integer.parseInt(totalSeats);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();	
				
				// Total Number of seats in the aircraft aquired, now figure out how many people have already bought a seat
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Flight_Ticket WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
						
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsBought = result.getString(1);
					} while (result.next());
				}
				intSeatsBought = Integer.parseInt(seatsBought);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// Number of Seats bought aquired, now find out the number of seats reserved
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT COUNT(*) FROM OnlineResTravelSystem.Reservation WHERE flight_number = "+ intFlight_Number2 +"";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access flight info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						seatsReserved = result.getString(1);
					} while (result.next());
				}
				intSeatsReserved = Integer.parseInt(seatsReserved);
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				// total number of seats reserved acquired , now see if there are any available seats
				
				difference = intTotalSeats - (intSeatsBought + intSeatsReserved);
				
				//username
				currentUser = null;
				currentUser = request.getParameter("CustomerToHelp");
				
				//find User_ID using username
				UserID = null;
				intUserID = 0;
		
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();

				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT User_ID FROM OnlineResTravelSystem.User WHERE username = ?";
				ps = con.prepareStatement(select);
				ps.setString(1,currentUser);
				result = ps.executeQuery();
								
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access User info in the DB. Please go back and try again. </b>");
				} else {
					do {		
						intUserID = result.getInt(1);
					} while (result.next());
				}
				//intUserID = Integer.parseInt(UserID.trim());
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//get current date and time from database
				curDate = null;
				curTime = null;
				
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT current_date(),current_time()";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						curDate = result.getString(1);
						curTime = result.getString(2);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//make a new ticket number for this ticket
				maxTickets = null;
				intMaxTickets = 0;
						
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT MAX(reservation_number) FROM OnlineResTravelSystem.Reservation;";
				ps = con.prepareStatement(select);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						maxTickets = result.getString(1);
					} while (result.next());
				}
				intMaxTickets = Integer.parseInt(maxTickets);
				intMaxTickets++;
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				//now that you have all the info, make the ticket for the customer
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "INSERT INTO OnlineResTravelSystem.Reservation VALUES (?,?,?,?,?)";
				ps = con.prepareStatement(select);
				ps.setInt(1,intMaxTickets);
				ps.setInt(2,intUserID);
				ps.setInt(3, intFlight_Number2);
				ps.setDate(4,java.sql.Date.valueOf(curDate));
				ps.setTime(5,Time.valueOf(curTime));
				ps.executeUpdate();
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<br><b>Your seats have been reserved. We have updated your queue of reservation. You can view this change on your Dashboard. </b>");
				out.print("<br>");
				
				//get the User Address
				String userAddress = null;
				//connect to the database
				db = new ApplicationDB();	
				con = db.getConnection();
			
				//Create a SQL statement and execute
				stmt = con.createStatement();
				select = "SELECT Address FROM OnlineResTravelSystem.User WHERE User_ID = ?";
				ps = con.prepareStatement(select);
				ps.setInt(1,intUserID);
				result = ps.executeQuery();
			
				//check the results
				if (result.next() == false) {
					out.print("<br><b> Seems like there was an issue when trying to access info in the DB. Please go back and try again. </b>");
				} else {
					do {			
						userAddress = result.getString(1);
					} while (result.next());
				}
				//make sure to close the connection to the DB
				result.close();
				ps.close();
				stmt.close();
				con.close();
				
				out.print("<b>Your bill was sent to your address: "+ userAddress +"</b>");
				
			} // ends the inner if-elseIf statements
}


%>
									
<br> <br> <form method = "post" action = "CustomerRepUserEdit.jsp"> <input type = "submit" value = "Customer Dashboard"> <input type = "hidden" name = "User" value = "<%out.print(request.getParameter("CustomerToHelp"));%>"></form> <br>

</body>
</html>