import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditMemoPage extends StatefulWidget {
  final QueryDocumentSnapshot? memo;
  AddEditMemoPage({this.memo});

  @override
  _AddEditMemoPageState createState() => _AddEditMemoPageState();
}

class _AddEditMemoPageState extends State<AddEditMemoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<void> addMemo() async {
    var collection = FirebaseFirestore.instance.collection('memo');
    collection.add({
      'title': titleController.text,
      'detail': detailController.text,
      'created_at': Timestamp.now(),
    });
  }
  
  Future<void> updateMemo() async {
    var document = FirebaseFirestore.instance.collection('memo').doc(widget.memo?.id);
    document.update({
      'title': titleController.text,
      'detail': detailController.text,
      'updated_at': Timestamp.now(),
    });
  }

  @override
  void initState() {
    if(widget.memo != null){
      titleController.text = widget.memo?.get('title');
      detailController.text = widget.memo?.get('detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo == null ? 'メモを追加' : 'メモを編集')
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('タイトル'),
              ),
              Padding(
                  padding: EdgeInsets.only(top:15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10)
                      ),
                    ),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('詳細'),
              ),
              Padding(
                padding: EdgeInsets.only(top:15.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: detailController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10)
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                    ),
                    onPressed: () async {
                      if (widget.memo == null) {
                        await addMemo();
                      } else {
                        await updateMemo();
                      }
                      Navigator.pop(context);
                    },
                    child: Text('ボタン'),
                  ),
                ),
              )
            ],
        ),
      )
    );
  }
}
