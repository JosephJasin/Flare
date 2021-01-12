import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Book {
  final String uid, course, facebook, whatsapp, image, name;
  final bool isRequest;

  String id;
  int timestamp;

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
        whatsapp = json['whatsapp'],
        timestamp = json['timestamp'];

  Map<String, dynamic> get toJson {
    return {
      'uid': uid,
      'isRequest': isRequest,
      'course': course,
      'image': image,
      'name': name,
      'facebook': facebook,
      'whatsapp': whatsapp,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  @override
  String toString() => toJson.toString();
}

class BookModel {
  static final _fire = FirebaseFirestore.instance;
  static final _posts = _fire.collection('posts');

  static Future<void> addBook(Book book) async {
    await _posts.add(book.toJson);
  }

  static Future<Book> getBookById(String id) async {
    final docSnap = await _posts.doc(id).get();
    return Book.fromJson(docSnap.data(), docSnap.id);
  }

  static Future<List<Book>> getBooks(bool isRequest, {String course}) async {
    Query query = _posts.where('isRequest', isEqualTo: isRequest);

    if (course != null) query = query.where('course', isEqualTo: course);

    final querySnap = await query.get();

    return querySnap.docs
        .map((doc) => Book.fromJson(doc.data(), doc.id))
        .toList();
  }
}
