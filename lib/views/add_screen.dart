// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
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
        backgroundColor: Colors.grey[300],
        body: Container(
          margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            children: [
              Gap(40),
              FutureBuilder(
                future: Future.value(
                    Provider.of<ImagesProvider>(context).pickedImage),
                builder: (context, snapshot) {
                  return CircleAvatar(
                    radius: 40,
                    backgroundImage: snapshot.data != null
                        ? FileImage(snapshot.data!)
                        : null,
                  );
                },
              ),
              const Gap(10),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<ImagesProvider>(context, listen: false)
                        .pickImg(ImageSource.gallery);
                  },
                  child: const Text('pick image')),
              const Gap(10),
              textFieldWidget(controller: nameController, text: 'Name'),
              const Gap(10),
              textFieldWidget(controller: ageController, text: 'Age'),
              const Gap(10),
              textFieldWidget(controller: courseController, text: 'Course'),
              const Gap(20),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await addstudentData(context);
                      Navigator.pop(context);
                    },
                    child: const Text('ADD')),
              )
            ],
          ),
        ),
      ),
    );
  }

  addstudentData(BuildContext context) async {
    log('dasds');
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
