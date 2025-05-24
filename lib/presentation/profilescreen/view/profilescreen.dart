import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String name = 'Suniya';
  final String email = 'suniyafathima@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold,
          fontSize: 28),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://images.icon-icons.com/3446/PNG/512/account_profile_user_avatar_icon_219236.png'),
                ),
                SizedBox(height: 12),
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildCardMenuItem(Icons.edit, 'Edit Profile'),
                buildCardMenuItem(Icons.bookmark, 'Saved Articles'),
                buildCardMenuItem(Icons.mail_outline, 'Contact Me'),
                buildCardMenuItem(Icons.info_outline, 'About Me'),
                buildCardMenuItem(Icons.logout, 'Log Out'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardMenuItem(IconData icon, String title) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
