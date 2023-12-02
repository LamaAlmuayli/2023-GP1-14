//all classes that will be converted to objects
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

// Include the generated part file
part 'models.g.dart';

// JsonSerializable class for Therapist model
@JsonSerializable()
class Therapist {
  final String name;
  final String jobTitle;
  final String hospitalClinic;
  final String email;
  final String password;
  
  Therapist({
    this.name = '',
    this.jobTitle = '',
    this.hospitalClinic = '',
    this.email = '',
    this.password = '',
  });

  // Factory methods for JSON serialization/deserialization
  factory Therapist.fromJson(Map<String, dynamic> json) =>
      _$TherapistFromJson(json);
  Map<String, dynamic> toJson() => _$TherapistToJson(this);
}

// JsonSerializable class for Patient model
@JsonSerializable()
class Patient {
  final String name;
  final String phone;
  final String email;
  final String patientNum;
  final String gender;

  Patient({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.patientNum = '',
    this.gender = '',
  });

  // Factory methods for JSON serialization/deserialization
  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}

// Class for Article model
class Article {
  final String id;
  final String Content;
  final String autherID;
  final String KeyWords;
  final Timestamp PublishTime;
  final String Title;
  final String name;
  final String image;

  Article({
    this.id = '',
    this.Content = '',
    this.KeyWords = '',
    required this.PublishTime,
    this.Title = '',
    this.autherID = '',
    this.name = '',
    this.image = '',
  });

  // Factory methods for JSON serialization/deserialization
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

// Placeholder classes
class Program {}

class Report {}

class Activity {}
