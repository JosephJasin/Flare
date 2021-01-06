import 'package:dropdown_search/dropdown_search.dart';
import 'package:flare/providers.dart';
import 'package:flare/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../bookModel.dart';

import 'courses.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isRequest;

  final course = Wrapper<String>();

  final sKey = GlobalKey<ScaffoldState>();

  final contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return SimpleDialog(
      elevation: 10,
      titlePadding: EdgeInsets.only(right: 14, left: 15, top: 10, bottom: 20),
      title: Stack(
        textDirection: TextDirection.rtl,
        children: [
          const Text('اضافة اعلان جديد'),
          Positioned(
            left: 0,
            child: IconButton(
              tooltip: 'الغاء',
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      children: [
        Container(
          height: s.height / 2,
          width: s.width / 3,
          child: Scaffold(
            key: sKey,
            backgroundColor: Colors.transparent,
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              children: [
                Text(
                  'أريد أن',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                RadioListTile<bool>(
                  contentPadding: EdgeInsets.only(left: 5, top: 5),
                  title: const Text(
                    'ابحث عن كتاب',
                    textDirection: TextDirection.rtl,
                  ),
                  groupValue: isRequest,
                  value: true,
                  onChanged: (value) {
                    setState(() => isRequest = value);
                  },
                ),
                RadioListTile<bool>(
                  contentPadding: EdgeInsets.only(left: 5),
                  title: const Text(
                    'امنح كتاب',
                    textDirection: TextDirection.rtl,
                  ),
                  groupValue: isRequest,
                  value: false,
                  onChanged: (value) {
                    setState(() => isRequest = value);
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                DropDownSearchable(course),
                TextFormField(
                  controller: contactController,
                  // textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLength: 256,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'طريقة التواصل',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: FlatButton(
            minWidth: s.width / 3,
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(
                color: Colors.grey[300],
              ),
            ),
            child: Text(
              'نشر',
              style: TextStyle(
                fontSize: s.height / 35,
              ),
            ),
            onPressed: () async {


              String error;
              if (isRequest == null)
                error = 'قم باختيار نوع الأعلان';
              else if (course == null)
                error = 'قم باختيار اسم المادة';
              else if (contactController.text.trim().isEmpty)
                error = 'قم بادخال طريقة التواصل';
              if (error != null)
                sKey.currentState
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        error,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              else {
                await BookModel.addBook(Book(
                    uid: context.read<Auth>().uid,
                    isRequest: isRequest,
                    course: course.value,
                    contactInfo: contactController.text));

                await Navigator.of(context).maybePop();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    'تم اضافة اعلانك بنجاح',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ));
              }
            },
          ),
        ),
      ],
    );
  }
}
