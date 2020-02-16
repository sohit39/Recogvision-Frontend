import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Live(),
    );
  }
}

class Live extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      body: Center(
        child: Text('Where the live video will be')
      ),
      floatingActionButton: Container(
        width: 80,
        height: 80,
        child:FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonList()));
          },
          child: Icon(Icons.people, size: 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          foregroundColor: Color.fromARGB(255, 250, 250, 250),
        ),
      )
    );
  }
}

class PersonList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
        body:ListView(
          children: [
            FlatButton(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Live()));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )
            ),
            person(NetworkImage("https://www.biography.com/.image/t_share/MTQyMDA0NDgwMzUzNzcyNjA2/mark-zuckerberg_gettyimages-512304736jpg.jpg"), "Tony Riley"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Dean Zhou"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Sohit Gatiganti"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Aaron Li"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Random Kid"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Patti Jeff"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Kappa Pride"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Eugene Tian"),
            person(NetworkImage("C:/Users/antho/Pictures/zuck.jpg"), "Coca Cola"),
          ]
        )
    );
  }
}

Card person(NetworkImage avatar, String name) => Card(
      child:ExpansionTile(
        title: Text(name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )
        ),
        leading: CircleAvatar(
          backgroundImage: avatar,
          radius: 25,
        ),
        children: <Widget> [
          Column(
            children:<Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
                maxLines: 1,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Additional Info",
                ),
                minLines: 1,
                maxLines: 3,
                maxLength: 250,
              )
            ]
          )
        ]
      ),
    );