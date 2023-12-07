import 'dart:convert';
import 'dart:io';

import 'package:contacts_manager/models/ContactGroup.dart';
import 'package:contacts_manager/models/GroupScreenActions.dart';
import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Contact.dart';
import '../../models/Group.dart';
import '../../utils/app_constants.dart';

enum ContactGroupTileMenuItem { update, delete }

class ContactGroupsScreen extends StatelessWidget {
  ContactGroupsScreen({super.key});

  ContactGroupTileMenuItem? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Groups'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder(
          future: _fetchAllContactGroups(context),
          builder: (context, AsyncSnapshot<ContactGroup> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitFadingCircle(
                  color: Palette.activeCardColor,
                ),
              );
            } else if (snapshot.hasError) {
              debugPrint(
                  "Contact Group error message: ${snapshot.error.toString()}");
              debugPrint(
                  "Contact Group snapshot.hasError: ${snapshot.toString()}");
              return Center(
                  child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ));
            } else if (snapshot.connectionState == ConnectionState.done) {
              final contactGroup = snapshot.data;

              if (snapshot.data!.contacts.isNotEmpty &&
                  snapshot.data!.groups.isNotEmpty) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          contactGroup?.groups[index].name ?? 'N/A',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          "${contactGroup?.contacts.where((contact) => contact.groupId == contactGroup.groups[index].groupId).length} contacts" ??
                              'N/A',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        trailing: PopupMenuButton<ContactGroupTileMenuItem>(
                          onSelected: (ContactGroupTileMenuItem item) =>
                              item == ContactGroupTileMenuItem.update
                                  ? Navigator.pushNamed(
                                      context, AppRoutes.group, arguments: {
                                      "contacts": contactGroup?.contacts
                                              .where((contact) =>
                                                  contact.groupId ==
                                                  contactGroup
                                                      .groups[index].groupId)
                                              .toList() ??
                                          [],
                                      "action": GroupScreenActions.update
                                    })
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      _showSuccessSnackBar(
                                          "Delete pressed", context)),
                          initialValue: selectedValue,
                          itemBuilder: (context) =>
                              <PopupMenuEntry<ContactGroupTileMenuItem>>[
                            const PopupMenuItem(
                              value: ContactGroupTileMenuItem.update,
                              child: Text('Update'),
                            ),
                            const PopupMenuItem(
                              value: ContactGroupTileMenuItem.delete,
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 25,
                        color: Palette.dashTileColor,
                      );
                    },
                    itemCount: contactGroup?.groups.length ?? 10);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info,
                        size: 80,
                      ),
                      Text(
                        'No group? \n Feel free to add one.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  'Still loading',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final unallocatedContacts =
                await _getAllUnallocatedContacts(context);
            Navigator.pushNamed(context, AppRoutes.group, arguments: {
              "contacts": unallocatedContacts,
              "action": GroupScreenActions.add
            });
          },
          elevation: 5,
          child: const Icon(
            Icons.add,
            color: Palette.primaryColor,
          )),
    );
  }

  SnackBar _showErrorSnackBar(String errorMessage, BuildContext context) {
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

  SnackBar _showSuccessSnackBar(String successMessage, BuildContext context) {
    return SnackBar(
        backgroundColor: Palette.activeCardColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          successMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }

  Future<List<Contact>> _getAllUnallocatedContacts(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);
      http.Response response = await http.get(
          Uri.parse('${AppConstants.BASE_URL}/unallocated_contacts'),
          headers: {
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
                _showErrorSnackBar('Server error. Try again later', context));
        return [];
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar(
              'Check your internet connection then try again', context));
      return [];
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<ContactGroup> _fetchAllContactGroups(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);
      http.Response response = await http
          .get(Uri.parse('${AppConstants.BASE_URL}/contact_groups'), headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        if (jsonMap['success']) {
          final fetchedContacts = <Contact>[];
          final fetchedGroups = <Group>[];
          var groupCounter = 0;

          for (var group in jsonMap['data']['data']) {
            fetchedGroups.add(Group.fromJson(group));
            for (var contact in jsonMap['data']['data'][groupCounter]
                ['contacts']) {
              fetchedContacts.add(Contact.fromJson(contact));
            }
            groupCounter++;
          }
          return ContactGroup(groups: fetchedGroups, contacts: fetchedContacts);
        } else {
          return ContactGroup(groups: [], contacts: []);
        }
      } else {
        var errorResponse = response.body;
        debugPrint("response error code : ${response.statusCode} \n"
            "response body : $errorResponse");
        ScaffoldMessenger.of(context)
            .showSnackBar(//todo: sort lint context rule later
                _showErrorSnackBar('Server error. Try again later', context));
        return ContactGroup(groups: [], contacts: []);
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar(
              'Check your internet connection then try again', context));
      return ContactGroup(groups: [], contacts: []);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return ContactGroup(groups: [], contacts: []);
    }
  }

  Future<void> deleteGroup(int? groupId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    try {
      http.Response response = await http.get(
          Uri.parse('${AppConstants.BASE_URL}/delete_contact_group/$groupId'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        if (jsonMap['success']) {
          _showSuccessSnackBar(jsonMap['message'], context);
        } else {
          _showErrorSnackBar(jsonMap['message'], context);
        }
      } else {
        var errorResponse = response.body;
        debugPrint("response error code : ${response.statusCode} \n"
            "response body : $errorResponse");
        ScaffoldMessenger.of(context).showSnackBar(
            //todo: sort lint context rule later
            _showErrorSnackBar('Server error. Try again later', context));
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar(
              'Check your internet connection then try again', context));
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
