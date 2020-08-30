import 'package:flutter/material.dart';
import 'package:not_defteri/models/kategori.dart';
import 'package:not_defteri/models/notlar.dart';
import 'package:not_defteri/renk_sinifi.dart';
import 'package:not_defteri/utils/database_helper.dart';
import 'icerik_not_sayfasi.dart';

class KategoriDetay extends StatefulWidget {
  @override
  _KategoriDetayState createState() => _KategoriDetayState();
}

class _KategoriDetayState extends State<KategoriDetay> {
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;
  List<Not> tumNotlar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
    tumnotlarigetir();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler = List<Kategori>();
      kategoriListesiniGuncelle();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Kategoriler"),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              child: Card(
                child: ExpansionTile(
                  title: Text(tumKategoriler[index].kategoriBaslik),
                  leading: CircleAvatar(
                    backgroundColor: Renkler.camGobegi["soluk"],
                    child: Text(
                      tumKategoriler[index].kategoriBaslik[0],
                    ),
                  ),
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 0),
                      child: widgetlerigetir(tumKategoriler[index]),
                    ),
                  ],
                ),
              ),
              key: Key(tumKategoriler[index].kategoriId.toString()),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                setState(() {
                  _kategoriSil(tumKategoriler[index].kategoriId, index);
                });
              },
            );
          },
          itemCount: tumKategoriler.length),
    );
  }

  void kategoriListesiniGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

  void _kategoriSil(int kategoriId, int index) {
    databaseHelper
        .kategoriSil(kategoriId)
        .then((deger) => debugPrint("silindi $deger"));
    tumKategoriler.removeAt(index);
  }

  tumnotlarigetir() {
    databaseHelper.notListesiniGetir().then((liste) {
      setState(() {
        tumNotlar = liste;
      });
    });
  }

  widgetlerigetir(Kategori kategori) {
    List<Not> iceriknotlistesi = List<Not>();
    int notsayisisayac = 0;
    int onemlinotsayisi = 0;
    int ortanotsayisi = 0;
    int dusuknotsayisi = 0;

    for (Not i in tumNotlar) {
      if (i.kategoriId == kategori.kategoriId) {
        iceriknotlistesi.add(i);
        notsayisisayac++;
        switch (i.notOncelik) {
          case 2:
            onemlinotsayisi++;
            break;
          case 1:
            ortanotsayisi++;
            break;
          case 0:
            dusuknotsayisi++;
        }
      }
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "not sayısı:",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
            Text(notsayisisayac.toString()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "önemli not sayısı:",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
            Text(onemlinotsayisi.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "orta öncelikli not sayısı:",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
            Text(ortanotsayisi.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "düşük öncelikli not sayısı:",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
            Text(dusuknotsayisi.toString())
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Renkler.camGobegi["doygun"],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => icerikNotSayfasi(
                              baslik: kategori.kategoriBaslik,
                              icerikNotListesi: iceriknotlistesi,
                            )));
              },
              child: Text("Notları gör"),
            )
          ],
        )
      ],
    );
  }
}
