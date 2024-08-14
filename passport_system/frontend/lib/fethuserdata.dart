import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchData extends StatefulWidget {
  final String userId; // Add a userId parameter

  const FetchData({Key? key, required this.userId}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
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
        title: Text('Fetch Data Page'), // AppBar with a title
        backgroundColor: Colors.blue, // Optional: set background color
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show a loader while loading
          : user != null
              ? ListTile(
                  title: Text(user!['email']), // Display user email
                  subtitle: Text(user!['_id']), // Display user ID
                )
              : Center(
                  child: Text(
                      'User not found')), // Show a message if no user is found
    );
  }
}
