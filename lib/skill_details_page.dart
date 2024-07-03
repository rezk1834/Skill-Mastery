import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'skill.dart'; // Import Skill class
import 'skill_input_page.dart'; // Import SkillInputPage class

class SkillDetailsPage extends StatefulWidget {
  final Skill skill;

  SkillDetailsPage({required this.skill});

  @override
  _SkillDetailsPageState createState() => _SkillDetailsPageState();
}

class _SkillDetailsPageState extends State<SkillDetailsPage> {
  late TextEditingController hoursSpentController;
  late TextEditingController minutesSpentController;

  @override
  void initState() {
    super.initState();
    hoursSpentController = TextEditingController(text: widget.skill.hoursSpent.toString());
    minutesSpentController = TextEditingController(text: widget.skill.minutesSpent.toString());
  }

  @override
  void dispose() {
    hoursSpentController.dispose();
    minutesSpentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int hoursLeft = 10000 - widget.skill.hoursSpent;
    Color skillColor = Color(widget.skill.colorValue);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.skill.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                value: widget.skill.hoursSpent / 10000,
                backgroundColor: Colors.grey[300],
                color: skillColor, // Use skillColor here
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: hoursSpentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Hours',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: minutesSpentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Minutes',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  int hoursSpent = int.tryParse(hoursSpentController.text) ?? 0;
                  int minutesSpent = int.tryParse(minutesSpentController.text) ?? 0;
                  setState(() {
                    widget.skill.hoursSpent += hoursSpent;
                    widget.skill.minutesSpent += minutesSpent;
                    // Adjust hours if minutes exceed 60
                    widget.skill.hoursSpent += widget.skill.minutesSpent ~/ 60;
                    widget.skill.minutesSpent %= 60;
                    Hive.box<Skill>('skills').put(widget.skill.key, widget.skill);
                  });
                },
                child: Text('Add Time'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to SkillInputPage to edit the skill
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkillInputPage(skill: widget.skill),
                    ),
                  );
                },
                child: Text('Edit Skill'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Hive.box<Skill>('skills').delete(widget.skill.key);
                    Navigator.pop(context); // Go back to previous screen after deletion
                  });
                },
                child: Text('Delete Skill'),
              ),
              SizedBox(height: 20.0),
              if (hoursLeft > 0)
                Text(
                  'Hours Remaining: $hoursLeft',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
