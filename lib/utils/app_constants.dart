import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/home';
  static const recents = '/recents';
  static const contacts = '/contacts';
  static const profile = '/profile';
  static const favourites = '/favourites';
  static const login = '/login';
  static const resetPassword = '/resetPassword';
  static const search = '/search';
  static const signUp = '/signUp';
  static const groups = '/groups';
  static const group = '/groups/group';
  static const welcome = '/';
  static const contact = '/contacts/contact';
}

class AppConstants {
  static List<DropdownMenuItem<String>> genderItems = const [
    DropdownMenuItem(value: 'Male', child: Text('Male')),
    DropdownMenuItem(value: 'Female', child: Text('Female')),
  ];

  static List<DropdownMenuItem<String>> designationItems = const [
    DropdownMenuItem(value: 'Student', child: Text('Student')),
    DropdownMenuItem(value: 'Associate', child: Text('Associate')),
    DropdownMenuItem(value: 'STEM Staff', child: Text('STEM staff')),
  ];
  static List<DropdownMenuItem<String>> evangelisticTeamItems = const [
    DropdownMenuItem(value: 'CET', child: Text('CET')),
    DropdownMenuItem(value: 'UET', child: Text('UET')),
    DropdownMenuItem(value: 'MUBET', child: Text('MUBET')),
    DropdownMenuItem(value: 'EMUSETA', child: Text('EMUSETA')),
    DropdownMenuItem(value: 'NET', child: Text('NET')),
    DropdownMenuItem(value: 'WESO', child: Text('WESO')),
    DropdownMenuItem(value: 'RIVET', child: Text('RIVET')),
  ];
  static List<DropdownMenuItem<String>> ministryItems = const [
    DropdownMenuItem(value: 'Ushering', child: Text('Ushering')),
    DropdownMenuItem(value: 'PW', child: Text('P/W')),
    DropdownMenuItem(value: 'Catering', child: Text('Catering')),
    DropdownMenuItem(value: 'I.T', child: Text('I.T')),
    DropdownMenuItem(
        value: 'Instrumentalists', child: Text('Instrumentalists')),
    DropdownMenuItem(value: 'Choir', child: Text('Choir')),
    DropdownMenuItem(value: 'Outreach', child: Text('Outreach')),
    DropdownMenuItem(value: 'Sunday School', child: Text('Sunday School')),
    DropdownMenuItem(value: 'Literature', child: Text('Literature')),
    DropdownMenuItem(value: 'Intercessory', child: Text('Intercessory')),
    DropdownMenuItem(value: 'Publicity', child: Text('Publicity')),
    DropdownMenuItem(value: 'Ebenezer', child: Text('Ebenezer')),
  ];

  static List<DropdownMenuItem<String>> cohortItems = const [
    DropdownMenuItem(value: 'Y1S1', child: Text('Y1S1')),
    DropdownMenuItem(value: 'Y1S2', child: Text('Y1S2')),
    DropdownMenuItem(value: 'Y1S3', child: Text('Y1S3')),
    DropdownMenuItem(value: 'Y2S1', child: Text('Y2S1')),
    DropdownMenuItem(value: 'Y2S2', child: Text('Y2S2')),
    DropdownMenuItem(value: 'Y2S3', child: Text('Y2S3')),
    DropdownMenuItem(value: 'Y3S1', child: Text('Y3S1')),
    DropdownMenuItem(value: 'Y3S2', child: Text('Y3S2')),
    DropdownMenuItem(value: 'Y3S3', child: Text('Y3S3')),
    DropdownMenuItem(value: 'Y4S1', child: Text('Y4S1')),
    DropdownMenuItem(value: 'Y4S2', child: Text('Y4S2')),
    DropdownMenuItem(value: 'Y4S3', child: Text('Y4S3')),
    DropdownMenuItem(value: 'Y5S1', child: Text('Y5S1')),
    DropdownMenuItem(value: 'Y5S2', child: Text('Y5S2')),
    DropdownMenuItem(value: 'Y5S3', child: Text('Y5S3')),
  ];
}
