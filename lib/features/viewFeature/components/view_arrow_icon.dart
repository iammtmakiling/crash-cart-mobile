import 'package:flutter/material.dart';

class ViewArrowIcon extends StatefulWidget {
  final VoidCallback onTap;
  final bool isExpanded;

  const ViewArrowIcon({
    super.key,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  ViewArrowIconState createState() => ViewArrowIconState();
}

class ViewArrowIconState extends State<ViewArrowIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);

    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ViewArrowIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: RotationTransition(
        turns: _rotationAnimation,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      onPressed: widget.onTap,
    );
  }
}
