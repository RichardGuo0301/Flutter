import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/model/bean_to_do.dart';
import 'package:flutter_todo_list/pages/page_register.dart';
import 'package:flutter_todo_list/utils/utils_logger.dart';
import 'package:flutter_todo_list/utils/utils_t_date.dart';

class TodoAddOrUpdatePage extends StatefulWidget {
  final String? todoId;

  const TodoAddOrUpdatePage({super.key, this.todoId});

  @override
  State<TodoAddOrUpdatePage> createState() => _TodoAddOrUpdatePageState();
}

class _TodoAddOrUpdatePageState extends State<TodoAddOrUpdatePage> {
  final TextEditingController _textEditingController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  TodoStatus _status = TodoStatus.notStart;

  @override
  void initState() {
    _getDetail();
    super.initState();
  }

  void _getDetail() async {
    var todoId = widget.todoId;
    if (todoId != null) {
      try {
        final res = await FirebaseFirestore.instance
            .collection("todos")
            .doc(todoId)
            .get();
        var data = res.data();
        if (data == null) {
          return;
        }
        var todoBean = TodoBean.fromJson(data, res.id);
        _status = todoBean.status;
        _textEditingController.text = todoBean.content;
        _endDate = TDateUtils.strToDateTime(todoBean.endDate);
        _startDate = TDateUtils.strToDateTime(todoBean.startDate);
        setState(() {});
      } catch (e) {
        LoggerUtils.e(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.todoId == null ? "Add Todo" : "Update Todo",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _save(context),
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          GestureDetector(
            onTap: () => _showStartDatePicker(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Start Date",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    _startDate == null
                        ? "select"
                        : TDateUtils.formatDateTime(_startDate),
                    style: TextStyle(
                      fontSize: 16,
                      color: _startDate == null
                          ? const Color(0xff999999)
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: _startDate == null
                        ? const Color(0xff999999)
                        : Colors.black,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => _showEndDatePicker(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "End Date",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    _endDate == null
                        ? "select"
                        : TDateUtils.formatDateTime(_endDate),
                    style: TextStyle(
                      fontSize: 16,
                      color: _endDate == null
                          ? const Color(0xff999999)
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: _endDate == null
                        ? const Color(0xff999999)
                        : Colors.black,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => _showBottomSheet(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    _status.desc,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
            child: Text(
              "Content",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _textEditingController,
              maxLines: null,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                constraints: BoxConstraints(minHeight: 100),
                border: InputBorder.none,
                isDense: false,
                counterText: '',
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color(0xff999999),
                ),
                hintText: "please input content",
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheet(BuildContext context) async {
    final res = await showModalBottomSheet<TodoStatus>(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          height: kToolbarHeight * 5 + 5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
          child: TodoStatusSelectWidget(
            current: _status,
            onChange: (content) {
              Navigator.of(context).pop(content);
            },
          ),
        );
      },
    );
    if (res != null && context.mounted) {
      setState(() {
        _status = res;
      });
    }
  }

  _showStartDatePicker(BuildContext context) async {
    final res = await showDatePicker(
      context: context,
      currentDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 31),
      ),
    );

    if (res != null && context.mounted) {
      final tempEnd = _endDate;
      if (tempEnd == null) {
        setState(() {
          _startDate = res;
        });
      } else {
        if (res.isBefore(tempEnd)) {
          setState(() {
            _startDate = res;
          });
        } else {
          myShowDialog(context, "startDate must after endDate");
        }
      }
    }
  }

  _showEndDatePicker(BuildContext context) async {
    final res = await showDatePicker(
      context: context,
      currentDate: _endDate,
      firstDate: _startDate != null ? _startDate! : DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 31),
      ),
    );

    if (res != null && context.mounted) {
      setState(() {
        _endDate = res;
      });
    }
  }

  _save(BuildContext context) async {
    var content = _textEditingController.text;
    var startDate = _startDate;
    var endDate = _endDate;
    if (startDate == null) {
      myShowDialog(context, "startDate is not empty");
      return;
    }

    if (endDate == null) {
      myShowDialog(context, "endDate is not empty");
      return;
    }

    if (content.isEmpty) {
      myShowDialog(context, "content is not empty");
      return;
    }

    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        myShowDialog(context, "user not login");
        return;
      }
      var todoId = widget.todoId;
      var data = TodoBean(
              uid: uid,
              content: content,
              startDate: TDateUtils.formatDateTime(startDate),
              endDate: TDateUtils.formatDateTime(endDate),
              status: _status)
          .toJson();
      if (todoId == null) {
        data['createTime'] = DateTime.now().millisecondsSinceEpoch;
        data['updateTime'] = 0;
        await FirebaseFirestore.instance.collection("todos").add(data);
      } else {
        data['updateTime'] = DateTime.now().millisecondsSinceEpoch;
        await FirebaseFirestore.instance
            .collection("todos")
            .doc(todoId)
            .set(data);
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      LoggerUtils.e("$e");
      if (context.mounted) {
        myShowDialog(context, "$e");
      }
    }
  }
}

class TodoStatusSelectWidget extends StatefulWidget {
  final TodoStatus current;
  final ValueChanged<TodoStatus>? onChange;

  const TodoStatusSelectWidget({
    super.key,
    required this.current,
    this.onChange,
  });

  @override
  State<TodoStatusSelectWidget> createState() => _TodoStatusSelectWidgetState();
}

class _TodoStatusSelectWidgetState extends State<TodoStatusSelectWidget> {
  late TodoStatus _current;

  @override
  void initState() {
    _current = widget.current;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...(_buildList(context)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: kToolbarHeight,
            alignment: Alignment.center,
            child: const Text(
              "cancel",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _buildList(BuildContext context) {
    List<Widget> list = [];
    var values = TodoStatus.values;
    for (int i = 0; i < values.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          if (_current != values[i]) {
            setState(() {
              _current = values[i];
              widget.onChange?.call(_current);
            });
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: kToolbarHeight,
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  values[i].desc,
                  style: TextStyle(
                    color: _current == values[i]
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: _current == values[i]
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
              Icon(
                Icons.check,
                color: _current == values[i]
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              )
            ],
          ),
        ),
      ));
      list.add(
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
      );
    }
    return list;
  }
}
