import 'package:flutter_test/flutter_test.dart';
import 'package:nano_core/nano_core.dart';

enum MyTab { feed, search, profile }

enum MySubView { settings, editProfile }

void main() {
  group('NanoShellController', () {
    test('initializes with initialTab and default state', () {
      final controller = NanoShellController<MyTab, MySubView>(
        initialTab: MyTab.feed,
      );

      expect(controller.currentTab, MyTab.feed);
      expect(controller.activeSubView, isNull);
      expect(controller.isShowingSubView, isFalse);
      expect(controller.effectiveActiveTab, MyTab.feed);
      controller.dispose();
    });

    test('selectTab changes tab and resets subView', () {
      final controller = NanoShellController<MyTab, MySubView>(
        initialTab: MyTab.feed,
      )..openSubView(MySubView.settings);
      expect(controller.isShowingSubView, isTrue);

      controller.selectTab(MyTab.profile);
      expect(controller.currentTab, MyTab.profile);
      expect(controller.activeSubView, isNull);
      expect(controller.isShowingSubView, isFalse);
      controller.dispose();
    });

    test('openSubView and closeSubView manage subview stack', () {
      final controller = NanoShellController<MyTab, MySubView>(
        initialTab: MyTab.feed,
      );

      var notified = 0;
      controller
        ..addListener(() => notified++)
        ..openSubView(MySubView.editProfile);
      expect(controller.activeSubView, MySubView.editProfile);
      expect(controller.isShowingSubView, isTrue);
      expect(notified, 1);

      controller.closeSubView();
      expect(controller.activeSubView, isNull);
      expect(controller.isShowingSubView, isFalse);
      expect(notified, 2);
      controller.dispose();
    });
  });
}
