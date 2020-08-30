import 'dart:io';
import 'package:flutter/services.dart';
import 'package:not_defteri/models/kategori.dart';
import 'package:not_defteri/models/notlar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> get _getDatabase async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database _db;

    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "appDB.db");
          var file = new File(path);

          if (!await file.exists()) {
            ByteData data = await rootBundle.load(
              join(
                "assets",
                "notlar.db",
              ),
            );
            List<int> bytes = data.buffer.asUint8List(
              data.offsetInBytes,
              data.lengthInBytes,
            );
            await new File(path).writeAsBytes(bytes);
          }
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }

  // -----------------------------KATEGORİ METHODS------------------------

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase;

    var sonuc = await db.query("kategori");
    return sonuc;
  }

  Future<List<Kategori>> kategoriListesiniGetir() async {
    var kategorileriIcerenMapListesi = await kategorileriGetir();
    var KategoriListesi = List<Kategori>();

    KategoriListesi = kategorileriIcerenMapListesi
        .map((kategori) => Kategori.fromMap(kategori))
        .toList();

    return KategoriListesi;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase;
    var sonuc = await db.insert("kategori", kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase;
    var sonuc = await db.update("kategori", kategori.toMap(),
        where: 'kategoriId = ?', whereArgs: [kategori.kategoriId]);
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriID) async {
    var db = await _getDatabase;
    var sonuc = await db
        .delete("kategori", where: 'kategoriId = ?', whereArgs: [kategoriID]);
    return sonuc;
  }

  // --------------------------NOT METHODS----------------------------------

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase;

    var sonuc = await db.rawQuery(
        'select * from "not" inner join kategori on kategori.kategoriId = "not".kategoriId order by notOncelik DESC;');
    return sonuc;
  }

  Future<List<Not>> notListesiniGetir() async {
    var notlarMapListesi = await notlariGetir();
    var notListesi = List<Not>();
    notListesi = notlarMapListesi.map((map) => Not.fromMap(map)).toList();

    return notListesi;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase;
    var sonuc = await db
        .update("not", not.toMap(), where: 'notId = ?', whereArgs: [not.notId]);
    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase;
    var sonuc = await db.delete("not", where: 'notId = ?', whereArgs: [notID]);
    return sonuc;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase;
    var sonuc = await db.insert("not", not.toMap());
    return sonuc;
  }

  String dateFormat(DateTime dt) {
    DateTime today = DateTime.now();
    Duration oneDay = Duration(days: 1);
    Duration twoDay = Duration(days: 2);
    Duration oneWeek = Duration(days: 7);
    String ay;
    switch (dt.month) {
      case 1:
        ay = "Ocak";
        break;
      case 2:
        ay = "Şubat";
        break;
      case 3:
        ay = "Mart";
        break;
      case 4:
        ay = "Nisan";
        break;
      case 5:
        ay = "Mayıs";
        break;
      case 6:
        ay = "Haziran";
        break;
      case 7:
        ay = "Temmuz";
        break;
      case 8:
        ay = "Ağustos";
        break;
      case 9:
        ay = "Eylül";
        break;
      case 10:
        ay = "Ekim";
        break;
      case 11:
        ay = "Kasım";
        break;
      case 12:
        ay = "Aralık";
        break;
    }

    Duration difference = today.difference(dt);

    if (difference.compareTo(oneDay) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (dt.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (dt.year == today.year) {
      return '${dt.day} $ay';
    } else {
      return "${dt.day} $ay ${dt.year}";
    }
    return "";
  }
}
