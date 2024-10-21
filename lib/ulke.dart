class Ulke {
  String ulkeKodu;
  String isim;
  String baskent;
  String bolge;
  int nufus;
  String bayrak;
  String dil;

  Ulke.fromMap(Map<String, dynamic> ulkeMap)
      : ulkeKodu = ulkeMap["cca2"] ?? "",
        isim = ulkeMap["name"]?["common"] ?? "",
        baskent = (ulkeMap["capital"] as List<dynamic>?)?.isNotEmpty == true
            ? ulkeMap["capital"][0]
            : "Bilinmiyor", // Varsayılan değer
        bolge = ulkeMap["region"] ?? "Bilinmiyor", // Null kontrolü
        nufus = ulkeMap["population"] ?? 0, // Null kontrolü
        bayrak = (ulkeMap["flags"] != null && ulkeMap["flags"]["png"] != null) 
            ? ulkeMap["flags"]["png"] 
            : "", // Null kontrolü
        dil = (ulkeMap["languages"] as Map<String, dynamic>?)?.isNotEmpty == true
            ? (ulkeMap["languages"] as Map<String, dynamic>)
                .entries
                .toList()[0]
                .value
            : "Bilinmiyor";

  get diller => null;
}


/*
[
  {
    "flags": {
      "png": "https://flagcdn.com/w320/tr.png",
      "svg": "https://flagcdn.com/tr.svg",
      "alt": "The flag of Turkey has a red field bearing a large fly-side facing white crescent and a smaller five-pointed white star placed just outside the crescent opening. The white crescent and star are offset slightly towards the hoist side of center."
    },
    "name": {
      "common": "Turkey",
      "official": "Republic of Turkey",
      "nativeName": {
        "tur": {
          "official": "Türkiye Cumhuriyeti",
          "common": "Türkiye"
        }
      }
    },
    "cca2": "TR",
    "capital": [
      "Ankara"
    ],
    "region": "Asia",
    "languages": {
      "tur": "Turkish"
    },
    "population": 84339067
  }
]
*/