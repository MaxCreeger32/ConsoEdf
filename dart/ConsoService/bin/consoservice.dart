import 'dart:async';

import 'dart:io';
import 'package:angular/angular.dart';
import 'package:http/http.dart';

@Injectable()
class ConsoService {
  static final _headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': '*'
  };
  static const _elasticUrl = 'api/heroes'; // URL to web API
  final Client _http;

  ConsoService(this._http);

  Future<String> getConsoDuMoment() async {
  HttpRequest request = new HttpRequest();
  request.
    /*try {

    } catch (e){

    }
*/
}