import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:new_parking_app/services/auth.dart';
import '../ui/home.dart';
import './register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parking Mobile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: new Stack(
        alignment: Alignment.topCenter,
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
              SizedBox(
                height: 40.0,
              ),
              Padding(padding: new EdgeInsets.all(5.0)),
              new Image.asset(
                'assets/login.png',
                height: 80.0,
              ),
              SizedBox(
                height: 45.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: new Container(
                  width: 400.0,
                  color: Colors.blue[50].withAlpha(200),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: new Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        Padding(padding: new EdgeInsets.all(8.0)),
                        new TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter your Email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            decoration: new InputDecoration(
                                hintText: 'Enter your Email',
                                icon: new Icon(Icons.person))),
                        SizedBox(
                          height: 10.0,
                        ),
                        new TextFormField(
                          validator: (val) => val.length < 6
                              ? 'Password should have more than 6 charactors'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          decoration: new InputDecoration(
                            hintText: 'Enter your Password',
                            icon: new Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        new Row(
                          children: <Widget>[
                            new Container(
                                margin: EdgeInsets.fromLTRB(105, 0, 0, 0),
                                child: new RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      dynamic result = await _auth
                                          .signInWithEmailAndPassword(
                                              email, password);

                                      if (result == null) {
                                        setState(() => error =
                                            'Could not signin using the credentials');
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage()));
                                      }
                                    }
                                  },
                                  color: Colors.blue,
                                  child: new Text(
                                    "Login",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                            new Container(
                                margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: new RaisedButton(
                                  onPressed: () => debugPrint("Clear button"),
                                  color: Colors.blue,
                                  child: new Text(
                                    "Clear",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                          ],
                         
                        ),
                         SizedBox(height: 10),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                        SizedBox(
                          height: 15.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment(0, 0.25),
                              child: new Text(
                                "Don't have an account yet? ",
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Align(
                                alignment: Alignment(0, 0.25),
                                child: new InkWell(
                                  child: new Text(
                                    "Register Here!",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.blue[300],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()),
                                    ),
                                  },
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
