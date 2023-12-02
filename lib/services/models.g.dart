// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Json deserialization for Therapist model
Therapist _$TherapistFromJson(Map<String, dynamic> json) => Therapist(
      name: json['Full name'] as String? ?? '',
      jobTitle: json['Job Title'] as String? ?? '',
      hospitalClinic: json['HospitalClinic'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      password: json['Password'] as String? ?? '',
    );

// Json serialization for Therapist model
Map<String, dynamic> _$TherapistToJson(Therapist instance) => <String, dynamic>{
      'Full name': instance.name,
      'Job Title': instance.jobTitle,
      'HospitalClinic': instance.hospitalClinic,
      'Email': instance.email,
      'Password': instance.password,
    };

// Json deserialization for Patient model
Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      name: json['Patient Name'] as String? ?? '',
      phone: json['Phone Number'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      patientNum: json['Patient Number'] as String? ?? '',
      gender: json['Gender'] as String? ?? '',
    );

// Json serialization for Patient model
Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'Patient Name': instance.name,
      'Phone Number': instance.phone,
      'Email': instance.email,
      'Patient Number': instance.patientNum,
      'Gender': instance.gender,
    };

// Json deserialization for Article model
Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      Content: json['Content'] as String? ?? '',
      autherID: json['AutherID'] as String? ?? '',
      KeyWords: json['KeyWords'] as String? ?? '',
      PublishTime: json['PublishTime'] as Timestamp? ?? Timestamp.now(),
      Title: json['Title'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      id: json['ID'] as String? ?? '',
    );

// Json serialization for Article model
Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'Content': instance.Content,
      'AutherID': instance.autherID,
      'KeyWords': instance.KeyWords,
      'PublishTime': instance.PublishTime,
      'Title': instance.Title,
      'name': instance.name,
      'image': instance.image,
      'ID': instance.id,
    };
