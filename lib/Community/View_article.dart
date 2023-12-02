import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/authentic.dart';
import 'package:flutter_application_1/services/firestore.dart';
import 'package:flutter_application_1/services/models.dart';
import 'package:flutter_application_1/shared/background.dart';
import 'package:flutter_application_1/shared/nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../home/loadingpage.dart';

// Define a StatefulWidget for the 'View_article' screen
class View_article extends StatefulWidget {
  final String id;
  const View_article({Key? key, required this.id}) : super(key: key);

  @override
  View_article_State createState() => View_article_State();
}

// Define the corresponding State class for the 'View_article' screen
class View_article_State extends State<View_article> {

  // Stream for monitoring changes in the 'Article' collection
  late Stream<QuerySnapshot<Map<String, dynamic>>> ArticleStream =
      FirebaseFirestore.instance.collection('Article').snapshots();

  // Function to delete an article
  Future<void> deleteArticle(String id) async {
    // Display a confirmation dialog before deleting the article
    bool? deleteConfirmed = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this article?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed == true) {
    
        // Deleting the article from Firestore
        await FirebaseFirestore.instance.collection('Article').doc(id).delete();
        Navigator.of(context).pushNamed('communitypage');
        QuickAlert.show(
          context: context,
          text: "The article is deleted successfully!",
          type: QuickAlertType.success,
        );
      // } catch (e) {
      //   // Handling deletion error
      //   print('Error deleting article: $e');
      //   QuickAlert.show(
      //     context: context,
      //     text: "Failed to delete the article!",
      //     type: QuickAlertType.error,
      //   );
      // }
    }
  }

  bool isFavorite = false;
  bool isAuthor = false;
  var user = AuthService().user;

  @override
  Widget build(BuildContext context) => StreamBuilder<Article>(
        stream: FirestoreService().streamArticle(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          }
          Article article = snapshot.data!;
          String Title = article.Title;
          String Content = article.Content;
          String autherID = article.autherID;
          bool isMyArticle = autherID == user!.uid;
          String name = article.name;
          Timestamp publishTime = article.PublishTime;

          return Scaffold(
            body: Stack(
              children: [
                // Displaying the article image
                Image.network(article.image),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    color: Color.fromRGBO(24, 98, 87, 1),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Displaying the article title
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(7, 0, 6, 0),
                                  child: Text(
                                    Title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RobotoSerif',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Displaying the author name and publish time
                            Row(
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  size: 23,
                                  color: Colors.yellow[900],
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'RobotoSerif',
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 120),
                                Text(
                                  publishTime != null
                                      ? DateFormat('yyyy-MM-dd').format(publishTime.toDate())
                                      : '',
                                  style: TextStyle(
                                    fontFamily: 'RobotoSerif',
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Displaying the article content
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
                              child: Text(
                                Content,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 62, 62, 62),
                                  fontSize: 15,
                                  fontFamily: 'RobotoSerif',
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Displaying additional options for the author (delete article)
                Positioned(
                  top: 260,
                  right: 30,
                  child: isMyArticle
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Delete') {
                              deleteArticle(widget.id);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                          ],
                          child: Icon(
                            Icons.more_vert,
                            size: 35,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          offset: Offset(0, 32),
                          padding: EdgeInsets.symmetric(horizontal: 25),
                        )
                      : Container(),
                ),
                // Adding a back button to navigate back to the previous screen
                Positioned(
                  top: 20,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: NavBar(),
          );
        },
      );
}

// Extension to add isAlphaOnly property for String validation
extension StringValidation on String {
  bool get isAlphaOnly => this.runes.every(
        (rune) => (rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122),
      );
}
