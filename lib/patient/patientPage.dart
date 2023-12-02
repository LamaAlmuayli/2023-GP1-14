// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/loadingpage.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/nav_bar.dart';
import '../services/models.dart';
import '../services/firestore.dart';
import '../patient/patientPage.dart';

class PatientPage extends StatelessWidget {
  // Constructor for PatientPage
  final String pid;
  const PatientPage({super.key, required this.pid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF186257),
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [  
              // Back button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: Color(0xFFFFFFFF),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                child: Column(
                  children: [
                    // Patient avatar and name display
                    Container(
                      child: StreamBuilder<Patient>(
                        stream: FirestoreService().streamPatient(pid),
                        builder: (context, snapshot) {
                          Patient p = snapshot.data!;
                          String name = p.name;
                          String gender = p.gender;
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
                              Image.asset(
                                'images/$avatar.png',
                                height: 120,
                                width: 120,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              // Patient information section
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: Container(
                  padding: EdgeInsets.all(30),
                  height: 500,
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display patient information
                      StreamBuilder<Patient>(
                        stream: FirestoreService().streamPatient(pid),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingPage();
                          }

                          Patient p = snapshot.data!;
                          String name = p.name;
                          String email = p.email;
                          String phone = p.phone;

                          return Column(
                            children: [
                              // Display patient details
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Patient Information',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text('Name: $name'),
                                      SizedBox(height: 7),
                                      Text('Patient Number: $pid'),
                                      SizedBox(height: 7),
                                      Text('Phone Number: $phone'),
                                      SizedBox(height: 7),
                                      Text('Email: $email'),
                                      SizedBox(height: 7),
                                    ],
                                  ),
                                  // Contact options
                                  GestureDetector(
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.message),
                                                title: const Text('Send SMS'),
                                                onTap: () async {
                                                  final phoneNumber =
                                                      '+966$phone';
                                                  final url = 'sms:$phoneNumber';

                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }

                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.email),
                                                title: const Text('Send Email'),
                                                onTap: () async {
                                                  final url = 'mailto:$email';

                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }

                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.phone),
                                                title: const Text('WhatsApp'),
                                                onTap: () async {
                                                  final phoneNumber =
                                                      '+966$phone';
                                                  final url =
                                                      'https://api.whatsapp.com/send?phone=$phoneNumber';

                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }

                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20.0),
                                      child: Image.asset(
                                        'images/contact.png',
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Program information and Generated reports sections
                      Container(
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.hail_outlined,
                            color: Color(0xFF186257),
                            size: 35,
                          ),
                          title: Text(
                            'Program Information',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.article,
                            color: Color(0xFF186257),
                            size: 35,
                          ),
                          title: Text(
                            'Generated Reports',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {},
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
