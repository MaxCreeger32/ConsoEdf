library ConsoService.bin.lib.teleinfo;

class Teleinfo {
  String periode;
  int indexHC;
  int indexHP;
  DateTime dateMesure;
  int instantI1;
  int instantI2;
  int instantI3;
  int iMax1;
  int iMax2;
  int iMax3;
  int puissanceApp;
  int puissanceMax;

  Teleinfo(this.periode, this.indexHC, this.indexHP, this.dateMesure,
      this.puissanceApp);
}
