import 'package:dropdown_search/dropdown_search.dart';
import 'package:flare/providers.dart';
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

  String course;

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
                DropdownSearch<String>(
                  showSearchBox: true,
                  showClearButton: true,
                  dropdownBuilder: (context, selectedItem, itemAsString) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        itemAsString,
                      ),
                    );
                  },
                  mode: Mode.MENU,
                  selectedItem: course,
                  autoFocusSearchBox: true,
                  dropdownSearchDecoration: InputDecoration(
                    suffix: course == null
                        ? Padding(
                            padding: EdgeInsets.only(right: 9),
                            child: RichText(
                              textDirection: TextDirection.rtl,
                              text: TextSpan(children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                    text: '  اختر المادة',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ]),
                            ),
                          )
                        : null,
                  ),
                  dropDownButton: course == null ? Container() : null,
                  onFind: (String filter) async => courses,
                  itemAsString: (String u) => u,
                  onChanged: (String data) {
                    setState(() {
                      course = data;
                    });
                  },
                ),
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
                  maxLength: 10,
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
              else if (course == null)
                error = 'قم باختيار اسم المادة';
              else if (facebook.text.isEmpty && whatsapp.text.isEmpty)
                error = 'قم بادخال طريقة تواصل';

              if (facebook.text.isNotEmpty &&
                  validFacebookUrl(facebook.text) == null) {
                error = 'رابط حساب الفيسوبك غير صحيح';
              }

              if (whatsapp.text.isNotEmpty &&
                  validPhoneNumber(whatsapp.text) == null) {
                error = ' رقم الهاتف غير صحيح';
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
                  course: course,
                  image: context.read<Auth>().currentUser.photoURL,
                  name: context.read<Auth>().currentUser.displayName,
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

String validFacebookUrl(String url) {
  url = url.toLowerCase();

  if (!url.contains('facebook.com')) return null;

  try {
    return 'https://www.facebook.com/${url.substring(url.indexOf('facebook.com') + 13)}';
  } catch (e) {
    return null;
  }
}

String validPhoneNumber(String p) {
  if (p.length != 10) return null;

  if (!p.startsWith('07')) return null;

  return p;
}
