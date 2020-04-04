import 'package:english_words/english_words.dart';
import 'package:tidy/utils/time.dart';

class Flatmate {
  Flatmate({this.name});

  String name;
  List<Chore> choresAssigned;
  List<Chore> choreHistory;
}

class Chore {
  String title;
  DateAndTime nextDue;
  List members;
  String notes;
  bool resetTimerAfterChoreCompleted;

  Chore({this.resetTimerAfterChoreCompleted = false, nextDueDate, nextDueTime})
      : this.nextDue = DateAndTime(nextDueDate);

  Chore.demo([DateTime nextDueDate]) {
    title = WordPair.random().asCamelCase;
    var flatmate = Flatmate(name: "flatmate");
    members = [flatmate];
    this.nextDue = DateAndTime(nextDueDate);
  }

  void completeChore(Flatmate flatmate) {}
}
