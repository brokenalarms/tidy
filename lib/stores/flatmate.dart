import 'chore_store.dart';

class Flatmate {
  Flatmate({this.name});

  String name;
  List<ChoreStore> choresAssigned;
  List<ChoreStore> choreHistory;
}
