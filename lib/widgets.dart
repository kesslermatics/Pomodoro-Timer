import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pomodoro/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController textWork;
  late TextEditingController textShortBreak;
  late TextEditingController textLongBreak;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreakTime";
  static const String LONGBREAK = "longBreakTime";

  late int workTime;
  late int shortBreakTime;
  late int longBreakTime;

  late SharedPreferences prefs;

  @override
  void initState() {
    textWork = TextEditingController();
    textShortBreak = TextEditingController();
    textLongBreak = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24);
    return Container(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: <Widget>[
          Text(
            "Work",
            style: textStyle,
          ),
          Text(""),
          Text(""),
          SettingsButton(
              color: Color(0xff455A64),
              text: "-",
              value: -1,
              setting: WORKTIME,
              callbackSetting: updateSettings),
          TextField(
            style: textStyle,
            controller: textWork,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(
              color: Color(0xff455A64),
              text: "+",
              value: 1,
              setting: WORKTIME,
              callbackSetting: updateSettings),
          Text(
            "Short",
            style: textStyle,
          ),
          Text(""),
          Text(""),
          SettingsButton(
              color: Color(0xff455A64),
              text: "-",
              value: -1,
              setting: SHORTBREAK,
              callbackSetting: updateSettings),
          TextField(
            style: textStyle,
            controller: textShortBreak,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(
              color: Color(0xff455A64),
              text: "+",
              value: 1,
              setting: SHORTBREAK,
              callbackSetting: updateSettings),
          Text(
            "Long",
            style: textStyle,
          ),
          Text(""),
          Text(""),
          SettingsButton(
              color: Color(0xff455A64),
              text: "-",
              value: -1,
              setting: LONGBREAK,
              callbackSetting: updateSettings),
          TextField(
            style: textStyle,
            controller: textLongBreak,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(
              color: Color(0xff455A64),
              text: "+",
              value: 1,
              setting: LONGBREAK,
              callbackSetting: updateSettings),
        ],
        padding: const EdgeInsets.all(20),
      ),
    );
  }

  updateSettings(String key, int value) {
    switch (key) {
      case WORKTIME:
        int workTime = prefs.getInt(WORKTIME) ?? 0;
        workTime += value;
        if (workTime >= 1 && workTime <= 180) {
          prefs.setInt(WORKTIME, workTime);
          setState(() {
            textWork.text = workTime.toString();
          });
        }
        break;
      case SHORTBREAK:
        int shortBreak = prefs.getInt(SHORTBREAK) ?? 0;
        shortBreak += value;
        if (shortBreak >= 1 && shortBreak <= 180) {
          prefs.setInt(SHORTBREAK, shortBreak);
          setState(() {
            textShortBreak.text = shortBreak.toString();
          });
        }
        break;
      case LONGBREAK:
        int longBreak = prefs.getInt(LONGBREAK) ?? 0;
        longBreak += value;
        if (longBreak >= 1 && longBreak <= 180) {
          prefs.setInt(LONGBREAK, longBreak);
          setState(() {
            textLongBreak.text = longBreak.toString();
          });
        }
        break;
    }
  }

  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int workTime = prefs.getInt(WORKTIME) ?? 25;
    if (workTime == null) {
      await prefs.setInt(WORKTIME, workTime);
    }
    int shortBreakTime = prefs.getInt(SHORTBREAK) ?? 5;
    if (shortBreakTime == null) {
      await prefs.setInt(SHORTBREAK, shortBreakTime);
    }
    int longBreakTime = prefs.getInt(LONGBREAK) ?? 10;
    if (longBreakTime == null) {
      await prefs.setInt(LONGBREAK, longBreakTime);
    }

    setState(() {
      textWork.text = workTime.toString();
      textShortBreak.text = shortBreakTime.toString();
      textLongBreak.text = longBreakTime.toString();
    });
  }
}
