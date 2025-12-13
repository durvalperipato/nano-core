import 'package:flutter/foundation.dart';

abstract class NanoController extends ChangeNotifier {
  /// First method it will be called when controller runs
  Future<void> init(String? id) async {}
}
