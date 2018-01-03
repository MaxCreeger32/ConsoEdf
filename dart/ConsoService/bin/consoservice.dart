import 'dart:async';

import 'dart:convert';
import 'dart:io';
import 'lib/ConsoPeriodique.dart';
import 'package:http/http.dart' as http;
import 'lib/teleinfo.dart';
import 'package:intl/intl.dart';

//import 'dart:convert' as json;

class ConsoService {
  static final _headers = {
    'Content-Type': 'application/json',
//    'Access-Control-Allow-Origin': '*',
//    'Access-Control-Allow-Methods': '*'
  };

  static const String _elasticUrl =
      "http://nounours:9200/teleinfo/conso/_search";
  static const String _elasticHost = "nounours"; // URL to web API
  static const int _elasticPort = 9200;
  static const String _elasticPath = "teleinfo/conso/_search";

  static const String _requeteJsonConsoInstant = '''{
      "size": 1,
      "sort": { "dateMesure": "desc"},
      "query": {
      "match_all": {}
      }
      }''';

  ConsoService();

  Future<Teleinfo> getConsoDuMoment() async {
//  _client.open('POST', _elasticHost, _elasticPort, _elasticPath);
    var response =
        await http.post(_elasticUrl, headers: _headers, body: _requeteJsonConsoInstant);
    stdout.writeln(response.body);
    Teleinfo uneInfo = null;
    if (response.statusCode == 200) {
      uneInfo = parserReponseElastic(response);
    }
    return uneInfo;
  }

  /**
   * parse la réponse faite par elastic pour produire un objet Teleinfo
   */
  Teleinfo parserReponseElastic(http.Response response) {

    Teleinfo uneInfo = null;
    Map jsonData = JSON.decode(response.body);
    Map hits = jsonData['hits'];
    var nbDocs = hits['total'];
    if (nbDocs >= 1) {
      List docsWithMeta = hits['hits'];
      Map unDocWithMeta = docsWithMeta[0];
      Map unDoc = unDocWithMeta['_source'];

      DateFormat formatter = new DateFormat('dd/MM/yyyy-HH:mm');

      uneInfo = new Teleinfo(
          unDoc['Periode'],
          int.parse(unDoc['IndexHCreuses']),
          int.parse(unDoc['IndexHPleines']),
          formatter.parse(unDoc['dateMesure']),
          int.parse(unDoc['PuissanceApp']));
      stdout.writeln("uneInfo");
      stdout.writeln("Date Mesure : "+formatter.format(uneInfo.dateMesure));
      stdout.writeln("Index HC : "+  uneInfo.indexHC.toString());
      stdout.writeln("Index HP : "+  uneInfo.indexHP.toString());
      stdout.writeln("Periode : "+uneInfo.periode);
      stdout.writeln("Conso en cours : "+uneInfo.puissanceApp.toString());

    }
    return uneInfo;
  }
Future<ConsoPeriodique> getConsoDeLaPeriode(DateTime debut,DateTime fin) async {

    ConsoPeriodique uneConso = null;
    Teleinfo teleinfoDuDebut = await getTeleinfoDeLaDate(debut);
    Teleinfo teleinfoDeLaFin = await getTeleinfoDeLaDate(fin);

    if (teleinfoDuDebut!=null && teleinfoDeLaFin !=null) {
      uneConso = new ConsoPeriodique();
      uneConso.indexHCDebut = teleinfoDuDebut.indexHC;
      uneConso.indexHCFin = teleinfoDeLaFin.indexHC;
      uneConso.consoHC = teleinfoDeLaFin.indexHC - teleinfoDuDebut.indexHC;

      uneConso.indexHPDebut = teleinfoDuDebut.indexHP;
      uneConso.indexHPFin = teleinfoDeLaFin.indexHP;
      uneConso.consoHP = teleinfoDeLaFin.indexHP - teleinfoDuDebut.indexHP;

      uneConso.dateDebut = debut;
      uneConso.dateFin = fin;

      stdout.writeln('ConsoHC : ${uneConso.consoHC}');
      stdout.writeln('ConsoHP : ${uneConso.consoHP}');
    }
    return uneConso;
}

Future<Teleinfo> getTeleinfoDeLaDate(DateTime date) async {
     DateFormat df = new DateFormat("dd/MM/yyyy-HH:mm");

  String dateDebutString=df.format(date);
  DateTime datePlus1 = date.add(new Duration(minutes:1));
  String datePlus1String = df.format(datePlus1);

  String _requeteJsonConsoDate = '''{
  "query": {
    "bool": {
      "filter": {
        "range": {
          "dateMesure": {
            "gte": "$dateDebutString",
            "lt": "$datePlus1String",
            "format": "dd/MM/yyyy-HH:mm"
          }
        }
      }
    }
  }
    }''';

  // appel du server ElasticSearch
  var response =
  await http.post(_elasticUrl, headers: _headers, body: _requeteJsonConsoDate);
  stdout.writeln(response.body);
  Teleinfo uneInfo = null;
  if (response.statusCode == 200) {
    uneInfo = parserReponseElastic(response);
  }
  return uneInfo;
}

  /*try {

    } catch (e){

    }
*/
}
