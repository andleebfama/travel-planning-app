import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final String appVersion = "1.0.0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            // App Logo centered at the top
            CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage("images/logo.jpg"), 
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // App Name and Version
                  Text(
                    "Travel Planner",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Version $appVersion",
                    style: TextStyle(color: const Color.fromARGB(255, 22, 22, 22)),
                  ),
                  SizedBox(height: 20),

                  // Description
                  Text(
                    "Plan your trips, manage your budget, explore destinations, and keep track of everything — all in one beautiful app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),

                  // Developer Info
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Developed by"),
                    subtitle: Text("Travel Planner Group"),
                  ),
                  Divider(),

                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text("Contact Support"),
                    subtitle: Text("support@travelplanner.app"),
                    onTap: () {
                      // You could integrate email launcher here
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.web),
                    title: Text("Website"),
                    subtitle: Text("www.travelplanner.app"),
                    onTap: () {
                      // You could integrate url_launcher here
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Footer Text
            Text(
              "© 2025 Travel Planner App. All rights reserved.",
              style: TextStyle(color: const Color.fromARGB(255, 22, 22, 22), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
