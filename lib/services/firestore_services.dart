// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:student_reg_firbase/helpers/snackbar_helper.dart';
import 'package:student_reg_firbase/models/student_model.dart';

class FirestoreServices {
  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  String url = "";
  Reference firebaseStorage = FirebaseStorage.instance.ref();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<StudentModel> studentReference =
      firestore.collection('student-register').withConverter(
            fromFirestore: (snapshot, options) =>
                StudentModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );

  addImage(image, BuildContext context) async {
    Reference imageFolder = firebaseStorage.child('images');
    Reference uploadedImage = imageFolder.child("$imageName.jpg");
    try {
      await uploadedImage.putFile(image);
      url = await uploadedImage.getDownloadURL();
      print(url);
    } catch (e) {
      return errorMessage(context, message: 'image cant be added $e');
    }
  }

  updateImage(imageurl, updateimage, BuildContext context) async {
    try {
      Reference editImage = FirebaseStorage.instance.refFromURL(imageurl);
      await editImage.putFile(updateimage);
      url = await editImage.getDownloadURL();
    } catch (e) {
      return errorMessage(context, message: 'image cant be updated $e');
    }
  }

  deleteImage(imageurl, BuildContext context) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageurl);
      await delete.delete();
    } catch (e) {
      return errorMessage(context, message: 'image cant be deleted $e');
    }
  }

  Stream<QuerySnapshot<StudentModel>> getStudents() {
    return studentReference.snapshots();
  }

  addStudentMethod(StudentModel student) {
    return studentReference.add(student);
  }

  editStudentMethod(String id, StudentModel student) {
    return studentReference.doc(id).update(student.toJson());
  }

  deleteStudentMethod(String id) {
    return studentReference.doc(id).delete();
  }
}
