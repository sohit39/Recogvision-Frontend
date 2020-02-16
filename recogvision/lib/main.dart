import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData.dark(),
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
            Person("Tony Riley", NetworkImage("https://i.imgur.com/9Di8DOg.jpeg")),
          ]
        )
    );
  }
}
class Person extends StatefulWidget{
  @override
  Person(this.name, this.avatar);
  final String name;
  final NetworkImage avatar;
  PersonState createState() => PersonState(name, avatar);
}

class PersonState extends State<Person>{
  PersonState(this.name, this.avatar);
  String name;
  NetworkImage avatar;
  Widget build(BuildContext context) {
    return Card(
      child:ExpansionTile(
          title: Text(
              name,
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
                    initialValue: name,
                    decoration: const InputDecoration(
                      hintText: "Name",
                    ),
                    maxLines: 1,
                    onChanged: (String input){
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
                ]
            )
          ]
      ),
    );
  }

  void changeNameTo(String i){
    setState(() {
      name = i;
    });
  }

}