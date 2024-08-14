import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final String userId;
  const UserProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? user; // Map to hold the fetched user data
  bool isLoading = true; // Track loading state
  int _selectedIndex =
      0; // Track the selected index for the bottom navigation bar

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Implement navigation or other actions based on the selected index
    switch (index) {
      case 0:
        // Navigate to home
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Navigate to search
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        // Navigate to profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage(
                  'images/wahab.png'), // Replace with your image asset
              radius: 20,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show a loading indicator while data is being fetched
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Center the profile image and name
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                              'images/wahab.png'), // Replace with your image asset
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${user!['firstName']} ${user!['lastName']}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 16, 186, 228)),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Align other text to the left
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(179, 4, 205, 250)),
                      ),
                      Text('${user!['firstName']} ${user!['lastName']}'),
                      Divider(),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(179, 4, 205, 250)),
                      ),
                      Text(user!['email']),
                      Divider(),
                      Text(
                        'Date of Birth',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(179, 4, 205, 250)),
                      ),
                      Text(user!['dob']),
                      Divider(),
                      Text(
                        'National ID',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(179, 4, 205, 250)),
                      ),
                      Text(user!['nid']),
                      Divider(),
                      Text(
                        'Mobile',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(179, 4, 205, 250)),
                      ),
                      Text("+88 ${user!['phone']}"),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
