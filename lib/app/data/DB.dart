import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  late Database db;

  Future<RxList> initDb() async {
    RxList data = [].obs;

    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'myDatabase.db');

    var exists = await databaseExists(path);
    if(!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch(err) {
        print('err -> $err');
      }

      ByteData data = await rootBundle.load('assets/myDatabase.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print('Opening existing database');
    }

    db = await openDatabase(path, readOnly: true);
    print('db ->> $db');
    data.value = await db.rawQuery('SELECT * FROM bank_details');
    return data;
  }

}