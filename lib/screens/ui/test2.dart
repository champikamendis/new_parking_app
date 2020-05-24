import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
 final List<IconData> _icons = [
        Icons.offline_bolt,
        Icons.ac_unit,
        Icons.dashboard,
        Icons.backspace,
        Icons.cached,
        Icons.edit,
        Icons.face,
    ];

    List<IconData> _selectedIcons = [];

    @override
    Widget build(BuildContext context) {
        Widget gridViewSelection = GridView.count(
            childAspectRatio: 2.0,
            crossAxisCount: 3,
            mainAxisSpacing: 20.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            children: _icons.map((iconData) {
                return GestureDetector(
                    onTap: () {
                        _selectedIcons.clear();

                        setState(() {
                            _selectedIcons.add(iconData);
                        });
                    },
                    child: GridViewItem( _selectedIcons.contains(iconData)),
                );
            }).toList(),
        );

        return Scaffold(
            appBar: AppBar(
                title: Text('Selectable GridView'),
            ),
            body: gridViewSelection,
        );
    }


  }

  class GridViewItem extends StatelessWidget {
    
    final bool _isSelected;

    GridViewItem( this._isSelected);

    @override
    Widget build(BuildContext context) {
        return Container(
          height: 20,
          width: 20,
          child: RawMaterialButton(
              
              // shape: CircleBorder(),
              fillColor: _isSelected ? Colors.blue : Colors.grey,
              onPressed: null,
          ),
        );
    }
}
