import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Container(
          decoration: BoxDecoration(
            // color: Color.fromARGB(255, 3, 27, 47).withOpacity(0.8),
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: InkWell(
              splashColor: Colors.blue[400],
              onTap: onTap,
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(icon),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(text, style: TextStyle(fontSize: 16.0)))
                      ],
                    ),
                    Icon(Icons.arrow_right)
                  ],
                ),
              )),
        ));
  }
}
