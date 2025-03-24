import 'package:flutter/material.dart';
import 'package:prueba/screens/camera_screen.dart';
import 'package:prueba/screens/inventory_management.dart';
import 'package:prueba/screens/location_screen.dart';
import 'package:prueba/screens/login.dart';
import 'package:prueba/screens/user_management.dart';

class AdminUserScreen extends StatelessWidget {
  const AdminUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // User Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Name
                  const Text(
                    'User Administrator',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.people,
                    text: 'Users',
                    onTap: () {
                      // Navigate to Users screen
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.inventory,
                    text: 'Inventory',
                    onTap: () {
                      // Navigate to Inventory screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InventoryManagementScreen ()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.camera_alt,
                    text: 'Camera',
                    onTap: () {
                      // Navigate to Camera screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CameraScreen())
                      );
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.location_on,
                    text: 'Location',
                    onTap: () {
                      // Navigate to Location screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LocationScreen())
                      );
                    },
                  ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logout logic
                     _logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

   void _logout(BuildContext context) {


    // Redirigir a la pantalla de Login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

}