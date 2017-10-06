import 'dart:async';

import 'dart:convert';
import 'dart:io';
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

  static const String _requeteJson = '{'
      '"size": 1,'
      '"sort": { "dateMesure": "desc"},'
      '"query": {'
      '"match_all": {}'
      '}'
      '}';
  ConsoService();

  Future<String> getConsoDuMoment() async {
//  _client.open('POST', _elasticHost, _elasticPort, _elasticPath);
    var response =
        await http.post(_elasticUrl, headers: _headers, body: _requeteJson);
    stdout.writeln(response.body);
    if (response.statusCode == 200) {
      Map jsonData = JSON.decode(response.body);
      Map hits = jsonData['hits'];
      var nbDocs = hits['total'];
      if (nbDocs >= 1) {
        List docsWithMeta = hits['hits'];
        Map unDocWithMeta = docsWithMeta[0];
        Map unDoc = unDocWithMeta['_source'];

        DateFormat formatter = new DateFormat('dd/MM/yyyy-HH:mm');

        Teleinfo uneInfo = new Teleinfo(
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
    }
//  favoriteNumber.value = jsonData['favoriteNumber'].toString();
//  valueOfPi.value = jsonData['valueOfPi'].toString();
//  horoscope.value = jsonData['horoscope'].toString();
//  favOne.value = jsonData['favoriteThings'][0];
//  favTwo.value = jsonData['favoriteThings'][1];
//  favThree.value = jsonData['favoriteThings'][2];
  }

  /*try {

    } catch (e){

    }
*/
}
