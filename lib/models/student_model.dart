class StudentModel {
  String name;
  String age;
  String course;
  String image;

  StudentModel(
      {required this.name,
      required this.age,
      required this.course,
      required this.image});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'course': course,
      'image': image,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
        name: json['name'],
        age: json['age'],
        course: json['course'],
        image: json['image'] ?? "");
  }
}
