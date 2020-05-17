import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_parking_app/repository/databaseService.dart';

import 'package:new_parking_app/services/auth.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String passwordConf = '';
  String error = '';
  File _selectedFile;
  bool _inProcess = false;

  Widget getImageWidget(){
    if(_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 250,
        fit: BoxFit.cover,

      );
    }
  } 

  
  getImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source); 
    
    if(image !=null){
      File cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 700,
      maxWidth: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.blue,
        toolbarTitle: "RPS Cropper",
        statusBarColor: Colors.blue.shade900,
        backgroundColor: Colors.white, 
      )
    
    );
    this.setState(() {
      _inProcess = false;
      _selectedFile = cropped;
    });
    }
  } 

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parking Mobile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: new Stack(
        // alignment: Alignment.topCenter,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('assets/bgimg.jpg'), fit: BoxFit.cover),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          new ListView(
            children: <Widget>[
              Padding(padding: new EdgeInsets.all(5.0)),
              SizedBox(
                height: 10.0,
              ),
              new Image.asset(
                'assets/registration.png',
                width: 50.0,
                height: 100.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: new Container(
                  width: 400.0,
                  color: Colors.blue[50].withAlpha(200),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          autocorrect: false,
                            validator: (val) =>
                                val.isEmpty ? 'Enter your FirstName' : null,
                            onChanged: (val) {
                              setState(() => firstName = val);
                            },
                            decoration: new InputDecoration(
                              hintText: 'Enter your Firstname',
                            )),
                        new TextFormField(
                          autocorrect: false,
                            validator: (val) =>
                                val.isEmpty ? 'Enter your LastName' : null,
                            onChanged: (val) {
                              setState(() => lastName = val);
                            },
                            decoration: new InputDecoration(
                              hintText: 'Enter your Lastname',
                            )),
                        new TextFormField(
                          autocorrect: false,

                          keyboardType: TextInputType.emailAddress,
                            validator: (val) =>
                                val.isEmpty ? 'Enter your Email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            decoration: new InputDecoration(
                              hintText: 'Enter your E-mail Id',
                            )),
                        new TextFormField(
                          autocorrect: false,
                          validator: (val) =>
                              val.length < 6 ? 'Enter a strong password' : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          decoration: new InputDecoration(
                            hintText: 'Choose a password',
                          ),
                          obscureText: true,
                        ),
                        new TextFormField(
                          validator: (val) =>
                              val != password ? 'Password not matched' : null,
                          onChanged: (val) {
                            setState(() => passwordConf = val);
                          },
                          decoration: new InputDecoration(
                            hintText: 'Re-enter your password',
                          ),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            new Text(
                              "Set your Profile Picture : ",
                              style: TextStyle(fontSize: 20),
                              ),
                            new Container(
                              child: new RaisedButton(
                                child: new Text("Upload"),
                                onPressed: ()=> getImage(ImageSource.gallery),
                              ),

                            ),
                             
                          ],
                        ),
                        Center(

                      child: Container(
                        // height: 300,
                        // width: 300,
                        child:_selectedFile == null
                          ? Text("No image")
                          : Image.file(_selectedFile),

                      )   
                      
                    ),
                          SizedBox(
                          height: 20.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment(0, 0.55),
                              child: new RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            email, password);

                                    if (result == null) {
                                      setState(() => error =
                                          'Please supply a valid email');
                                    } else {
                                      // database.reference().child("User Details").push().set(
                                      //   {
                                      //     "firstName" : firstName,
                                      //     "lastName" : lastName,
                                      //     "email" : email

                                      //   } 
                                      // );
                                      _databaseService.userData(firstName, lastName, email);
                                      return Navigator.pop(context);
                                    }
                                  }
                                },
                                color: Colors.blue,
                                child: new Text(
                                  "Submit",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment(0, 0.7),
                              child: new Text(
                                "Already have an account? ",
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Align(
                                alignment: Alignment(0, 0.7),
                                child: new InkWell(
                                  child: new Text(
                                    "Login Here!",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.blue[300],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () => {
                                    Navigator.pop(context),
                                    
                                  },
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          (_inProcess) ? Container(
            child:Center(child: CircularProgressIndicator(),),
          ):Center()
        ],
      ),
    );
  }
}
