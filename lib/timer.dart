import 'dart:async';
import 'timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountdownTimer {
  double radius = 1;
  bool isActive = true;
  late Timer timer;
  late Duration time;
  late Duration fullTime;
  int workTime = 25;
  int shortBreakTime = 5;
  int longBreakTime = 10;

  String returnTime(Duration t) {
    int minutes = t.inMinutes;
    int seconds = (t.inSeconds % 60).round();

    String minutesString = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsString = seconds < 10 ? '0$seconds' : '$seconds';

    return '$minutesString:$secondsString';
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (isActive) {
        this.time = this.time - Duration(seconds: 1);
        radius = this.time.inSeconds / fullTime.inSeconds;
        if (this.time.inSeconds <= 0) {
          isActive = false;
        }
      }
      time = returnTime(this.time);
      return TimerModel(time, radius);
    });
  }

  /// This code is used to read settings from a SharedPreferences object.
  /// It uses the await keyword to wait for the SharedPreferences object to be initialized,
  /// then it assigns the values of "workTime", "shortBreakTime", and "longBreakTime" from the SharedPreferences object to their respective variables.
  /// If any of these values are not found in the SharedPreferences object, then it assigns them their default values.
  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    workTime = prefs.getInt("workTime") ?? workTime;
    shortBreakTime = prefs.getInt("shortBreakTime") ?? shortBreakTime;
    longBreakTime = prefs.getInt("longBreakTime") ?? longBreakTime;
  }

  void stopTimer() {
    isActive = false;
  }

  void startTimer() {
    if (time.inSeconds > 0) {
      isActive = true;
    }
  }

  void startWork() async {
    await readSettings();
    radius = 1;
    time = Duration(minutes: workTime, seconds: 0);
    fullTime = time;
  }

  void startBreak(bool isShort) {
    radius = 1;
    time =
        Duration(minutes: isShort ? shortBreakTime : longBreakTime, seconds: 0);
    fullTime = time;
  }
}
