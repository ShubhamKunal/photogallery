import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(gallaryApp());
}

class gallaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Photo Gallary")),
          backgroundColor: Colors.black,
        ),
        body: Gallery(),
      ),
    );
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool loading;
  List<String> ids = ['0', '10', '1002'];

  @override
  void initState() {
    // TODO: implement initState
    loading = true;
    ids = [];
    _loadImageIds();

    super.initState();
  }

  void _loadImageIds() async {
    final response = await http.get("https://picsum.photos/v2/list");
    final json = jsonDecode(response.body);
    List<String> _ids = [];
    for (var image in json) {
      _ids.add(image['id']);
    }
    setState(() {
      loading = false;
      ids = _ids;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.black,
      ));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImagePage(ids[index]),
          ));
        },
        child: Image.network("https://picsum.photos/id/${ids[index]}/300/300"),
      ),
      itemCount: ids.length,
    );
  }
}

class ImagePage extends StatelessWidget {
  final String id;
  ImagePage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Image.network('https://picsum.photos/id/$id/600/600'),
    );
  }
}
