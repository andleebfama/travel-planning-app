import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': 'How do I plan a new trip?',
      'answer': 'Go to the Home screen and tap "Plan your Trip".'
    },
    {
      'question': 'How can I contact support?',
      'answer': 'Use the form below or email us at support@travelbuddy.com'
    },
    {
      'question': 'Can I cancel a saved trip?',
      'answer': 'Yes. Go to "My Trips", select a trip, and tap delete.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: const Color.fromARGB(255, 25, 104, 107),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...faqList.map((faq) => ExpansionTile(
                title: Text(faq['question']!),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(faq['answer']!),
                  ),
                ],
              )),
          Divider(height: 32),
          Text(
            'Contact Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'Your Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'Message'),
            maxLines: 5,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement submission logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Support message sent!')),
              );
            },
            child: Text('Send'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 25, 104, 107),
            ),
          ),
        ],
      ),
    );
  }
}
