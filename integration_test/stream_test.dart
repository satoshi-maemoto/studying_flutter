import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Stream<int> runLoop(
      WidgetTester tester, double desiredFps, int testSeconds) async* {
    var duration = Duration(microseconds: (1000000.0 / desiredFps).truncate());
    var start = DateTime.now();
    tester.printToConsole(
        "START: ${start.toString()} desiredFps:$desiredFps duration:${duration.toString()}");

    var called = 0;
    var end = start.add(Duration(seconds: testSeconds));
    while (DateTime.now().compareTo(end) < 0) {
      ++called;
      await Future.delayed(duration);
      yield called;
    }

    var actualFps =
        called.toDouble() / (end.difference(start).inMicroseconds / 1000000.0);
    tester.printToConsole(
        "END:   ${end.toString()} called:$called difference:${end.difference(start)} actualFps:$actualFps");
  }

  Stream<int> runLoop2(
      WidgetTester tester, double desiredFps, int testSeconds) async* {
    var duration = Duration(microseconds: (1000000.0 / desiredFps).truncate());
    var start = DateTime.now();
    tester.printToConsole(
        "START: ${start.toString()} desiredFps:$desiredFps duration:${duration.toString()}");

    var called = 0;
    var end = start.add(Duration(seconds: testSeconds));
    var prevCalled = start;
    while (DateTime.now().compareTo(end) < 0) {
      if (DateTime.now().difference(prevCalled) > duration) {
        prevCalled = DateTime.now();
        ++called;
        yield called;
      }
    }

    var actualFps =
        called.toDouble() / (end.difference(start).inMicroseconds / 1000000.0);
    tester.printToConsole(
        "END:   ${end.toString()} called:$called difference:${end.difference(start)} actualFps:$actualFps");
  }

  testWidgets('stream test', (tester) async {
    tester.printToConsole("=== START ${tester.testDescription} ===");

    var desiredFps = 60.0;
    var testSeconds = 10;

    runLoop(tester, desiredFps, testSeconds).listen((called) {
      //ester.printToConsole("called:$called ${DateTime.now()}");
    });

    await Future.delayed(Duration(seconds: testSeconds + 2));
  });

  testWidgets('stream test2', (tester) async {
    tester.printToConsole("=== START ${tester.testDescription} ===");

    var desiredFps = 60.0;
    var testSeconds = 10;

    runLoop2(tester, desiredFps, testSeconds).listen((called) {
      //ester.printToConsole("called:$called ${DateTime.now()}");
    });

    await Future.delayed(Duration(seconds: testSeconds + 2));
  });
}
