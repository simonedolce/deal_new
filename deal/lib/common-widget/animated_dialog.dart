
import 'package:flutter/material.dart';

import '../util/colors.dart';


class AnimatedDialog extends StatefulWidget {
  final String title;

  final List<Widget> widgets;

  const AnimatedDialog({super.key, required this.title, required this.widgets});


  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: AlertDialog(
        shadowColor: Colors.black12,
        backgroundColor: CommonColors.paragraph,
        title:  Text(widget.title, style: const TextStyle(color: Colors.black12)),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SafeArea(
              child: Wrap(children: widget.widgets)
            );
          },
        )
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
