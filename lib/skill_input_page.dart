import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'skill.dart'; // Import Skill class

class SkillInputPage extends StatefulWidget {
  final Skill? skill;

  SkillInputPage({this.skill});

  @override
  _SkillInputPageState createState() => _SkillInputPageState();
}

class _SkillInputPageState extends State<SkillInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Color selectedColor = Colors.blue;
  DateTime selectedDate = DateTime.now();
  int keyCounter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.skill != null) {
      nameController.text = widget.skill!.name;
      notesController.text = widget.skill!.notes;
      selectedColor = Color(widget.skill!.colorValue);
      selectedDate = widget.skill!.startDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.skill == null ? 'Add Skill' : 'Edit Skill'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Skill Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              Text('Select Color:'),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () => pickColor(context),
                child: Text('Pick a color',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: selectedColor),
              ),
              SizedBox(height: 20.0),
              Text('Select Start Date:'),
              SizedBox(height: 10.0),
              InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: selectedColor),
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a skill name.'),
                      ),
                    );
                    return;
                  }
                  var box = Hive.box<Skill>('skills');
                  for (var skill in box.values) {
                    if (skill.name == nameController.text && skill.key != widget.skill?.key) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('A skill with the name "${nameController.text}" already exists.'),
                        ),
                      );
                      return;
                    }
                  }
                  if (widget.skill == null) {
                    // Adding a new skill
                    var newSkill = Skill(
                      nameController.text,
                      0, // Initial hours spent
                      0, // Initial minutes spent
                      selectedColor.value,
                      selectedDate,
                      notesController.text,
                      keyCounter++,
                    );
                    box.add(newSkill);
                  } else {
                    // Editing an existing skill
                    widget.skill!.name = nameController.text;
                    widget.skill!.colorValue = selectedColor.value;
                    widget.skill!.startDate = selectedDate;
                    widget.skill!.notes = notesController.text;
                    box.put(widget.skill!.key, widget.skill!);
                  }

                  Navigator.pop(context);
                },
                child: Text(widget.skill == null ? 'Add Skill' : 'Update Skill',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),]
        ),
      ),
    );
  }

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() => selectedColor = color);
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(2.0),
                topRight: const Radius.circular(2.0),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
