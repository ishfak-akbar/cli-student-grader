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

Choose an option:
""";
    print(menu);

    option = stdin.readLineSync() ?? "";
    switch (option) {
      case "1": //Adding student in option 1
        print("Enter student name: ");
        var name = stdin.readLineSync();
        Map<String, dynamic> student = {
          "name": name,
          "scores": <int>[],
          "subjects": {...subjects},
          "bonus": null,
          "comment": null,
        };
        students.add(student);
        print("Student $name added successfully\n");
        break;
      case "2":
        break;
      case "3":
        break;
      case "4":
        break;
      case "5":
        break;
      case "6":
        break;
      case "7":
        break;
      case "8":
        print("Exiting...");
        break;
      default:
        print("Invalid option. Try again.");
    }
  } while (option != "8");
}
