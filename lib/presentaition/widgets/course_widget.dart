import 'package:BrainBlox/core/routes/routes.dart';
import 'package:BrainBlox/presistance/model/course_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CourseWidget extends StatelessWidget {
  final CourseModel course;

  @override
  const CourseWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.course,
              arguments: {"courseData": course.toJson()});
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black87, borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Container(
                    color: Colors.grey.shade500,
                    child: Hero(
                      tag: course.title,
                      child: CachedNetworkImage(
                        imageUrl: course.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return Image.network(
                            'https://placehold.co/600x600/000000/FFFFFF.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  )),
              Text(
                course.title,
                style: theme.textTheme.titleMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
