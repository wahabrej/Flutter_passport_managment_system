import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/fethuserdata.dart';
import 'package:frontend/userNotification.dart';
import 'package:frontend/userProfile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apply.dart';
//import 'fetch_userdata.dart';
import 'fetch_user_id.dart'; // Import the file with the getUserId function
import 'signin.dart'; // Import the Signin page

class Userdashboard extends StatefulWidget {
  final String userId;
  const Userdashboard({Key? key, required this.userId}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Userdashboard> {
  Map<String, dynamic>? user; // Map to hold the fetched user data
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/getUser/${widget.userId}'));
      if (response.statusCode == 200) {
        setState(() {
          user =
              jsonDecode(response.body); // Decode JSON and update the user map
          isLoading = false; // Stop loading
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "USER DASHBOARD",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'images/wahab.png'), // Replace with your image asset
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70, // Width of the container
                      height: 70, // Height of the container
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Makes the container circular
                        border: Border.all(
                          color: Colors.blue, // Border color
                          width: 4.0, // Border width
                        ),
                        image: DecorationImage(
                          image:
                              AssetImage('images/wahab.png'), // Your image path
                          // Cover the entire circle
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('${user!['firstName']} ${user!['lastName']}'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(user!['phone'])
                        ],
                      ),
                    )
                  ],
                )),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(userId: widget.userId)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notification_important),
              title: Text('Notification'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserNotification()),
                ); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings or other page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                hintText: 'Search for something',
                hintStyle: const TextStyle(
                  color: Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Colors.grey[200], // Background color of the search bar
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildDashboardCard(
                    title: "Apply",
                    subtitle: "Start New Application",
                    icon: Icons.dashboard,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Apply()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: "Reissue",
                    subtitle: "Reissue or Renew",
                    icon: Icons.settings,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Apply()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: "Missing/ Lost",
                    subtitle: "Report Lost",
                    icon: Icons.notifications,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Apply()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: "Status",
                    subtitle: "Check your Status",
                    icon: Icons.person,
                    color: Colors.orange,
                    onTap: () async {
                      String? userId = await getUserId();
                      if (userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FetchData(userId: userId),
                          ),
                        );
                      } else {
                        // Handle the case where user ID is not available
                        print('User ID not found!');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/logout"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Clear SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('userId'); // Remove user ID

        // Navigate to Signin page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signin()),
        );
      } else {
        print('Failed to logout: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }
}
