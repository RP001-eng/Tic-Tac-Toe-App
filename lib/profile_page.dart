import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  String name = '';

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    name = user?.displayName ?? 'Guest User';
    nameController.text = name;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey, // Light background for contrast
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.black, // Professional teal header
        elevation: 5,
      ),
      body: user == null
          ? const Center(child: Text('No user logged in'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header Section (Avatar, Name)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal[300], // Soft background color
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person, size: 80, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    // Editable Name Field
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.teal[400], // Subtle background for the text field
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user.email ?? 'No Email Available',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Additional Info Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Me',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Tech enthusiast with a passion for coding and problem-solving. Always learning and eager to grow, both personally and professionally..',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Save updated name to Firebase (this is just an example)
                  if (nameController.text.isNotEmpty) {
                    FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name updated successfully')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Correct property for setting background color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              // Floating Action Button (Logout)
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully')),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
