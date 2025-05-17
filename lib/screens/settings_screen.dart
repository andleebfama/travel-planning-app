import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart'; // Import the themeNotifier
import 'package:in_app_review/in_app_review.dart'; // Import the in_app_review package

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    // Set the initial value of the switch based on the current theme
    isDarkMode = themeNotifier.value == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          // Change Password
          ListTile(
            leading: Icon(Icons.lock_reset),
            title: Text("Change Password"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Change password not implemented."),
              ));
            },
          ),

          // App Theme
          ListTile(
            leading: Icon(Icons.palette),
            title: Text("App Theme"),
            subtitle: Text(isDarkMode ? "Dark" : "Light"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Choose Theme"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        title: Text("Light"),
                        value: ThemeMode.light,
                        groupValue: themeNotifier.value,
                        onChanged: (val) {
                          themeNotifier.value = val!;
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile(
                        title: Text("Dark"),
                        value: ThemeMode.dark,
                        groupValue: themeNotifier.value,
                        onChanged: (val) {
                          themeNotifier.value = val!;
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile(
                        title: Text("System Default"),
                        value: ThemeMode.system,
                        groupValue: themeNotifier.value,
                        onChanged: (val) {
                          themeNotifier.value = val!;
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Notifications Toggle
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            subtitle: Text(notificationsEnabled ? "Enabled" : "Disabled"),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(notificationsEnabled
                      ? "Notifications Enabled"
                      : "Notifications Disabled"),
                ));
              },
            ),
          ),

          // Language Selector
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            subtitle: Text(selectedLanguage),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Select Language"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: Text("English"),
                        value: 'English',
                        groupValue: selectedLanguage,
                        onChanged: (val) {
                          setState(() {
                            selectedLanguage = val!;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<String>(
                        title: Text("Spanish"),
                        value: 'Spanish',
                        groupValue: selectedLanguage,
                        onChanged: (val) {
                          setState(() {
                            selectedLanguage = val!;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Clear App Cache
          ListTile(
            leading: Icon(Icons.cleaning_services),
            title: Text("Clear App Cache"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Clear Cache"),
                  content: Text("Are you sure you want to clear the cache?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Clear the cache here if you want (simulating it for now)
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Cache cleared."),
                        ));
                        Navigator.pop(context);
                      },
                      child: Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("No"),
                    ),
                  ],
                ),
              );
            },
          ),

          // Divider
          Divider(color: Colors.black),

          // Send Feedback
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text("Send Feedback"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Redirect to feedback form."),
              ));
            },
          ),

          // Rate the App
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Rate the App"),
            onTap: () async {
              // Request for rating the app
              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Could not open the review prompt."),
                ));
              }
            },
          ),

          // Divider
          Divider(color: Colors.black),

          // Terms & Conditions
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Terms & Conditions"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Terms & Conditions"),
                  content: Text("You agree to use the app responsibly and follow guidelines."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),

          // Help / FAQs
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text("Help / FAQs"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Help / FAQs"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Q1: How do I reset my password?"),
                      Text("A1: Go to Settings > Change Password."),
                      SizedBox(height: 10),
                      Text("Q2: How do I enable notifications?"),
                      Text("A2: Toggle the Notifications switch in Settings."),
                      SizedBox(height: 10),
                      Text("Q3: How do I change the theme?"),
                      Text("A3: Go to Settings > App Theme and select your preference."),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
