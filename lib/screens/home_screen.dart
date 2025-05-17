import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/plan_trip_screen.dart';
import 'package:flutter_application_1/screens/explore_screen.dart';
import 'package:flutter_application_1/screens/budget_screen.dart';
import 'package:flutter_application_1/screens/map_screen.dart';
import 'package:flutter_application_1/screens/checklist_screen.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:flutter_application_1/screens/about_screen.dart';
import 'package:flutter_application_1/screens/flights_screen.dart';
import 'package:flutter_application_1/screens/notifications_screen.dart';
import 'package:flutter_application_1/screens/favorites_screen.dart';
import 'package:flutter_application_1/screens/help_support_screen.dart';
import 'package:flutter_application_1/screens/profile_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? userName;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    fetchUserName();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (doc.exists && doc.data() != null) {
          setState(() {
            userName = doc.data()!['name'] ?? "Traveler";
          });
        } else {
          setState(() {
            userName = "Traveler";
          });
        }
      }
    } catch (e) {
      print('Error fetching user name: $e');
      setState(() {
        userName = "Traveler";
      });
    }
  }

  Widget quickLinkCard(String title, IconData icon, VoidCallback onTap, int index) {
    final gradientColors = {
      "Explore Destinations": [Color.fromARGB(255, 35, 98, 112), Color.fromARGB(255, 101, 135, 146)],
      "Plan your Trip": [Color.fromARGB(255, 35, 98, 112), Color.fromARGB(255, 101, 135, 146)],
      "Flights": [Color.fromARGB(255, 35, 98, 112), Color.fromARGB(255, 101, 135, 146)],
      "Budget": [Color.fromARGB(255, 35, 98, 112), Color.fromARGB(255, 101, 135, 146)],
      "Map": [Color.fromARGB(255, 35, 98, 112), Color.fromARGB(255, 101, 135, 146)],
      "Checklist": [Color.fromARGB(255, 35, 98, 112), Color.fromARGB(255, 101, 135, 146)],
    };

    final colors = gradientColors[title] ?? [Colors.grey.shade300, Colors.grey.shade600];

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _fadeController, curve: Interval(0.1 * index, 1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor:Colors.teal.withAlpha((0.3 * 255).toInt()),

        child: Hero(
          tag: 'icon_$title',
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withAlpha((0.7 * 255).toInt()),

                  radius: 30,
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cardData = [
      {"title": "Explore Destinations", "icon": Icons.explore, "screen": ExploreScreen()},
      {"title": "Plan your Trip", "icon": Icons.flight_takeoff, "screen": PlanTripScreen()},
      {"title": "Flights", "icon": Icons.airplanemode_active, "screen": FlightsScreen()},
      {"title": "Budget", "icon": Icons.attach_money, "screen": BudgetPlanScreen()},
      {"title": "Map", "icon": Icons.map, "screen": MapScreen()},
      {"title": "Checklist", "icon": Icons.checklist, "screen": ChecklistScreen()},
    ];

    int crossAxisCount = MediaQuery.of(context).size.width < 600 ? 2 : 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel Planning',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 25, 104, 107).withOpacity(0.8),
        centerTitle: true,
        elevation: 5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfileScreen()));
              },
              child: Icon(Icons.account_circle, size: 32, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/drawer_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                userName != null ? "Hello, $userName" : "Traveler",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(1, 1))],
                ),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home'), onTap: () => Navigator.pop(context)),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen()));
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => HelpSupportScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/banner.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = cardData[index];
                  return quickLinkCard(
                    item["title"],
                    item["icon"],
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item["screen"]),
                      );
                    },
                    index,
                  );
                },
                childCount: cardData.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
