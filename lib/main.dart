import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Manager',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87), // Updated here
        ),
      ),
      home: UserPostApp(),
    );
  }
}

class UserPostApp extends StatefulWidget {
  @override
  _UserPostAppState createState() => _UserPostAppState();
}

class _UserPostAppState extends State<UserPostApp> {
  List users = [
    {'name': 'Ali Khan', 'email': 'ali.khan@example.com'},
    {'name': 'Ayesha Malik', 'email': 'ayesha.malik@example.com'},
    {'name': 'Bilal Ahmed', 'email': 'bilal.ahmed@example.com'},
    {'name': 'Fatima Noor', 'email': 'fatima.noor@example.com'},
    {'name': 'Hamza Sheikh', 'email': 'hamza.sheikh@example.com'},
    {'name': 'Sara Qureshi', 'email': 'sara.qureshi@example.com'},
    {'name': 'Zain Raza', 'email': 'zain.raza@example.com'},
    {'name': 'Amna Yousuf', 'email': 'amna.yousuf@example.com'},
    {'name': 'Usman Javed', 'email': 'usman.javed@example.com'},
    {'name': 'Nida Tariq', 'email': 'nida.tariq@example.com'},
  ];
  List posts = [];
  bool isLoading = false;

  void addPost(String title, String body) {
    setState(() {
      posts.add({
        'id': posts.length + 1,
        'title': title,
        'body': body,
      });
    });
  }

  void updatePost(int index, String title, String body) {
    setState(() {
      posts[index]['title'] = title;
      posts[index]['body'] = body;
    });
  }

  void deletePost(int index) {
    setState(() {
      posts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Manager', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade800,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            users[index]['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800),
                          ),
                          subtitle: Text(users[index]['email']),
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade700,
                            child: Text(
                              users[index]['name'][0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey.shade400),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade800,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => _showAddPostDialog(),
                          child: Text(
                            'Add Post',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: posts.isEmpty
                            ? Center(
                                child: Text(
                                  'No Posts Available',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600),
                                ),
                              )
                            : ListView.builder(
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    elevation: 4,
                                    child: ListTile(
                                      title: Text(
                                        posts[index]['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(posts[index]['body']),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () =>
                                                _showEditPostDialog(index),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () => deletePost(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showAddPostDialog() {
    String title = '';
    String body = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title:
              Text('Add Post', style: TextStyle(color: Colors.teal.shade800)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                onChanged: (value) => title = value,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Body', border: OutlineInputBorder()),
                onChanged: (value) => body = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                addPost(title, body);
                Navigator.pop(context);
              },
              child: Text('Add', style: TextStyle(color: Colors.teal.shade800)),
            ),
          ],
        );
      },
    );
  }

  void _showEditPostDialog(int index) {
    String title = posts[index]['title'];
    String body = posts[index]['body'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title:
              Text('Edit Post', style: TextStyle(color: Colors.teal.shade800)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                controller: TextEditingController(text: title),
                onChanged: (value) => title = value,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Body', border: OutlineInputBorder()),
                controller: TextEditingController(text: body),
                onChanged: (value) => body = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                updatePost(index, title, body);
                Navigator.pop(context);
              },
              child:
                  Text('Update', style: TextStyle(color: Colors.teal.shade800)),
            ),
          ],
        );
      },
    );
  }
}
