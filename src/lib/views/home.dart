import 'package:flutter/material.dart';
import 'package:sos_aguas/models/current_setting.dart';
import 'package:sos_aguas/views/report_edit_screen.dart';
import 'package:sos_aguas/widgets/map_screen.dart';
import 'package:sos_aguas/widgets/news_screen.dart';

import 'login_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    NewsScreen(),
    Center(child: Text('Pesquisar', style: TextStyle(fontSize: 24))),
    MapScreen(),
    //EditReportScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditReportScreen(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void logout(BuildContext context) {
    var stng = CurrentSetting();
    stng.Save();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SOS Águas"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => logout(context),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Pesquisar'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'SOS'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
