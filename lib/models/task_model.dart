class TaskModel {
  String id;
  String title;
  String description;
  int date;
  int time;
  bool status;
  String userID;

  TaskModel(
      {this.id = '',
      required this.title,
      required this.description,
      required this.date,
      required this.time,
      required this.status,
      required this.userID,});

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          title: json['title'] as String,
          description: json['description'] as String,
          date: json['date'] as int,
          userID: json['userID'] as String,
          time: json['time'] as int,
          status: json['status'] as bool,
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "userID": userID,
      "time": time,
      "status": status,
    };
  }
}
