import 'package:flutter/material.dart';

import '../db/dbhelper.dart';
import '../model/contact_model.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contactList = [];

  Future<int> insertContact(ContactModel contactModel) async {
    final rowId = await DbHelper.insertContact(contactModel);
    contactModel.id = rowId;
    contactList.add(contactModel);
    notifyListeners();
    return rowId;
  }

  Future<int> updateContact(int rowId, String column, dynamic value) async {
    final map = {column: value};
    final id = await DbHelper.updateContact(rowId, map);
    /*final contactModel = contactList.firstWhere((element) => element.id == rowId);
    contactModel.favorite = !contactModel.favorite;
    final index = contactList.indexOf(contactModel);
    contactList[index] = contactModel;
    notifyListeners();*/
    getAllContacts();
    return id;
  }

  getAllContacts() async {
    contactList = await DbHelper.getAllContacts();
    print('TOTAL CONTACTS: ${contactList.length}');
    notifyListeners();
  }

  getAllFavoriteContacts() async {
    contactList = await DbHelper.getAllFavoriteContacts();
    print('TOTAL CONTACTS: ${contactList.length}');
    notifyListeners();
  }

  Future<ContactModel> getContactById(int id) {
    return DbHelper.getContactById(id);
  }

  void delete(int id) async {
    final deletedRowId = await DbHelper.delete(id);
    contactList.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
