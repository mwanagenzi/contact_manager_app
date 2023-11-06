import 'package:http/http.dart';

import '../models/Contact.dart';

abstract class ApiRepository {
  //get
  Future<Response> getAllContacts();

  //post
  Future<Response> addNewContact(Contact contact);

//put
  Future<Response> updateContact(Contact contact);

//delete
  Future<Response> deleteContact(int id);
}
