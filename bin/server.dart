import 'package:api_leads/vaden_application.dart';

Future<void> main(List<String> args) async {
  final vaden = VadenApp();
  await vaden.setup();
  final server = await vaden.run(args);
  print('Server listening on port \n http://localhost:${server.port}/docs');
}

