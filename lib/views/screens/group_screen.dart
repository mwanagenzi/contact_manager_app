import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_name_generator/random_name_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Contact.dart';
import '../../utils/app_constants.dart';
import '../theme/color_palette.dart';

class GroupScreen extends StatefulWidget {
  final List<Contact> contacts;

  const GroupScreen({required this.contacts, super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final _selectedItems = <int>[];
  final _contactIds = <int>[];
  var _isSelected = false;

  @override
  void initState() {
    // TODO: initialize selectedItems
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: _selectedItems.contains(index)
                    ? Palette.activeCardColor
                    : Colors.transparent,
                onLongPress: () {
                  setState(() {
                    if (_isSelected) {
                      _isSelected = false;
                      _selectedItems.remove(index);
                      _contactIds.add(widget.contacts[index].id ?? 0);
                    } else {
                      _isSelected = true;
                      _selectedItems.add(index);
                      _contactIds.remove(widget.contacts[index].id ?? 0);
                    }
                  }); //highlight the contact
                },
                leading: const CircleAvatar(
                  child: FlutterLogo(size: 20),
                ),
                title: Text(
                  "${widget.contacts[index].firstName}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Text(
                  "${widget.contacts[index].phone}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    //todo: delete contact from group
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 25,
                color: Palette.dashTileColor,
              );
            },
            itemCount: widget.contacts.length),
      ),
    );
  }

  Future<List<Contact>> getAllContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);
      http.Response response = await http
          .get(Uri.parse('${AppConstants.BASE_URL}/contacts'), headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        if (jsonMap['success']) {
          final contacts = <Contact>[];
          for (var contact in jsonMap['data']) {
            contacts.add(Contact.fromJson(contact));
          }
          return contacts;
        } else {
          return [];
        }
      } else {
        var errorResponse = response.body;
        debugPrint("response error code : ${response.statusCode} \n"
            "response body : $errorResponse");
        ScaffoldMessenger.of(context)
            .showSnackBar(//todo: sort lint context rule later
                _showErrorSnackBar('Server error. Try again later'));
        return [];
      }
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar('Check your internet connection then try again'));
      return [];
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future addContactsToGroup(List<int> contactIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);
      final randomName = RandomNames(Zone.us);

      http.Response response = await http.post(
          Uri.parse('${AppConstants.BASE_URL}/add_contact_group'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, dynamic>{
            "name": randomName.name(),
            "contact_ids": _selectedItems
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        if (jsonMap['success']) {
          ScaffoldMessenger.of(context)
              .showSnackBar(_showSuccessSnackBar(jsonMap['message']));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(_showErrorSnackBar(jsonMap['message']));
        }
      } else {
        var errorResponse = response.body;
        debugPrint("response error code : ${response.statusCode} \n"
            "response body : $errorResponse");
        ScaffoldMessenger.of(context)
            .showSnackBar(//todo: sort lint context rule later
                _showErrorSnackBar('Server error. Try again later'));
      }
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar('Check your internet connection then try again'));
      return [];
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  SnackBar _showErrorSnackBar(String errorMessage) {
    return SnackBar(
        backgroundColor: Palette.tileDividerColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }

  SnackBar _showSuccessSnackBar(String errorMessage) {
    return SnackBar(
        backgroundColor: Palette.activeCardColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }
}
