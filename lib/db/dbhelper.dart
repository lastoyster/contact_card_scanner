import 'package:sqflite/sqflite.dart';
import '../model/contact_model.dart';
import 'package:path/path.dart' as p;

class DbHelper {
  static const String _createTableContact = '''create table $tblContact(
  $tblContactColId integer primary key autoincrement, 
  $tblContactColName text, 
  $tblContactColMobile text,  
  $tblContactColEmail text, 
  $tblContactColDesignation text, 
  $tblContactColCompany text, 
  $tblContactColAddress text,  
  $tblContactColWeb text, 
  $tblContactColImage text,
  $tblContactColFavorite integer)''';

  static Future<Database> _open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = p.join(rootPath, 'contact.db');
    return openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) {
        db.execute(_createTableContact);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (newVersion == 2) {
          db.execute(
              'alter table $tblContact add column $tblContactColImage text');
        }
      },
    );
  }

  static Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(tblContact, contactModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateContact(int id, Map<String, dynamic> map) async {
    final db = await _open();
    return db.update(tblContact, map,
        where: '$tblContactColId = ?', whereArgs: [id]);
  }

  static Future<List<ContactModel>> getAllContacts() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(tblContact);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<List<ContactModel>> getAllFavoriteContacts() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db
        .query(tblContact, where: '$tblContactColFavorite = ?', whereArgs: [1]);
    return List.generate(
        mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<ContactModel> getContactById(int id) async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db
        .query(tblContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  static Future<int> delete(int id) async {
    final db = await _open();
    return db
        .delete(tblContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }
}
