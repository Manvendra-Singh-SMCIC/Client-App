import 'package:flutter/foundation.dart';

class PageRebuilder extends ChangeNotifier {
  bool shouldRebuild = false;

  void rebuildPage() {
    shouldRebuild = true;
    notifyListeners();
  }
}
