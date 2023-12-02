import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:flutter_application_1/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream for monitoring changes in the 'Therapist' collection
  Stream<Therapist> streamTherapist() {
    var user = AuthService().user;
    if (user != null) {
      var ref = _db.collection('Therapist').doc(user.uid);
      return ref.snapshots().map((doc) => Therapist.fromJson(doc.data()!));
    } else {
      return Stream.fromIterable([Therapist()]);
    }
  }

  // Update therapist data in Firestore
  Future<void> updateTherapist(Map<String, dynamic> newData) async {
    var user = AuthService().user!;
    try {
      CollectionReference therapistCollection = _db.collection('Therapist');
      await therapistCollection.doc(user.uid).update(newData);
    } catch (e) {
      print('Error updating therapist: $e');
      throw e;
    }
  }

  // Stream for monitoring changes in the 'Patient' collection
  Stream<List<Patient>> streamPatients() {
    var ref = _db.collection('Patient');
    var user = AuthService().user!;
    return ref
        .where('TheraID', isEqualTo: user.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Patient.fromJson(doc.data()))
          .toList();
    });
  }

  // Stream for monitoring changes in a specific patient in the 'Patient' collection
  Stream<Patient> streamPatient(String pNum) {
    var user = AuthService().user;
    if (user != null) {
      var ref = _db.collection('Patient').doc(pNum);
      return ref.snapshots().map((doc) => Patient.fromJson(doc.data()!));
    } else {
      return Stream.fromIterable([Patient()]);
    }
  }

  // Add a new patient to the 'Patient' collection
  Future<void> addPatient(Patient patient) async {
    var user = AuthService().user!;
    try {
      CollectionReference patientCollection = _db.collection('Patient');
      await patientCollection.add({
        'Patient Name': patient.name,
        'Patient Number': patient.phone,
        'Email': patient.email,
        'TheraID': user.uid,
      });
    } catch (e) {
      print('Error adding patient: $e');
      throw e;
    }
  }

  // Update patient data in the 'Patient' collection
  Future<void> updatePatient(String pNum, Map<String, dynamic> newData) async {
    try {
      CollectionReference patientCollection = _db.collection('Patient');
      await patientCollection.doc(pNum).update(newData);
    } catch (e) {
      print('Error updating patient: $e');
      throw e;
    }
  }

  // Stream for monitoring changes in the 'Article' collection
  Stream<List<Article>> streamArticles() {
    var ref = _db.collection('Article');
    return ref.snapshots().map((QuerySnapshot snapshot) {
      List<Article> articles = [];
      for (var document in snapshot.docs) {
        Article article =
            Article.fromJson(document.data() as Map<String, dynamic>);
        articles.add(article);
      }
      return articles;
    });
  }

  // Stream for monitoring changes in the user's articles in the 'Article' collection
  Stream<List<Article>> streamMyArticles() {
    var ref = _db.collection('Article');
    var user = AuthService().user!;
    return ref
        .where('AutherID', isEqualTo: user.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Article.fromJson(doc.data()))
          .toList();
    });
  }

  // Stream for monitoring changes in a specific article in the 'Article' collection
  Stream<Article> streamArticle(String aid) {
    var user = AuthService().user;
    if (user != null) {
      var ref = _db.collection('Article').doc(aid);
      return ref.snapshots().map((doc) => Article.fromJson(doc.data()!));
    } else {
      return Stream.fromIterable([Article(PublishTime: Timestamp.now())]);
    }
  }

  // Add a new article to the 'Article' collection
  Future<void> addArticle(Article article) async {
    var user = AuthService().user!;
    try {
      CollectionReference articleCollection = _db.collection('Article');
      await articleCollection.add({
        'Title': article.Title,
        'Content': article.Content,
        'PublishTime': article.PublishTime,
        'authorID': article.autherID,
        'KeyWords': article.KeyWords,
      });
    } catch (e) {
      print('Error adding article: $e');
      throw e;
    }
  }

  // Update article data in the 'Article' collection
  Future<void> updateArticle(String articleId, Map<String, dynamic> newData) async {
    try {
      CollectionReference articleCollection = _db.collection('Article');
      await articleCollection.doc(articleId).update(newData);
    } catch (e) {
      print('Error updating article: $e');
      throw e;
    }
  }
}
