import 'package:flutter_application_1/signin/changePass.dart';
import 'package:flutter_application_1/Community/community.dart';
import 'package:flutter_application_1/signin/edit_pass_auth.dart';
import 'package:flutter_application_1/empty.dart';
import 'package:flutter_application_1/patient/AddPatient.dart';
import 'package:flutter_application_1/profile/edit_profile.dart';
import 'package:flutter_application_1/signin/forgot_password.dart';
import 'package:flutter_application_1/home/homePage.dart';
import 'package:flutter_application_1/profile/profilePage.dart';
import 'package:flutter_application_1/signin/signin_form.dart';
import 'package:flutter_application_1/signin/signup_form.dart';
import 'package:flutter_application_1/home/splash_Page.dart';
import 'package:flutter_application_1/Community/write_article.dart';

var appRoutes = {
  '/': (context) => const HomePage(),
  'signupScreen': (context) => const SignUpForm(),
  'signinScreen': (context) => const SignInForm(),
  'AddpatientScreen': (context) => const AddPatient(),
  'homepage': (context) => const homePage(),
  'profilepage': (context) => const profile(),
  //'patientpage': (context) => const PatientPage(),
  'editprofilepage': (context) => const editprofile(),
  'forgetpasswordScreen': (context) => const ForgotPasswordForm(),
  'communitypage': (context) => Community(),
  'empty': (context) => const Empty(),
  'profilepage': (context) => const profile(),
  'editprofilepage': (context) => const editprofile(),
  'edit_pass_auth': (context) => edit_pass_auth(),
  'changePass': (context) => changePass(),
  'Write_article': (context) => Write_article(),
};
