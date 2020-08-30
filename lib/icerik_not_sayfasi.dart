import 'package:flutter/material.dart';
import 'package:not_defteri/models/notlar.dart';
import 'package:not_defteri/renk_sinifi.dart';
import 'package:not_defteri/utils/database_helper.dart';

class icerikNotSayfasi extends StatefulWidget {
  String baslik;
  List<Not> icerikNotListesi;

  icerikNotSayfasi({this.baslik, this.icerikNotListesi});

  @override
  _icerikNotSayfasiState createState() => _icerikNotSayfasiState();
}

class _icerikNotSayfasiState extends State<icerikNotSayfasi> {
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.baslik + " kategorisi notları"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: widget.icerikNotListesi.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(right: 6, left: 6, top: 7),
              elevation: 6,
              child: ExpansionTile(
                title: Text(widget.icerikNotListesi[index].notBaslik),
                leading:
                    _OncelikIkonuAta(widget.icerikNotListesi[index].notOncelik),
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
                              widget.icerikNotListesi[index].notBaslik,
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
                                widget.icerikNotListesi[index].notIcerik,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300),
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
                                DateTime.parse(
                                    widget.icerikNotListesi[index].notTarih),
                              ),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Renkler.sariYesil["grilik"],
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
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
}
