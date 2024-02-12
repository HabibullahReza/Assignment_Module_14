import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String appBarTitle = 'Photo Gallery App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhotoList(),
    );
  }
}

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  List<dynamic> _photos = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
      if (response.statusCode == 200) {
        setState(() {
          _photos = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load photos';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to connect to the server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.appBarTitle),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView.builder(
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    final photo = _photos[index];
                    return ListTile(
                      leading: Image.network(
                        photo['thumbnailUrl'],
                        width: 50,
                        height: 50,
                      ),
                      title: Text(photo['title']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoDetail(photo: photo),
                          ),
                        ).then((_) {
                          MyApp.appBarTitle = 'Photo Gallery App';
                        });
                        MyApp.appBarTitle = 'Photo Details';
                      },
                    );
                  },
                ),
    );
  }
}

class PhotoDetail extends StatelessWidget {
  final Map<String, dynamic> photo;

  const PhotoDetail({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Details'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(
              photo['url'],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Title: ${photo['title']}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'ID: ${photo['id']}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
