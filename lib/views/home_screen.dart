import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:student_reg_firbase/controllers/firebase_provider.dart';
import 'package:student_reg_firbase/helpers/snackbar_helper.dart';
import 'package:student_reg_firbase/models/student_model.dart';
import 'package:student_reg_firbase/services/firestore_services.dart';
import 'package:student_reg_firbase/views/add_screen.dart';
import 'package:student_reg_firbase/views/edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddScreen(),
                ));
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<FireBaseProvider>(
          builder: (context, provider, child) {
            return StreamBuilder<QuerySnapshot<StudentModel>>(
              stream: FirestoreServices().getStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<QueryDocumentSnapshot<StudentModel>> studentDoc =
                    snapshot.data?.docs ?? [];
                return ListView.builder(
                    itemCount: studentDoc.length,
                    itemBuilder: (context, index) {
                      StudentModel students = studentDoc[index].data();
                      final url = students.image;
                      final id = studentDoc[index].id;

                      return Container(
                        margin: const EdgeInsets.only(top: 20, right: 5),
                        child: Slidable(
                          endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                    icon: Icons.edit,
                                    borderRadius: BorderRadius.circular(15),
                                    backgroundColor: Colors.grey.shade500,
                                    onPressed: (context) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                  id: id, students: students)));
                                    }),
                                const Gap(5),
                                SlidableAction(
                                    icon: Icons.delete,
                                    borderRadius: BorderRadius.circular(15),
                                    backgroundColor: Colors.redAccent,
                                    onPressed: (context) {
                                      Provider.of<FireBaseProvider>(context,
                                              listen: false)
                                          .deleteStudent(id);

                                      FirestoreServices()
                                          .deleteImage(students.image, context);
                                      successMessage(context,
                                          message: 'deleted successfully');
                                    })
                              ]),
                          child: Container(
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            child: Material(
                              color: Colors.white.withOpacity(0.2),
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          const Gap(15),
                                          CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(url),
                                              radius: 40),
                                          const Gap(15)
                                        ],
                                      ),
                                      const Gap(50),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Name : ${students.name}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Age : ${students.age.toString()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("Class : ${students.course}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          const Gap(10)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
            );
          },
        ));
  }
}
