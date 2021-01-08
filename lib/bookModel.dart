import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Book {
  final String uid, course, facebook, whatsapp, image, name;
  final bool isRequest;

  String id;

  Book({
    @required this.uid,
    @required this.isRequest,
    @required this.course,
    @required this.image,
    @required this.name,
    this.facebook,
    this.whatsapp,
  }) : assert(facebook != null || whatsapp != null);

  Book.fromJson(Map<String, dynamic> json, [this.id])
      : uid = json['uid'],
        name = json['name'],
        isRequest = json['isRequest'],
        course = json['course'],
        image = json['image'],
        facebook = json['facebook'],
        whatsapp = json['whatsapp'];

  Map<String, dynamic> get toJson {
    return {
      'uid': uid,
      'isRequest': isRequest,
      'course': course,
      'image': image,
      'name' : name,
      'facebook': facebook,
      'whatsapp': whatsapp,
    };
  }

  @override
  String toString() => toJson.toString();
}

class BookModel {
  static final _fire = FirebaseFirestore.instance;
  static final _posts = _fire.collection('posts');

  static Future<void> addBook(Book book) async {
    await _posts.doc().set(book.toJson);
  }

  static Future<Book> getBookById(String id) async {
    final docSnap = await _posts.doc(id).get();
    return Book.fromJson(docSnap.data(), docSnap.id);
  }

  static Future<List<Book>> getBooks(bool isRequest, {String course}) async {
    Query query = _posts.where('isRequest', isEqualTo: isRequest);

    if (course != null)
      query = query.where('course' , isEqualTo: course);

    final querySnap = await query.get();

    return querySnap.docs
        .map((doc) => Book.fromJson(doc.data(), doc.id))
        .toList();
  }
}

String validFacebookUrl(String url) {
  url = url.toLowerCase();
  String pattern =
      r"^((https://www.)|(https://)|(www.)|[ ])?facebook.com/[\w\.]{1,}";
  RegExp validator = RegExp(pattern);
  return validator.stringMatch(url);
}

String validPhoneNumber(String p) {
  String pattern = r"^((00962)|(\+962)|(0))7[7-9]\d{7}$";
  RegExp validator = RegExp(pattern);
  return validator.stringMatch(p);
}
