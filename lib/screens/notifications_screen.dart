import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Flight Reminder',
      'subtitle': 'Your flight to Dubai is scheduled for tomorrow at 10:00 AM.',
    },
    {
      'title': 'Trip Budget Updated',
      'subtitle': 'You updated your Bali trip budget: \$1,500',
    },
    {
      'title': 'Weather Alert',
      'subtitle': 'Rain is expected this weekend in Tokyo.',
    },
    {
      'title': 'Checklist Reminder',
      'subtitle': 'Don’t forget to pack your passport and charger.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: const Color.fromARGB(255, 25, 104, 107),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'No notifications at the moment.',
                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 7, 7, 7)),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: Colors.blueAccent),
                    title: Text(notification['title']!),
                    subtitle: Text(notification['subtitle']!),
                  ),
                );
              },
            ),
    );
  }
}
