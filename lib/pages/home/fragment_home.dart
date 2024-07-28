import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/model/bean_to_do.dart';
import 'package:flutter_todo_list/pages/page_todo_add_or_update.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final Stream<QuerySnapshot> _todosStream = FirebaseFirestore.instance
      .collection('todos')
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) {
                    return const TodoAddOrUpdatePage();
                  },
                ),
              )
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _todosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var docs = snapshot.data?.docs;
          if (docs == null || docs.isEmpty) {
            return const Center(
              child: Text('No Data'),
            );
          }

          List<TodoBean> list = [];
          for (int i = 0; i < docs.length; i++) {
            var doc = docs[i];
            var data = doc.data();
            if (data is! Map<String, dynamic>) {
              continue;
            }
            list.add(TodoBean.fromJson(data, doc.id));
          }

          list.sort((a, b) {
            if (b.updateTime == 0 && a.updateTime == 0) {
              return b.createTime.compareTo(a.createTime);
            } else if (b.updateTime == 0) {
              return -1;
            } else if (a.updateTime == 0) {
              return 1;
            } else {
              return b.updateTime.compareTo(a.updateTime);
            }
          });

          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemBuilder: (context, index) {
              var list2 = list[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) {
                        return TodoAddOrUpdatePage(
                          todoId: list2.id,
                        );
                      },
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${list2.startDate}~${list2.endDate}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Text(
                            list2.status.desc,
                            style: TextStyle(
                              color: TodoStatus.findColor(list2.status),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      Text(
                        list2.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff666666),
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15,
              );
            },
            itemCount: list.length,
          );
        },
      ),
    );
  }
}
