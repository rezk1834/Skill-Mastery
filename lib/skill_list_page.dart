import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'skill.dart';
import 'skill_input_page.dart';
import 'skill_details_page.dart';

class SkillListPage extends StatefulWidget {
  @override
  _SkillListPageState createState() => _SkillListPageState();
}

class _SkillListPageState extends State<SkillListPage> {
  int keyCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skill Mastery Tracker',
          style: TextStyle(fontFamily: 'Lato'),
        ),
        backgroundColor: Colors.grey[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Skill>('skills').listenable(),
          builder: (context, Box<Skill> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text(
                  'No skills added yet.',
                  style: TextStyle(fontSize: 30, fontFamily: 'Raleway'),
                ),
              );
            }

            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Skill skill = box.getAt(index)!;
                double totalHours =
                    skill.hoursSpent + (skill.minutesSpent / 60.0);
                double percent = totalHours / 10000;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SkillDetailsPage(skill: skill),
                      ),
                    );
                  },
                  child: Slidable(
                    key: ValueKey(skill.key),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SkillInputPage(skill: skill),
                              ),
                            );
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                          borderRadius: BorderRadius.circular(12),
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              skill.hoursSpent += 1;
                              if (skill.hoursSpent >= 24) {
                                skill.hoursSpent = 0;
                                skill.minutesSpent += 1;
                                if (skill.minutesSpent >= 60) {
                                  skill.minutesSpent = 0;
                                }
                              }
                              box.put(skill.key, skill);
                            });
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.add,
                          label: 'Add Time',
                          borderRadius: BorderRadius.circular(12),
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              box.deleteAt(index);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ],
                    ),
                    child: Card(
                      color: Color(skill.colorValue),
                      elevation: 4.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              skill.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            LinearPercentIndicator(
                              lineHeight: 14.0,
                              percent: percent,
                              backgroundColor: Colors.grey[300],
                              progressColor: Color(skill.colorValue),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Hours Remaining: ${(10000 - totalHours).toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey[300],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SkillInputPage(),
                ),
              );
            },
            child: Icon(Icons.add, color: Colors.blueGrey),
          ),
    );
  }
}
