// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:student_reg_firbase/controllers/firebase_provider.dart';
import 'package:student_reg_firbase/controllers/image_provider.dart';
import 'package:student_reg_firbase/helpers/snackbar_helper.dart';
import 'package:student_reg_firbase/helpers/textfield_helper.dart';
import 'package:student_reg_firbase/models/student_model.dart';
import 'package:student_reg_firbase/services/firestore_services.dart';

class EditScreen extends StatefulWidget {
  final String id;
  final StudentModel students;
  const EditScreen({super.key, required this.id, required this.students});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  bool isNewImagePicked = false;

  @override
  void initState() {
    nameController.text = widget.students.name;
    ageController.text = widget.students.age;
    courseController.text = widget.students.course;
    isNewImagePicked = false;
    Provider.of<ImagesProvider>(context, listen: false).editPickedImage =
        File(widget.students.image);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
              alignment: Alignment.centerLeft,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fitHeight,
              'assets/student_background.png'),
          Container(
            margin: const EdgeInsets.only(top: 80, right: 20, left: 20),
            child:
                Consumer<ImagesProvider>(builder: (context, provider, child) {
              return Column(
                children: [
                  FutureBuilder<File?>(
                    future: Future.value(provider.editPickedImage),
                    builder: (context, snapshot) {
                      if (isNewImagePicked) {
                        return CircleAvatar(
                            backgroundColor: Colors.amberAccent,
                            radius: 40,
                            backgroundImage:
                                FileImage(provider.editPickedImage!));
                      } else if (widget.students.image != null) {
                        return CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.amberAccent,
                            backgroundImage:
                                NetworkImage(widget.students.image));
                      } else {
                        return const CircleAvatar(
                            radius: 40, backgroundColor: Colors.amber);
                      }
                    },
                  ),
                  const Gap(10),
                  ElevatedButton(
                      style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.black54),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amberAccent)),
                      onPressed: () {
                        provider.editPickImg();
                        isNewImagePicked = true;
                      },
                      child: const Text('pick image',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const Gap(10),
                  textFieldWidget(controller: nameController, text: 'Name'),
                  const Gap(10),
                  textFieldWidget(controller: ageController, text: 'Age'),
                  const Gap(10),
                  textFieldWidget(controller: courseController, text: 'Course'),
                  const Gap(30),
                  ElevatedButton(
                      style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 15)),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.black54),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amberAccent)),
                      onPressed: () async {
                        await editStudentData(context, widget.students.image);
                        successMessage(context,
                            message: 'Details Edited successfully');
                        Navigator.pop(context);
                      },
                      child: const Text('UPDATE',
                          style: TextStyle(fontWeight: FontWeight.bold)))
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  editStudentData(BuildContext context, imageurl) async {
    FirestoreServices services = FirestoreServices();
    final provider = Provider.of<FireBaseProvider>(context, listen: false);
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    await services.updateImage(
        imageurl, File(imageProvider.editPickedImage!.path), context);

    final newData = StudentModel(
        name: nameController.text,
        age: ageController.text,
        course: courseController.text,
        image: services.url);

    provider.editStudent(widget.id, newData);
  }
}
