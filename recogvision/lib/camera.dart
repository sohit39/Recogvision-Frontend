import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as imglib;
import 'dart:ui';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String name = "";
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(name)),
        body: Center(
            child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        )),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.up,
            children: <Widget>[
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PersonList()));
              },
              child: Icon(Icons.people, size: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              backgroundColor: Color.fromARGB(255, 50, 50, 50),
              foregroundColor: Color.fromARGB(255, 250, 250, 250),
              heroTag: "help",
            ),
          ),
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              onPressed: () {
                onHelpButtonPressed();
              },
              child: Icon(Icons.help, size: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              backgroundColor: Color.fromARGB(255, 50, 50, 50),
              foregroundColor: Color.fromARGB(255, 250, 250, 250),
              heroTag: "People",
            ),
          )
        ]));
  }
  void onHelpButtonPressed() {
    takePicture().then((String filePath) async{
      if (mounted) {
        final File imageFile = File(filePath);
        final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
        final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
            FaceDetectorOptions(
                mode: FaceDetectorMode.accurate, minFaceSize: 0.05));
        dynamic faces = await faceDetector.processImage(visionImage);
        double largest = 0;
        Rect finalBoundingBox;
        for (Face face in faces) {
          final Rect boundingBox = face.boundingBox;
          if (boundingBox.height * boundingBox.width > largest) {
            finalBoundingBox = boundingBox;
          }
        }
        setState(() {
          name = (finalBoundingBox.width * finalBoundingBox.height).toString();
        });

      }
    });
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();


  Future<String> takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

}




// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Rect boundingBox;

  const DisplayPictureScreen({Key key, this.imagePath, this.boundingBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (boundingBox != null) {
      return Scaffold(
        appBar: AppBar(title: Text("Cropped Image")),
        body: Image.file(File(imagePath)),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("No Faces Detected")),
        body: Image.file(File(imagePath)),
      );
    }
  }
}

class PersonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
        body: ListView(children: [
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      Person("Tony Riley", NetworkImage("https://i.imgur.com/9Di8DOg.jpeg")),
    ]));
  }
}

class Person extends StatefulWidget {
  @override
  Person(this.name, this.avatar);
  final String name;
  final NetworkImage avatar;
  PersonState createState() => PersonState(name, avatar);
}

class PersonState extends State<Person> {
  PersonState(this.name, this.avatar);
  String name;
  NetworkImage avatar;
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
          title: Text(name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          leading: CircleAvatar(
            backgroundImage: avatar,
            radius: 25,
          ),
          children: <Widget>[
            Column(children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
                maxLines: 1,
                onChanged: (String input) {
                  changeNameTo(input);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Additional Info",
                ),
                minLines: 1,
                maxLines: 3,
                maxLength: 250,
              )
            ])
          ]),
    );
  }

  void changeNameTo(String i) {
    setState(() {
      name = i;
    });
  }
}
