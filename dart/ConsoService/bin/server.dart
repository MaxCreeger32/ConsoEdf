// Copyright (c) 2017, Bertrand. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:args/args.dart';
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart';
import 'package:rpc/rpc.dart';
import 'package:shelf_rpc/shelf_rpc.dart' as shelf_rpc;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_route/shelf_route.dart' as shelf_route;

import 'lib/consoservice.dart';

const _API_PREFIX = '/api';
final ApiServer _apiServer =
    new ApiServer(apiPrefix: _API_PREFIX, prettyPrint: true);

Future main(List<String> args) async {
  ConsoService service = new ConsoService();
  service.getConsoDuMoment();
  service.getConsoDeLaPeriode(
     new DateTime(2018, 1, 3, 0, 0), new DateTime(2018, 1, 3, 23, 0));

  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8888');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });


  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(new SyncFileLoggingHandler('myLogFile.txt'));
  if (stdout.hasTerminal) {
    Logger.root.onRecord.listen(new LogPrintHandler());
  }

  _apiServer.addApi(new ConsoService());
  _apiServer.enableDiscoveryApi();

  // Create a Shelf handler for your RPC API.
  var apiHandler = shelf_rpc.createRpcHandler(_apiServer);

  var apiRouter = shelf_route.router();
  apiRouter.add(_API_PREFIX, null, apiHandler, exactMatch: false);
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(apiRouter.handler);

  var server = await shelf_io.serve(handler, '0.0.0.0', port);
  print('Serving at http://${server.address.host}:${server.port}');

  //String machin="un machin";
  //String s = "un truc $machin";
  //print(s);
  //machin = "un bidule";
  //print(s);


}