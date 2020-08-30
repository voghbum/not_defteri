class Not {
  int notId;
  int kategoriId;
  String notBaslik;
  String notIcerik;
  String notTarih;
  int notOncelik;
  String kategoriBaslik;

  Not(this.kategoriId, this.notBaslik, this.notIcerik, this.notTarih, this.notOncelik);

  Not.withId(this.notId, this.kategoriId, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["notId"] = notId;
    map["kategoriId"] = kategoriId;
    map["notBaslik"] = notBaslik;
    map["notIcerik"] = notIcerik;
    map["notOncelik"] = notOncelik;
    map["notTarih"] = notTarih;

    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    this.notId = map["notId"];
    this.kategoriId = map["kategoriId"];
    this.notTarih = map["notTarih"];
    this.notOncelik = map["notOncelik"];
    this.notIcerik = map["notIcerik"];
    this.notBaslik = map["notBaslik"];
    this.kategoriBaslik = map["kategoriBaslik"];
  }

  @override
  String toString() {
    return 'Not{notId: $notId, kategoriId: $kategoriId, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik}';
  }


}
