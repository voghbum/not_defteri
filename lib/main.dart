import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:not_defteri/kategori_detay.dart';
import 'package:not_defteri/models/kategori.dart';
import 'package:not_defteri/utils/database_helper.dart';
import 'models/notlar.dart';
import 'not_detay.dart';
import 'renk_sinifi.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Not Defteri Uygulamam",
      debugShowCheckedModeBanner: false,
      home: NotListesi(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Renkler.koyuMaviler["orjinal"],
        accentColorBrightness: Brightness.dark,
        accentColor: Renkler.pembeKirmizi["orjinal"],
      ),
    );
  }
}

class NotListesi extends StatefulWidget {
  @override
  _NotListesiState createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  DatabaseHelper _databaseHelper;
  List<Map<String, dynamic>> _kategoriListesi;
  GlobalKey<FormState> _formKey;
  var _scaffoldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _databaseHelper = DatabaseHelper();
    _formKey = GlobalKey<FormState>(debugLabel: "aa");
    _databaseHelper.kategorileriGetir().then((deger) {
      _kategoriListesi = deger;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text("Kategoriler"),
                  onTap: () => _kategorilerSayfasinaGit(context),
                ),
              )
            ];
          })
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            "Not Sepeti",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Renkler.koyuMaviler["tersçevrilmiş"],
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            elevation: 10,
            heroTag: "Not",
            tooltip: "Not Ekle!",
            onPressed: () => _detaySayfasinaGit(context),
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white70,
            ),
            label: Text(
              "not ekle",
              style: TextStyle(
                fontSize: 17,
                letterSpacing: 0.1,
                color: Renkler.pembeKirmizi["tersçevrilmiş"],
              ),
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            elevation: 10,
            heroTag: "Kategori",
            tooltip: "Kategori Ekle!",
            onPressed: () {
              kategoriEkleDialog(context);
            },
            icon: Icon(
              Icons.add_circle,
              size: 30,
              color: Colors.white70,
            ),
            label: Text(
              "kategori ekle",
              style: TextStyle(
                fontSize: 17,
                letterSpacing: 0.1,
                color: Renkler.pembeKirmizi["tersçevrilmiş"],
              ),
            ),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    String _yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            title: Text(
              "Kategori Ekle",
              style: TextStyle(),
            ),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      _yeniKategoriAdi = yeniDeger;
                    },
                    autovalidate: true,
                    validator: (strin) {
                      for (Map<String, dynamic> it in _kategoriListesi) {
                        if (strin.length <= 0) {
                          return "Kategori adı boş olamaz!";
                        }
                        if (strin != null ? strin.compareTo(it["kategoriBaslik"]) == 0 : -1) {
                          return "Bu kategori zaten var: ${it["kategoriBaslik"]}";
                        }
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Kategori adı gir",
                        focusColor: Renkler.koyuMaviler["soluk"],
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Renkler.koyuMaviler["doygun"],
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Renkler.pembeKirmizi["doygun"],
                          ),
                        )),
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    splashColor: Renkler.pembeKirmizi["soluk"],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Renkler.pembeKirmizi["doygun"],
                  ),
                  RaisedButton(
                    splashColor: Renkler.camGobegi["orjinal"],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _databaseHelper
                            .kategoriEkle(
                          Kategori(_yeniKategoriAdi),
                        )
                            .then((ekle) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content:
                                  Text("Kategori eklendi: $_yeniKategoriAdi"),
                              duration: Duration(
                                seconds: 2,
                              ),
                              backgroundColor: Renkler.pembeKirmizi["grilik"],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          );
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Renkler.pembeKirmizi["tersçevrilmiş"],
                  )
                ],
              ),
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: "Yeni Not",
        ),
      ),
    );
  }

  _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => KategoriDetay()));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Not>> snap) {
        if (snap.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              if (index < snap.data.length) {
                return Card(
                  margin: EdgeInsets.only(right: 6, left: 6, top: 7),
                  elevation: 6,
                  child: ExpansionTile(
                    title: Text(snap.data[index].notBaslik),
                    trailing: Text("${snap.data[index].kategoriBaslik}"),
                    leading: _OncelikIkonuAta(snap.data[index].notOncelik),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 15,
                                ),
                                Text(
                                  "Kategori: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  snap.data[index].kategoriBaslik,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      color: Renkler.pembeKirmizi["grilik"]),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 15,
                                ),
                                Text(
                                  "Başlık: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  snap.data[index].notBaslik,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                      color: Renkler.pembeKirmizi["grilik"]),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    snap.data[index].notIcerik,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Tarih:  ",
                                  style: TextStyle(fontSize: 17),
                                ),
                                Text(
                                  databaseHelper.dateFormat(
                                    DateTime.parse(snap.data[index].notTarih),
                                  ),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Renkler.sariYesil["grilik"],
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    splashColor: Renkler.sariYesil["orjinal"],
                                    onPressed: () {
                                      _detaySayfasinaGit(
                                          context, snap.data[index]);
                                    },
                                    child: Text(
                                      "Güncelle",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    )),
                                FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    splashColor: Renkler.pembeKirmizi["doygun"],
                                    onPressed: () =>
                                        _notSil(snap.data[index].notId),
                                    child: Text(
                                      "Sil",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: 140,
                );
              }
            },
            itemCount: snap.data.length + 1,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: databaseHelper.notListesiniGetir(),
    );
  }

  _OncelikIkonuAta(int tumNotlarOncelik) {
    if (tumNotlarOncelik == 0) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Renkler.sariYesil["doygun"],
        child: Text(
          "DÜŞÜK",
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700),
        ),
      );
    } else if (tumNotlarOncelik == 1) {
      return CircleAvatar(
        backgroundColor: Renkler.koyuMaviler["doygun"],
        radius: 25,
        child: Text(
          "ORTA",
          style: TextStyle(),
        ),
      );
    } else if (tumNotlarOncelik == 2) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: Renkler.pembeKirmizi["doygun"],
        child: Text(
          "DİKKAT",
          style: TextStyle(
              fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      );
    }
  }

  _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: "Notu Düzenle",
          duzenlenecekNot: not,
        ),
      ),
    );
  }

  _notSil(int notId) {
    databaseHelper.notSil(notId).then((silinenId) {
      if (silinenId != 0) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("not silindi!"),
          ),
        );
      }
      setState(() {});
    });
  }
}
