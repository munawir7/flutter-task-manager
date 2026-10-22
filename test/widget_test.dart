import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:task_manager/features/tasks/controllers/task_controller.dart';
import 'package:task_manager/features/tasks/screens/home_screen.dart';

void main() {
  testWidgets('Task Manager home screen loads', (tester) async {
    Get.put(TaskController());

    await tester.pumpWidget(
      GetMaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.text('My Tasks'), findsOneWidget);

    Get.reset();
  });
}