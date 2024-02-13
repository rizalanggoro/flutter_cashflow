import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  final EdgeInsets? padding;

  const EmptyContainer({
    super.key,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: padding,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            child: Icon(Icons.folder_open_rounded),
          ),
          SizedBox(height: 16),
          Text('Tidak ada data'),
        ],
      ),
    );
  }
}
