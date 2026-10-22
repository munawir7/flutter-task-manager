import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'features/tasks/controllers/task_controller.dart';
import 'features/tasks/screens/home_screen.dart';

void main() {
WidgetsFlutterBinding.ensureInitialized();

Get.put(TaskController());

runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
const TaskManagerApp({super.key});

@override
Widget build(BuildContext context) {
return GetMaterialApp(
title: 'Task Manager',
debugShowCheckedModeBanner: false,
theme: AppTheme.lightTheme,
home: HomeScreen(),
);
}
}
