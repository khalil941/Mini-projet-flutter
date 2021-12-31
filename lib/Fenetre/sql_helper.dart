import 'package:flutter/foundation.dart';
import 'package:jareb/models/items.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE composant(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        quantite TEXT,
        FK_Famille INTEGER NOT NULL,
        fam TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (FK_Famille) REFERENCES items (id) 
      )
      """);
    await database.execute("""CREATE TABLE membre(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nom TEXT,
        prenom TEXT,
        num1 TEXT,
        num2 TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE emprunt(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        qte TEXT,
        date TEXT,
        num1 TEXT,
        num2 TEXT,

        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
 }

// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'miniprojet.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
//  static Future<List> getItems() async {
//    final db = await SQLHelper.db();
//    List<Map<String, dynamic>> allRows = await db.query('items');
//    List contacts =
//    allRows.map((contact) => Items.fromMap(contact)).toList();
//    return contacts;
//  }

//  // Read all items (journals)
 static Future<List<Map<String, dynamic>>> getItems() async {
   final db = await SQLHelper.db();

   return db.query('items', orderBy: "id");
 }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String title,
      String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // Create new item (journal)
  static Future<int> createComposant(String title, String? qte , String fam) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'quantite': qte , 'fam' : fam};
    final id = await db.insert('composant', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getComposnats() async {
    final db = await SQLHelper.db();
    return db.query('composant', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getComposant(int id) async {
    final db = await SQLHelper.db();
    return db.query('composant', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateComposant(int id, String title, String qte ,String fam) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'quantite': qte,
      'fam' : fam,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('composant', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteComposant(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("composant", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

// Create new item (journal)
   static Future<int> createMembre(String nom, String prenom, String num1,
      String num2) async {
    final db = await SQLHelper.db();

    final data = {'nom': nom, 'prenom': prenom, 'num1': num1, 'num2': num2};
    final id = await db.insert('membre', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// Read all items (journals)
  static Future<List<Map<String, dynamic>>> getMembres() async {
    final db = await SQLHelper.db();
    return db.query('membre', orderBy: "id");
  }

// Read a single item by id
// The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getMembre(int id) async {
    final db = await SQLHelper.db();
    return db.query('membre', where: "id = ?", whereArgs: [id], limit: 1);
  }

// Update an item by id
  static Future<int> updateMembre(int id, String nom, String prenom, String num1,
      String num2) async {
    final db = await SQLHelper.db();

    final data = {
      'nom': nom,
      'prenom': prenom,
      'num1': num1,
      'num2': num2,

    };

    final result =
    await db.update('membre', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

// Delete
  static Future<void> deleteMembre(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("membre", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}