import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/checklist_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({Key? key}) : super(key: key);

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<ChecklistItem> packingList = [];
  List<ChecklistItem> todoList = [];

  @override
  void initState() {
    super.initState();
    loadChecklistData();
  }

  Future<void> loadChecklistData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final packingData = prefs.getStringList('${user.uid}_packingList') ?? [];
      final todoData = prefs.getStringList('${user.uid}_todoList') ?? [];

      setState(() {
        packingList = packingData.map((e) => ChecklistItem.fromMap(jsonDecode(e))).toList();
        todoList = todoData.map((e) => ChecklistItem.fromMap(jsonDecode(e))).toList();
      });
    }
  }

  Future<void> saveChecklistData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await prefs.setStringList('${user.uid}_packingList',
          packingList.map((e) => jsonEncode(e.toMap())).toList());
      await prefs.setStringList('${user.uid}_todoList',
          todoList.map((e) => jsonEncode(e.toMap())).toList());
    }
  }

  void toggleItemDone(ChecklistItem item) {
    setState(() {
      item.isDone = !item.isDone;
    });
    saveChecklistData();
  }

  void deleteItem(ChecklistItem item, bool isPacking) {
    setState(() {
      if (isPacking) {
        packingList.removeWhere((e) => e.id == item.id);
      } else {
        todoList.removeWhere((e) => e.id == item.id);
      }
    });
    saveChecklistData();
  }

  Future<void> addItem(bool isPacking) async {
    TextEditingController titleController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isPacking ? "Add Packing Item" : "Add To-Do Item",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: "Item Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                ChecklistItem newItem = ChecklistItem(
                  id: const Uuid().v4(),
                  title: titleController.text.trim(),
                  isDone: false,
                );

                setState(() {
                  if (isPacking) {
                    packingList.add(newItem);
                  } else {
                    todoList.add(newItem);
                  }
                });

                saveChecklistData();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget buildChecklistSection(String title, List<ChecklistItem> items, bool isPacking) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey.shade50,
      child: ExpansionTile(
        iconColor: Colors.teal,
        collapsedIconColor: Colors.teal,
        title: Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal.shade800)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("No items yet. Add something!",
                  style: TextStyle(fontStyle: FontStyle.italic)),
            )
          else
            ...items.map((item) => Dismissible(
                  key: Key(item.id),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) => deleteItem(item, isPacking),
                  child: CheckboxListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor:
                        item.isDone ? Colors.green.shade50 : Colors.teal.shade50,
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: item.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    value: item.isDone,
                    onChanged: (_) => toggleItemDone(item),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                )),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => addItem(isPacking),
                icon: const Icon(Icons.add, color: Colors.teal),
                label: const Text('Add Item', style: TextStyle(color: Colors.teal)),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    for (var item in items) {
                      item.isDone = true;
                    }
                  });
                  saveChecklistData();
                },
                icon: const Icon(Icons.done_all, color: Colors.teal),
                label: const Text("Mark All", style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("✈️ Travel Checklist"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          buildChecklistSection("Packing List 🎒", packingList, true),
          buildChecklistSection("Pre-Trip To-Do 📝", todoList, false),
        ],
      ),
    );
  }
}
