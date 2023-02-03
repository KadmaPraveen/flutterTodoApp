import 'package:flutter/material.dart';

class Todocard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(int) deleteById;
  const Todocard({super.key,
  required this.index,
  required this.item,
  required this.navigateEdit,
  required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id=item['notificationId'] as int;
    // print(id);
    return Card(
                  child: ListTile(
                    // title: Text('Sample Text'),
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['message']),
                    //poup
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        navigateEdit(item);
                      } else if (value == 'delete') {
                        deleteById(id);
                      }
                    }, itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                      ];
                    }),
                  ),
                );
              }
  }
