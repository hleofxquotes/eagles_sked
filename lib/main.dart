import "dart:async";

import 'package:analog_clock/analog_clock_painter.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyScheduleModel with ChangeNotifier {
  String message1 = '';
  String message2 = '';
  Timer _timer;
  int counter = 0;

  MyScheduleModel() {
    print("> MyScheduleModel");

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      update();
    });
  }
  void update() {
//    print("> XXX update");
    counter++;

    message1 = 'until end of $counter';
    message2 = 'until start of $counter';

    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print("> MyApp.build");

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ChangeNotifierProvider<MyScheduleModel>(
        builder: (_) => MyScheduleModel(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print("> MyHomePage.build");

    return Scaffold(
      body: MyHomeBody(),
    );
  }
}

class MyHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print("> MyHomeBody.build");
    final model = Provider.of<MyScheduleModel>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildText1(model),
          buildAnalogClock(context, model),
          buildText2(model),
        ],
      ),
    );
  }

  Text buildText1(MyScheduleModel model) {
//    print("> buildText1");
    return Text('${model.message1}');
  }

  Text buildText2(MyScheduleModel model) {
//    print("> buildText2");
    return Text('${model.message2}');
  }

  Widget buildAnalogClock(BuildContext context, MyScheduleModel model) {
    var analogClock = Container(
//      decoration: widget.decoration,
      child: Center(
          child: AspectRatio(
              aspectRatio: 1.0,
              child: new Container(
                  constraints: BoxConstraints(minWidth: 48.0, minHeight: 48.0),
                  width: double.infinity,
                  child: new CustomPaint(
                    painter: new AnalogClockPainter(
                      datetime: DateTime.now(),
                      showDigitalClock: false,
                    ),
                  )))),
    );

    return analogClock;
  }
}
