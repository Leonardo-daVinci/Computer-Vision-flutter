import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(
  home: FacePage(),
));

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  
  File _imageFile;
  List<Face> _faces;

  void _getImageAndDetectedFaces() async{
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector();
    final faces = await faceDetector.processImage(image);
    setState(() {
      if(mounted){
        _imageFile = imageFile;
        _faces = faces;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detector'),
      ),
      body: ImageAndFaces(),
      floatingActionButton: FloatingActionButton(
        onPressed:()=> _getImageAndDetectedFaces() ,
        tooltip:'Pick an image',
        child: Icon(Icons.add_a_photo),
        ),
    );
  }
}

class ImageAndFaces extends StatelessWidget {

  final File imageFile;
  final List<Face> faces;

  ImageAndFaces({this.imageFile, this.faces});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
        flex:2,
        child:Container(
          constraints: BoxConstraints.expand(),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover
            ),
          ),
      ),
      Flexible(
        flex:1,
        child: ListView(
          children: faces.map<Widget>((f) => FaceCoordinates(face:f)).toList(),
        ),
      ),
    ],
     );
  }
}

class FaceCoordinates extends StatelessWidget {
  FaceCoordinates({this.face});
  final Face face;

  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return ListTile(
      title: Text('${pos.top}, ${pos.left}, ${pos.bottom}, ${pos.right}'),
    );
  }
}
