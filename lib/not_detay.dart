import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:not_defteri/models/kategori.dart';
import 'package:not_defteri/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'models/notlar.dart';
import 'renk_sinifi.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  Not duzenlenecekNot;

  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  GlobalKey<FormState> formKey;
  List<Kategori> _tumKategoriler;
  DatabaseHelper _databaseHelper;
  int _kategoriId;
  static var _oncelikDegerleri = ["Düşük", "Orta", "Yüksek"];
  int _secilenOncelik;
  String notBaslik, notIcerik;
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    formKey = GlobalKey<FormState>();
    _tumKategoriler = List<Kategori>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.kategorileriGetir().then((listKategoriMap) {
      _tumKategoriler =
          listKategoriMap.map((map) => Kategori.fromMap(map)).toList();
      setState(() {});
    });
    if (widget.duzenlenecekNot == null) {
      _secilenOncelik = 1;
    } else {
      _secilenOncelik = widget.duzenlenecekNot.notOncelik;
      _kategoriId = widget.duzenlenecekNot.kategoriId;
      notIcerik = widget.duzenlenecekNot.notIcerik;
      notBaslik = widget.duzenlenecekNot.notBaslik;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.baslik,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: Renkler.koyuMaviler["tersçevrilmiş"],
                blurRadius: 4,
                offset: Offset(2, 2),
              )
            ],
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _tumKategoriler.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Kategori: ",
                          style: TextStyle(
                            fontSize: 19,
                            shadows: [
                              Shadow(
                                color: Renkler.pembeKirmizi["tersçevrilmiş"],
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _kategoriId,
                              items: kategoriItemlariOlustur(),
                              onChanged: (secilenKategoriId) {
                                setState(() {
                                  _kategoriId = secilenKategoriId;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: notBaslik,
                validator: (text) {
                  if (text.length <= 0) {
                    return "lütfen bir başlık giriniz!";
                  }
                  return null;
                },
                onSaved: (kayit) => notBaslik = kayit,
                decoration: InputDecoration(
                  hintText: "Not Başlığını giriniz",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Renkler.sariYesil["tersçevrilmiş"].withGreen(100)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: notIcerik,
                onSaved: (kayit) => notIcerik = kayit,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: "Not içeriğini giriniz",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Renkler.sariYesil["orjinal"]
                            .withBlue(150)
                            .withGreen(130)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Öncelik : ",
                    style: TextStyle(
                      fontSize: 19,
                      shadows: [
                        Shadow(
                          color: Renkler.pembeKirmizi["tersçevrilmiş"],
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _secilenOncelik,
                        items: _oncelikDegerleri.map((oncelik) {
                          return DropdownMenuItem<int>(
                            child: Text(oncelik),
                            value: _oncelikDegerleri.indexOf(oncelik),
                          );
                        }).toList(),
                        onChanged: (secilenOncelikk) {
                          setState(() {
                            _secilenOncelik = secilenOncelikk;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  splashColor: Renkler.pembeKirmizi["soluk"],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Renkler.pembeKirmizi["doygun"],
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Vazgeç",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  splashColor: Renkler.camGobegi["orjinal"],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Renkler.pembeKirmizi["tersçevrilmiş"],
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      var suan = DateTime.now();
                      if (widget.duzenlenecekNot == null) {
                        _databaseHelper.notEkle(
                          Not(_kategoriId, notBaslik, notIcerik,
                              suan.toString(), _secilenOncelik),
                        );
                        Navigator.pop(context);
                      } else {
                        _databaseHelper.notGuncelle(
                          Not.withId(
                              widget.duzenlenecekNot.notId,
                              _kategoriId,
                              notBaslik,
                              notIcerik,
                              suan.toString(),
                              _secilenOncelik),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
                    "Kaydet",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemlariOlustur() {
    return _tumKategoriler
        .map(
          (map) => DropdownMenuItem<int>(
            value: map.kategoriId,
            child: Text(
              map.kategoriBaslik,
              style: TextStyle(fontSize: 15),
            ),
          ),
        )
        .toList();
  }
}
