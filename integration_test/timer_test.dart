import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('timer test', (tester) async {
    tester.printToConsole("=== START ${tester.testDescription} ===");

    var desiredFps = 60.0;
    var testSeconds = 10;

    var duration =
        Duration(microseconds: ((1.0 / desiredFps) * 1000000).truncate());
    var called = 0;
    var start = DateTime.now();
    tester.printToConsole(
        "START: ${start.toString()} desiredFps:$desiredFps duration:${duration.toString()}");
    var clock = Timer.periodic(duration, (t) {
      ++called;
      //tester.printToConsole(DateTime.now().toString());
    });

    await Future.delayed(Duration(seconds: testSeconds));

    clock.cancel();
    var end = DateTime.now();
    var actualFps =
        called.toDouble() / (end.difference(start).inMicroseconds / 1000000);
    tester.printToConsole(
        "END:   ${end.toString()} called:$called difference:${end.difference(start)} actualFps:$actualFps");
  });
}
