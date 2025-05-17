import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _email;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          _nameController.text = doc['name'] ?? '';
        }
        setState(() {
          _email = user.email;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user info: $e");
      setState(() => _isLoading = false);
    }
  }
Future<void> _updateProfile() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
            {'name': _nameController.text.trim()},
            SetOptions(merge: true),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated")),
      );
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile")),
      );
    }
  }

  setState(() => _isLoading = false);
}


  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset email sent")));
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: Text(
    "Your Profile",
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  backgroundColor: const Color.fromARGB(255, 25, 104, 107), 
  centerTitle: true,
  elevation: 2, 
),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.account_circle, size: 110, color: const Color.fromARGB(255, 5, 5, 5)),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: "Name",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? "Name cannot be empty"
                                      : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              readOnly: true,
                              controller: TextEditingController(text: _email ?? ''),
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _updateProfile,
                              icon: Icon(Icons.save),
                              label: Text("Update Profile"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _changePassword,
                              child: Text("Change Password"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
  );
}
}