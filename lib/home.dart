import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload_image_objectbox/photo.dart';
import 'package:upload_image_objectbox/pickimage.dart';
import 'package:upload_image_objectbox/utility.dart';

import 'main.dart';
import 'objectbox.g.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box<Photo> photoBox = store.box<Photo>();
  List<Photo> listPhoto = [];
  Uint8List? _imagePick;
  String? _potoString;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagePick = null;
    _potoString = '';
    getPotoData();
    deleteData();
  }

  void pickImage() async {
    Uint8List img = await pickImages(ImageSource.gallery);
    setState(() {
      _potoString = Utility.base64String(img);
      var poto = Photo(
        poto: _potoString,
      );

      photoBox.put(poto);

      refreshData();
    });
  }

  Future<void> getPotoData() async {
    final poto = photoBox.getAll();
    setState(() {
      listPhoto = poto;
    });
  }

  Future<void> deleteData() async {
    photoBox.removeAll();
    refreshData();
  }

  Future<void> refreshData() async {
    final poto = photoBox.getAll();
    setState(() {
      listPhoto = poto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'Upload Image ObjectBox',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton.icon(
                onPressed: () {
                  pickImage();
                },
                icon: Icon(Icons.add_a_photo_outlined),
                label: Text('Pick a Image')),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listPhoto.length,
              itemBuilder: (context, index) {
                var photo = listPhoto[index];
                return Card(
                  child: Column(
                    children: <Widget>[
                      Utility.imageFromBase64String(photo.poto!),
                      // You can add more widgets here to display photo details
                      Text('Photo ${index + 1}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
