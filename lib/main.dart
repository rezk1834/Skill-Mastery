import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'skill.dart';
import 'skill_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(SkillAdapter());
  await Hive.openBox<Skill>('skills');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Mastery Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: SkillListPage(),
    );
  }
}
