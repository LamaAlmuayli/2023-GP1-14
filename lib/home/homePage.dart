// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Community/View_article.dart';
import 'package:flutter_application_1/home/loadingpage.dart';
import 'package:flutter_application_1/shared/bottom_nav.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:intl/intl.dart';
import '../shared/nav_bar.dart';
import '../services/models.dart';
import '../services/firestore.dart';
import '../patient/patientPage.dart';
import 'package:carousel_slider/carousel_slider.dart';

class homePage extends StatelessWidget {
  const homePage({Key? key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFF186257),
      bottomNavigationBar: NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('AddpatientScreen');
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF186257),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<Therapist>(
                      stream: FirestoreService().streamTherapist(),
                      builder: (context, snapshot) {
                        String n = snapshot.data!.name;
                         if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingPage();
                            }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi $n!👋',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${DateTime.now().day} ${_getMonth(DateTime.now().month)}, ${DateTime.now().year}',
                              style: TextStyle(
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Color.fromARGB(255, 29, 116, 106),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Recent Articles',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    StreamBuilder<List<Article>>(
                      stream: FirestoreService().streamArticles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                         if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingPage();
                            }

                        List<Article> cardData = snapshot.data ?? [];

                        // Sort the list based on publishtime in descending order
                        cardData.sort(
                            (a, b) => b.PublishTime.compareTo(a.PublishTime));

                        // Take the first 5 articles
                        List<Article> recentArticles =
                            cardData.take(5).toList();

                        return Center(
                          child: CarouselSlider(
                            items: recentArticles.map((card) {
                              //String key = card.KeyWords;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            View_article(id: card.id)),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Image at the right side of the card
                                      Positioned(
                                        top: 20.0,
                                        right: 10.0,
                                        bottom: 20.0,
                                        width: 100.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          child: Image.network(
                                            card.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // Title beside the image
                                      Positioned(
                                        top: 30.0,
                                        left: 15.0,
                                        right: 120.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              card.Title,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,  fontFamily: 'RobotoSerif',) , 
                                                  
                                            ),
                                            SizedBox(height: 6),
                                             Row(
                                                    children: [
                                                      Icon(
                                                        Icons.account_circle,
                                                        size: 15,
                                                        color: Colors.yellow[900],
                                                      ),
                                                      // Add space between the left edge and the author name
                                                      Text(
                                                        card.name,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          // fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          fontFamily: 'RobotoSerif',
                                                        ),
                                                      ),
                                                    // Add space between the name and the icon
                                                    SizedBox(width: 50),
                                                    //  Text(
                                                    //             card.PublishTime != null
                                                    //                 ? DateFormat('yyyy-MM-dd')
                                                    //                     .format(card.PublishTime.toDate())
                                                    //                 : '',
                                                    //             style: TextStyle(
                                                    //                fontFamily: 'RobotoSerif',
                                                    //               fontSize: 10,
                                                    //               color: Colors.black,
                                                    //             ),
                                                    //           ),
                                                    ],
                                                  ), 
                                                  SizedBox(height: 5),
                                                  Text(
                                          
                                            card.Content.length > 60
                                                ? '${card.Content.substring(0, 60)}... '
                                                : card.Content,
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 62, 62, 62),
                                              fontSize: 11,
                                              fontFamily: 'RobotoSerif',
                                            ),
                                            //textAlign: TextAlign.justify,
                                          ),
                                          // Add "Read more" link if the content is longer
                                          if (card.Content.length > 60)
                                            TextButton(
                                              onPressed: () {
                                                // Handle "Read more" button click
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => View_article(id: card.id),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Read more',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // Text(
                                            //   'Keywords: $key',
                                            //   style: TextStyle(
                                            //     fontSize: 10,
                                            //      fontFamily: 'RobotoSerif',
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 200.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 2000),
                              viewportFraction: 0.8,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Patients',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Icon(Icons.filter_list),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: StreamBuilder<List<Patient>>(
                          stream: FirestoreService().streamPatients(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingPage();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.data!.isEmpty) {
                              return Column(
                                children: [
                                  SizedBox(height: 50),
                                  Text('No patients added yet'),
                                ],
                              );
                            }

                            List<Patient> patients = snapshot.data ?? [];

                            return Column(
                              children: patients.map(
                                (patient) {
                                  String pname = patient.name;
                                  String pnum = patient.patientNum;
                                  String gender = patient.gender;
                                  String avatar = 'man';
                                  switch (gender) {
                                    case 'F':
                                      avatar = 'woman';
                                      break;
                                    case 'M':
                                      avatar = 'man';
                                      break;
                                  }

                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: ListTile(
                                            leading: Image.asset(
                                              'images/$avatar.png',
                                              height: 40,
                                              width: 40,
                                            ),
                                            title: Text(pname),
                                            subtitle: Text('Patient #$pnum'),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PatientPage(pid: pnum)),
                                              );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}
