import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare/bookModel.dart';
import 'package:flare/providers.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;

    return AlertDialog(
      title: Text(
        'اعلاناتي',
        textDirection: TextDirection.rtl,
      ),
      content: Container(
        height: s.height / 2,
        width: s.width / 1.5,
        child: StreamBuilder<QuerySnapshot>(
          stream: BookModel.getBooksById(context.watch<Auth>().uid),
          builder: (context, snap) {
            if (snap.hasData) {
              final docs = snap.data.docs;

              if (docs.isEmpty)
                return  Center(
                  child: Text('لا يوجد اعلانات بحسابك'),
            );



              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final book =
                      Book.fromJson(docs[index].data(), docs[index].id);
                  String intro =
                      book.isRequest ? 'ابحث عن كتاب ' : 'امتلك كتاب ';

                  final date =
                      DateTime.fromMillisecondsSinceEpoch(book.timestamp);

                  return Card(
                    child: ListTile(
                      trailing: CircleAvatar(
                        backgroundImage: NetworkImage(book.image),
                        onBackgroundImageError: (exception, stackTrace) {},
                      ),
                      leading: s.width >= 500 ? FlatButton(
                        color: Colors.red,
                        child: Text(
                          'حذف',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          BookModel.deleteBookById(book.id);
                        },
                      ) : null,
                      title: Text(
                        book.name,
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            style: TextStyle(color: Colors.grey[700]),
                            children: [
                              TextSpan(
                                  text: intro + book.course,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '\nالتاريخ: ${date.month}/${date.day}' + '\n\n',
                                style: TextStyle(color: Colors.grey[500]),
                              ),



                              if (s.width < 500)
                              WidgetSpan(
                                child: FlatButton(
                                  color: Colors.red,
                                  child: Text(
                                    'حذف',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    BookModel.deleteBookById(book.id);
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: Text('لا يوجد اعلانات بحسابك'),
            );
          },
        ),
      ),
    );
  }
}
