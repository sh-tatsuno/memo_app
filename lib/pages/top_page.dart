import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memo_app/model/memo.dart';
import 'package:memo_app/pages/add_edit_memo_page.dart';
import 'package:memo_app/pages/memo_page.dart';

class TopPage extends StatefulWidget {
  TopPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  late CollectionReference memos;

  Future<void> deleteMemo(String docId) async {
    var document = FirebaseFirestore.instance.collection('memo').doc(docId);
    document.delete();
  }

  List<Memo> memoList = [];
  @override
  void initState(){
    super.initState();
    memos = FirebaseFirestore.instance.collection('memo');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the TopPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memos.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data!.docs[index].get('title')),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit, color: Colors.blueAccent),
                                title: Text("編集"),
                                onTap:(){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage(memo: snapshot.data!.docs[index])));
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.delete, color: Colors.redAccent),
                                title: Text("削除"),
                                onTap:() async {
                                  await deleteMemo(snapshot.data!.docs[index].id);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => MemoPage(snapshot.data!.docs[index])));
                  },
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


