import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String uid, faculty, course, contactInfo;
  final bool isRequest;

  String id;

  Book({
    @required this.uid,
    @required this.isRequest,
    @required this.faculty,
    @required this.course,
    @required this.contactInfo,
  });

  Book.fromJson(Map<String, dynamic> json, [this.id])
      : uid = json['uid'],
        isRequest = json['isRequest'],
        faculty = json['faculty'],
        course = json['course'],
        contactInfo = json['contactInfo'];

  Map<String, dynamic> get toJson {
    return {
      'uid': uid,
      'isRequest': isRequest,
      'faculty': faculty,
      'course': course,
      'contactInfo': contactInfo,
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

  static Future<List<Book>> getBooks(String faculty,
      {String course, bool isRequest}) async {
    Query query = _posts.where('faculty', isEqualTo: faculty);

    if (course != null) query = query.where('course', isEqualTo: course);

    if (isRequest != null)
      query = query.where('isRequest', isEqualTo: isRequest);

    QuerySnapshot querySnap = await query.get();

    return querySnap.docs
        .map((doc) => Book.fromJson(doc.data(), doc.id))
        .toList();
  }
}
