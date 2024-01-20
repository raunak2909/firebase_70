import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_70/note_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").snapshots(),
        builder: (_, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(snapshot.hasError){
            return Center(
              child: Text('Error Occurred: ${snapshot.error}'),
            );
          } else if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index){
                  var eachNote = NoteModel.fromMap(snapshot.data!.docs[index].data());
                  return ListTile(
                    title: Text(eachNote.title),
                    subtitle: Text(eachNote.desc),
                  );
                });
          }


          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var fireStore = FirebaseFirestore.instance;

          /*await fireStore.collection("notes").doc("jfvnjvnfjnvfj").set({
            'title' : 'New Note',
            'desc' : 'Everything starts from you!'
          });*/

          showModalBottomSheet(context: context,
              builder: (context){
            return Container(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: titleController,
                    ),
                    TextField(
                      controller: descController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: (){
                          fireStore
                              .collection("notes")
                              .add(NoteModel(
                              title: titleController.text.toString(), desc: descController.text.toString())
                              .toMap())
                              .then((value) {
                            print('Note Added');
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Note Added Successfully!!')));
                          }).catchError((e) {
                            print("Error: $e");
                          });
                        }, child: Text('Add')),
                        ElevatedButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text('Cancel'))
                      ],
                    ),
                  ],
                ),
              ),
            );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

/*FutureBuilder(
future: FirebaseFirestore.instance.collection("notes").get(),
builder: (_, snapshot){
if(snapshot.connectionState==ConnectionState.waiting){
return Center(
child: CircularProgressIndicator(),
);
} else if(snapshot.hasError){
return Center(
child: Text('Error Occurred: ${snapshot.error}'),
);
} else if(snapshot.hasData){
return ListView.builder(
itemCount: snapshot.data!.docs.length,
itemBuilder: (_, index){
var eachNote = NoteModel.fromMap(snapshot.data!.docs[index].data());
return ListTile(
title: Text(eachNote.title),
subtitle: Text(eachNote.desc),
);
});
}


return Container();
},
)*/
