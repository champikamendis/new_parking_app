import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  int count = 0;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("test"),),
      body: FloatingActionButton(onPressed: (){
        showModalBottomSheet(
          context:context,
          builder: (BuildContext context) { 
            return Container(
              child:Column(children: <Widget>[
                new Container(
                  child:RaisedButton(
                    child: Text("Tap Here"),
                    onPressed: (){
                      setState(() {
                        count = count + 1;
                      });
                    },),
                ),
                new Text("$count")
              ],)


            );


       });}) ,
    );
  }
}
