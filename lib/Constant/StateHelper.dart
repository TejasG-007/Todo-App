import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StateHelper extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  double progress = 0.0;
  String _date = "Task Date";
  int _completedCount = 0;

  get completedCount=>_completedCount;

  setCompletedCount(count){
    _completedCount = count;
    notifyListeners();
  }

  updateTaskDate(date) {
    _date = date;
    notifyListeners();
  }

  get date => _date;

  updatingProgressIndicator(uProgress) {
    progress = uProgress;
    notifyListeners();
  }
}
