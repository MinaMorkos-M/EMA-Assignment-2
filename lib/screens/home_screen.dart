import 'package:ema_ass2/screens/add_to_fav.dart';
import 'package:ema_ass2/screens/measure_distance.dart';
import 'package:ema_ass2/screens/view_all_stores.dart';
import 'package:ema_ass2/screens/view_fav.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stores App'),
        centerTitle: true,        
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text('View All stores'),
            trailing: Icon(Icons.keyboard_arrow_right_sharp),
            onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAllStores(),
                    ),
                  );
                },
          ),
          Divider(),
          ListTile(
            title: Text('Add To Favorites'),
            trailing: Icon(Icons.keyboard_arrow_right_sharp),
            onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddToFav(),
                    ),
                  );
                },
          ),
          Divider(),
          ListTile(
            title: Text('View Favorites'),
            trailing: Icon(Icons.keyboard_arrow_right_sharp),
            onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewFav(),
                    ),
                  );
                },
          ),
          Divider(),
          ListTile(
            title: Text('Measure Distance'),
            trailing: Icon(Icons.keyboard_arrow_right_sharp),
            onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeasureDistance(),
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
} 