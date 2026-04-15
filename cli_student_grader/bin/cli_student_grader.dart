import 'dart:io';

void main() {
  const appTitle = "Student Grader v1.0";
  List<Map<String, dynamic>> students = [];
  final Set<String> subjects = {"English", "Bangla", "Math", "Science"};
  var option = "";
  do {
    String menu =
        """
===== $appTitle =====

1. Add Student
2. Record Score
3. Add Bonus Points
4. Add Comment
5. View All Students
6. View Report Card
7. Class Summary
8. Exit

Choose an option: """;
    print(menu);

    option = stdin.readLineSync() ?? "";
    switch (option) {
      //Add student : Creating a new student record and initializing empty fields using Map
      case "1": 
        print("Enter student name: ");
        var name = stdin.readLineSync();
        Map<String, dynamic> student = {
          "name": name,
          "scores": <int>[],
          "subjects": <String>{...subjects},
          "bonus": null as int?,
          "comment": null as String?,
        };
        students.add(student);
        print("Student $name added successfully\n");
        break;

      //Record score : Selecting a student, validate and store their subject score
      case "2": 
        for (int i = 0; i < students.length; i++) {
          print("${i + 1}. ${students[i]["name"]}");
        }
        print("Pick a student: ");
        var studentIndex = int.parse(stdin.readLineSync() ?? "1") - 1;
        var selectedStudent = students[studentIndex];
        print("Subjects: ${selectedStudent["subjects"]}");
        var score = -1;
        while (score < 0 || score > 100) {
          print("Enter a valid score (0-100): ");
          score = int.parse(stdin.readLineSync() ?? "0");
          if (score < 0 || score > 100) {
            print("Invalid Score.");
          }
        }
        selectedStudent["scores"].add(score);
        print("Score added successfully");
        break;

      //Add bonus points : Assigning bonus points to a student (only if not already set)
      case "3": 
        for (int i = 0; i < students.length; i++) {
          print("${i + 1}. ${students[i]["name"]}");
        }
        print("Pick a student: ");
        var bonusIndex = int.parse(stdin.readLineSync() ?? "1") - 1;
        var bonusStudent = students[bonusIndex];
        print("Enter bonus points(1-10): ");
        var bonusPoint = int.parse(stdin.readLineSync() ?? "0");
        if (bonusStudent["bonus"] != null) {
          print("Bonus already set to ${bonusStudent["bonus"]}.");
        } else {
          bonusStudent["bonus"] ??= bonusPoint;
          print("Bonus of $bonusPoint added to ${bonusStudent["name"]}!");
        }
        break;

      //Add comment : Storing teacher feedback comment for the selected student
      case "4": 
        for (int i = 0; i < students.length; i++) {
          print("${i + 1}. ${students[i]["name"]}");
        }
        print("Pick a student: ");

        var commentIndex = int.parse(stdin.readLineSync() ?? "1") - 1;
        var commentStudent = students[commentIndex];

        print("Enter a comment for ${commentStudent["name"]} :");
        var comment = stdin.readLineSync();
        commentStudent["comment"] = comment;
        print("Comment: ");
        String display =
            commentStudent["comment"]?.toUpperCase() ?? "No comment provided";
        print(display);
        break;

      //View all students : Displaying all students with score count and bonus status
      case "5": 
        for (var student in students) {
          var tags = [
            student["name"],
            "${student["scores"].length} scores",
            if (student["bonus"] != null) "⭐ Has Bonus",
          ];
          print(tags);
        }
        break;

      //View report card : Generating report card by calculating average and assigning a grade
      case "6": 
        for (int i = 0; i < students.length; i++) {
          print("${i + 1}. ${students[i]["name"]}");
        }
        print("Pick a student: ");
        var scoreIndex = int.parse(stdin.readLineSync() ?? "1") - 1;
        var scoreStudent = students[scoreIndex];

        if (scoreStudent["scores"].isEmpty) {
          print("No scores were added. Add scores to generate report!\n");
          break;
        }
        double sum = 0;
        for (int i = 0; i < scoreStudent["scores"].length; i++) {
          sum += scoreStudent["scores"][i];
        }
        var rawAvg = sum / scoreStudent["scores"].length;
        var finalAvg = rawAvg + (scoreStudent["bonus"] ?? 0);
        if (finalAvg > 100) {
          finalAvg = 100;
        }

        String grade;
        if (finalAvg >= 90) {
          grade = "A";
        } else if (finalAvg >= 80) {
          grade = "B";
        } else if (finalAvg >= 70) {
          grade = "C";
        } else if (finalAvg >= 60) {
          grade = "D";
        } else {
          grade = "F";
        }

        String feedback = switch (grade) {
          "A" => "Outstanding performance!",
          "B" => "Good work, keep it up!",
          "C" => "Satisfactory. Room to improve.",
          "D" => "Needs improvement.",
          "F" => "Failing. Please seek help.",
          _ => "Unknown grade.",
        };
        var displayComment = scoreStudent["comment"]?.toUpperCase() ?? "No comment provided";
        var displayBonus = scoreStudent["bonus"] ?? 0;
        print("""
╔════════════════════════════════════╗
║            REPORT CARD             ║
╠════════════════════════════════════╣
║  Name:    ${scoreStudent["name"]}${" " * (25 - scoreStudent["name"].toString().length)}║
║  Scores:  ${scoreStudent["scores"]}${" " * (25 - scoreStudent["scores"].toString().length)}║
║  Bonus:   +$displayBonus${" " * (24 - displayBonus.toString().length)}║
║  Average: $finalAvg${" " * (25 - finalAvg.toString().length)}║
║  Grade:   $grade${" " * (25 - grade.length)}║
║  Comment: $displayComment${" " * (25 - displayComment.toString().length)}║
╚════════════════════════════════════╝
$feedback
""");
        break;

      //Class summary : Computing total students in a class including averages, grades, and pass count
      case "7": 
        double avgTotal = 0;
        double classAvg;
        double highestAverage = 0;
        double lowestAverage = 101;
        int passCount = 0;

        Set<String> uniqueGrades = {};

        var totalStudents = students.length;

        for (var s in students) {
          double sum = 0;
          for (int i = 0; i < s["scores"].length; i++) {
            sum += s["scores"][i];
          }
          double avg = sum / s["scores"].length;
          avg += (s["bonus"] ?? 0);
          if (avg > 100) {
            avg = 100;
          }

          if (highestAverage < avg) {
            highestAverage = avg;
          }
          if (lowestAverage > avg) {
            lowestAverage = avg;
          }

          avgTotal += avg;

          if (s["scores"].isNotEmpty && avg >= 60) {
            passCount++;
          }

          String grade;
          if (avg >= 90) {
            grade = "A";
          } else if (avg >= 80) {
            grade = "B";
          } else if (avg >= 70) {
            grade = "C";
          } else if (avg >= 60) {
            grade = "D";
          } else {
            grade = "F";
          }
          uniqueGrades.add(grade);
        }

        var summaryLines = [
          for (var s in students) "${s["name"]}:  ${s["scores"]}",
        ];
        print("Student Scores: ");
        for (var line in summaryLines) {
          print(line);
        }

        classAvg = avgTotal / totalStudents;
        print(
          "\n"
          """
══════════ Class Summary ══════════
Total Students  : $totalStudents
Class Average   : $classAvg
Highest Average : $highestAverage
Lowest Average  : $lowestAverage
Passes Student  : $passCount
Unique Grades   : $uniqueGrades
═══════════════════════════════════
        
        """,
        );
        break;

      //Exit : Exiting the application 
      case "8": 
        print("Exiting.\n");
        break;
      default:
        print("Invalid option. Try again.");
    }
  } while (option != "8");
}
