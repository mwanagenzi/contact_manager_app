import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_manager/models/GroupScreenActions.dart';
import 'package:contacts_manager/views/screens/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Contact.dart';
import '../../utils/app_constants.dart';
import '../theme/color_palette.dart';

class GroupScreen extends StatefulWidget {
  // final List<Contact> contacts;
  final Map<String, dynamic> groupScreenData;

  const GroupScreen({required this.groupScreenData, super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final _selectedItems = <int>[];
  List<ContactListItem<Contact>> contactListItems = [];

  // var _isSelected = false;
  late TextEditingController _groupNameTextEditingController;

  @override
  void initState() {
    // TODO: initialize selectedItems
    assignContactListItem(widget.groupScreenData['contacts']);
    _groupNameTextEditingController = TextEditingController();
    super.initState();
  }

  void assignContactListItem(List<Contact> contacts) {
    for (var contact in contacts) {
      contactListItems.add(ContactListItem<Contact>(contact));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Contact> contacts = widget.groupScreenData['contacts'];
    final GroupScreenActions action = widget.groupScreenData['action'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            action == GroupScreenActions.add ? 'New Group' : 'Update Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (contactListItems.any((item) => item.isSelected)) {
                    setState(() {
                      contactListItems[index].isSelected =
                          !contactListItems[index].isSelected;
                    });
                  }
                },
                onLongPress: () {
                  setState(() {
                    contactListItems[index].isSelected = true;
                  });
                },
                child: ListTile(
                  tileColor: contactListItems[index].isSelected
                      ? Palette.activeCardColor
                      : Colors.transparent,
                  leading: CircleAvatar(
                    maxRadius: 20,
                    minRadius: 10,
                    backgroundColor: Colors.transparent,
                    child: CachedNetworkImage(
                      imageUrl:
                          contacts[index].imageUrl ?? AppConstants.AVATAR_URL,
                      //todo: solve problem in fetching image url
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                        ),
                      ),
                      placeholder: (context, _) => SpinKitFadingCircle(
                        itemBuilder: (BuildContext context, int index) {
                          return const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Palette.activeCardColor,
                            ),
                          );
                        },
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    "${contacts[index].firstName}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    "${contacts[index].phone}",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 25,
                color: Palette.dashTileColor,
              );
            },
            itemCount: contacts.length),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: action == GroupScreenActions.add
              ? () async {
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Group name"),
                            content: ProfileFormField(
                              labelText: "Group name",
                              formIcon: Icons.groups,
                              textInputType: TextInputType.text,
                              obscureText: false,
                              textEditingController:
                                  _groupNameTextEditingController,
                              isEnabled: true,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  //todo: call add contact api here
                                  final selectedContactListItems =
                                      contactListItems.where(
                                          (contactListItem) =>
                                              contactListItem.isSelected);
                                  final selectedIds = <int?>[];
                                  for (var contact
                                      in selectedContactListItems) {
                                    selectedIds.add(contact.contact?.id);
                                  }
                                  debugPrint("Selected Ids: $selectedIds");
                                  Navigator.pop(context);

                                  // await addContactsToGroup(selectedIds,
                                  //         _groupNameTextEditingController.text)
                                  //     .then((value) {
                                  //   Navigator.pop(context);
                                  //   Navigator.pop(context);
                                  // }).onError((error, stackTrace) {
                                  //   debugPrintStack(
                                  //       stackTrace: stackTrace,
                                  //       label:
                                  //           "addContactsToGroup() Future error");
                                  // });
                                  // showProgressIndicator();
                                },
                                child: const Text("OK"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("CANCEL"),
                              ),
                            ],
                          ));
                }
              : () async {
                  final selectedContactListItems = contactListItems
                      .where((contactListItem) => contactListItem.isSelected);
                  final selectedIds = <int?>[];
                  for (var contact in selectedContactListItems) {
                    selectedIds.add(contact.contact?.id);
                  }
                  await updateGroupContacts(selectedIds, contacts.first.groupId)
                      .then((value) {
                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    debugPrintStack(
                        stackTrace: stackTrace,
                        label: "updateGroupContacts() Future error");
                  });
                  // showProgressIndicator();
                },
          elevation: 5,
          child: const Icon(
            Icons.done,
            color: Palette.primaryColor,
          )),
    );
  }

  Future addContactsToGroup(List<int?> contactIds, String groupName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);

      http.Response response = await http.post(
          Uri.parse('${AppConstants.BASE_URL}/add_contact_group'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            'Accept': 'application/json'
          },
          body: jsonEncode(
              <String, dynamic>{"name": groupName, "contact_ids": contactIds}));
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
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar('Check your internet connection then try again'));
      return [];
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future updateGroupContacts(List<int?> contactIds, int? groupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);

      http.Response response = await http.post(
          Uri.parse('${AppConstants.BASE_URL}/update_contact_group'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, dynamic>{
            "group_id": groupId,
            "contact_ids": contactIds
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
    } on SocketException {
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

  @override
  void dispose() {
    // TODO: implement dispose
    _groupNameTextEditingController.dispose();
    super.dispose();
  }
}

SpinKitFadingCircle showProgressIndicator() {
  return SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          color: Palette.activeCardColor,
        ),
      );
    },
  );
}

class ContactListItem<T> {
  bool isSelected = false;
  T? contact;

  ContactListItem(this.contact);
}
