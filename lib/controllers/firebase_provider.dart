import 'package:flutter/material.dart';
import 'package:student_reg_firbase/models/student_model.dart';
import 'package:student_reg_firbase/services/firestore_services.dart';

class FireBaseProvider extends ChangeNotifier {
  FirestoreServices services = FirestoreServices();

  Future<void> addStudent(StudentModel student) async {
    await services.addStudentMethod(student);
    notifyListeners();
  }

  Future<void> editStudent(String id, StudentModel student) async {
    await services.editStudentMethod(id, student);
    notifyListeners();
  }

  Future<void> deleteStudent(String id) async {
    await services.deleteStudentMethod(id);
    notifyListeners();
  }
}
