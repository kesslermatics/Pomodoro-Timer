import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro/settings.dart';
import 'package:pomodoro/timer.dart';
import 'package:pomodoro/timermodel.dart';
import 'package:pomodoro/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pomodoro Timer",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TimerHome(),
    );
  }
}

class TimerHome extends StatelessWidget {
  final double defaultPadding = 5;
  final CountdownTimer timer = CountdownTimer();

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
    menuItems.add(PopupMenuItem(
      child: Text("Settings"),
      value: "Settings",
    ));
    timer.startWork();
    timer.stopTimer();
    return MaterialApp(
      title: "My Work Timer",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Work Timer"),
          actions: [buildPopupMenuButton(menuItems, context)],
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            return Column(
              children: [
                buildWorkTypeButtonRow(),
                buildTimerRow(availableWidth),
                buildStartStopButtonRow(),
              ],
            );
          },
        ),
      ),
    );
  }

  Expanded buildTimerRow(double availableWidth) {
    return Expanded(
      child: StreamBuilder(
        initialData: TimerModel("00:00", 1),
        stream: timer.stream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          TimerModel timer = snapshot.data;
          return Container(
            child: CircularPercentIndicator(
              radius: availableWidth / 2,
              lineWidth: 10,
              percent: timer.percent ?? 1,
              center: Text(
                timer.percent == null ? "00:00" : timer.time,
                style: Theme.of(context).textTheme.headline4,
              ),
              progressColor: Color(0xff009688),
            ),
          );
        },
      ),
    );
  }

  Row buildWorkTypeButtonRow() {
    return Row(
      children: [
        Padding(padding: EdgeInsets.all(defaultPadding)),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff009688),
            text: "Work",
            onPressed: () => timer.startWork(),
          ),
        ),
        Padding(padding: EdgeInsets.all(defaultPadding)),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff009688),
            text: "Short Break",
            onPressed: () => timer.startBreak(true),
          ),
        ),
        Padding(padding: EdgeInsets.all(defaultPadding)),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff009688),
            text: "Long Break",
            onPressed: () => timer.startBreak(false),
          ),
        ),
      ],
    );
  }

  Row buildStartStopButtonRow() {
    return Row(
      children: [
        Padding(padding: EdgeInsets.all(defaultPadding)),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff009688),
            text: "Stop",
            onPressed: () => timer.stopTimer(),
          ),
        ),
        Padding(padding: EdgeInsets.all(defaultPadding)),
        Expanded(
          child: ProductivityButton(
            color: Color(0xff009688),
            text: "Restart",
            onPressed: () => timer.startTimer(),
          ),
        ),
      ],
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(
      List<PopupMenuItem<String>> menuItems, BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return menuItems.toList();
      },
      onSelected: (value) {
        if (value == "Settings") {
          goToSettings(context);
        }
      },
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}
