import 'package:flutter/material.dart';

class TodoBean {
  late String id;
  late String uid;
  late String content;
  late String startDate;
  late String endDate;
  late TodoStatus status;
  late int createTime;
  late int updateTime;

  TodoBean({
    this.id = '',
    required this.uid,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.createTime = 0,
    this.updateTime = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'content': content,
      'startDate': startDate,
      'endDate': endDate,
      'status': status.status
    };
  }

  TodoBean.fromJson(Map<String, dynamic> data, this.id) {
    uid = data['uid'] ?? '';
    content = data['content'] ?? '';
    startDate = data['startDate'] ?? '';
    endDate = data['endDate'] ?? '';
    createTime = data['createTime'] ?? 0;
    updateTime = data['updateTime'] ?? 0;
    var temp = data['status'] ?? 0;
    status = TodoStatus.find(temp);
  }
}

enum TodoStatus {
  notStart(0, "not start"),
  onGoing(1, "on-going"),
  accomplish(2, "accomplish"),
  overtime(3, "overtime");

  final String desc;
  final int status;

  const TodoStatus(this.status, this.desc);

  static TodoStatus find(int status) {
    var where = TodoStatus.values.where((e) => e.status == status);
    return where.firstOrNull ?? TodoStatus.notStart;
  }

  static Color findColor(TodoStatus status) {
    if (status == TodoStatus.accomplish) {
      return Colors.green;
    }

    if (status == TodoStatus.notStart) {
      return Colors.grey;
    }
    if (status == TodoStatus.overtime) {
      return Colors.red;
    }

    return Colors.black;
  }
}
