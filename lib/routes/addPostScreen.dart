import 'package:flare/providers.dart';
import 'package:flare/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../bookModel.dart';


class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isRequest;

  final course = Wrapper<String>();

  final sKey = GlobalKey<ScaffoldState>();

  final facebook = TextEditingController();
  final whatsapp = TextEditingController();

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
                DropDownSearchable(course , setState),
                SizedBox(height: 25),
                Text(
                  'طريقة التواصل(قم بتحديد طريقة واحدة على الأقل)',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: facebook,
                  // textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.url,
                  maxLength: 256,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'رابط حسابك على الفيسبوك',
                  ),
                ),
                TextFormField(
                  controller: whatsapp,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.right,
                  maxLength: 15,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'رقم الهاتف',
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
              facebook.text = facebook.text.trim();
              whatsapp.text = whatsapp.text.trim();

              String error;
              if (isRequest == null)
                error = 'قم باختيار نوع الأعلان';
              else if (course.value == null)
                error = 'قم باختيار اسم المادة';
              else if (facebook.text.isEmpty && whatsapp.text.isEmpty)
                error = 'قم بادخال طريقة تواصل';

              if (facebook.text.isNotEmpty &&
                  validFacebookUrl(facebook.text) == null) {
                error = 'رابط حساب الفيسوبك غير صحيح';
              }

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
                  image: context.read<Auth>().currentUser.photoURL,
                  name:  context.read<Auth>().currentUser.displayName,
                  facebook: facebook.text.trim(),
                  whatsapp: whatsapp.text.trim(),
                ));

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
