// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:student_reg_firbase/controllers/firebase_provider.dart';
import 'package:student_reg_firbase/controllers/image_provider.dart';
import 'package:student_reg_firbase/helpers/textfield_helper.dart';
import 'package:student_reg_firbase/models/student_model.dart';
import 'package:student_reg_firbase/services/firestore_services.dart';

class AddScreen extends StatelessWidget {
  AddScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        Provider.of<ImagesProvider>(context, listen: false).clearPickedImage();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        body: Stack(
          children: [
            Image.asset(
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fitHeight,
                'assets/student_background.png'),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
                child: Column(
                  children: [
                    const Gap(40),
                    FutureBuilder(
                      future: Future.value(
                          Provider.of<ImagesProvider>(context).pickedImage),
                      builder: (context, snapshot) {
                        return CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 40,
                            backgroundImage: snapshot.data != null
                                ? FileImage(snapshot.data!)
                                : null);
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
                          Provider.of<ImagesProvider>(context, listen: false)
                              .pickImg();
                        },
                        child: const Text('pick image',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    const Gap(10),
                    textFieldWidget(controller: nameController, text: 'Name'),
                    const Gap(10),
                    textFieldWidget(controller: ageController, text: 'Age'),
                    const Gap(10),
                    textFieldWidget(
                        controller: courseController, text: 'Course'),
                    const Gap(30),
                    Center(
                      child: ElevatedButton(
                          style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 70, vertical: 15)),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.black54),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.amberAccent)),
                          onPressed: () async {
                            await addstudentData(context);
                            Navigator.pop(context);
                          },
                          child: const Text('ADD',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addstudentData(BuildContext context) async {
    FirestoreServices services = FirestoreServices();
    final provider = Provider.of<FireBaseProvider>(context, listen: false);
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    await services.addImage(File(imageProvider.pickedImage!.path), context);

    final student = StudentModel(
        name: nameController.text,
        age: ageController.text,
        course: courseController.text,
        image: services.url);

    provider.addStudent(student);
    imageProvider.clearPickedImage();
  }
}
