import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memo_app/model/memo.dart';

class MemoPage extends StatelessWidget {
  final QueryDocumentSnapshot memo;
  MemoPage(this.memo);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the TopPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(memo.get('title')),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('メモ内容', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(memo.get('detail'), style: TextStyle(fontSize: 18)),
            ],
          ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}