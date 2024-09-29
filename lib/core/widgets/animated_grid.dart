import 'package:brain_blox/presentaition/widgets/course_widget.dart';
import 'package:brain_blox/presistance/model/course_model.dart';
import 'package:flutter/material.dart';

class AnimatedGridWidget extends StatefulWidget {
  final List<CourseModel> courses;

  const AnimatedGridWidget({Key? key, required this.courses}) : super(key: key);

  @override
  State<AnimatedGridWidget> createState() => _AnimatedGridWidgetState();
}

class _AnimatedGridWidgetState extends State<AnimatedGridWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animations = List.generate(
      widget.courses.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index / widget.courses.length) * 0.5,
            ((index + 2) / widget.courses.length) * 0.5,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.courses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _animations[index].value,
              child: Opacity(
                opacity: _animations[index].value,
                child: CourseWidget(
                  course: widget.courses[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
