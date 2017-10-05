import 'dart:async';

import 'dart:io';
import 'package:http/http.dart' as http;



class ConsoService {
  static final _headers = {
    'Content-Type': 'application/json',
//    'Access-Control-Allow-Origin': '*',
//    'Access-Control-Allow-Methods': '*'
  };

  static const String _elasticUrl = "http://nounours:9200/teleinfo/conso/_search";
  static const String _elasticHost = "nounours"; // URL to web API
  static const int _elasticPort = 9200;
  static const String _elasticPath = "teleinfo/conso/_search";


  static const String _requeteJson =
      '{'
      '"size": 1,'
      '"sort": { "dateMesure": "desc"},'
      '"query": {'
      '"match_all": {}'
      '}'
      '}';
  ConsoService();

  Future<String> getConsoDuMoment() async {
//  _client.open('POST', _elasticHost, _elasticPort, _elasticPath);
  var response = await http.post(_elasticUrl,headers: _headers,body: _requeteJson) ;
    stdout.writeln(response.body);

  }

    /*try {

    } catch (e){

    }
*/
}