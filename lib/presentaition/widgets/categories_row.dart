import 'package:brain_blox/presistance/model/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoriesRow extends StatelessWidget {
  CategoriesRow({
    super.key,
    required this.categories,
  });

  final List<CategoryModel> categories;

  final List<Color> _colors = [
    const Color(0xfffcc99b).withOpacity(0.5),
    const Color(0xFF5e7c9e).withOpacity(0.5),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.29,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final course = categories[index];
          return CategoryWidget(colors: _colors, course: course, index: index);
        },
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required List<Color> colors,
    required this.course,
    required this.index,
  }) : _colors = colors;

  final List<Color> _colors;
  final CategoryModel course;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [SlideEffect(duration: Duration(milliseconds: 500))],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.29,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 3,
                child: CircleAvatar(
                  backgroundColor: _colors[index % _colors.length],
                  radius: 25,
                  child: CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    fit: BoxFit.cover,
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                flex: 1,
                child: Text(
                  course.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class CourseCategoryCard extends StatelessWidget {
//   final CourseCategory category;

//   const CourseCategoryCard({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: CustomCardShapeClipper(), 
//       child: Card(
//         elevation: 4,
//         color: category.backgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Image.asset(category.imageAsset, fit: BoxFit.contain),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 category.title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 category.courseCount,
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class CustomCardShapeClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     // Start at the top left corner
//     path.moveTo(0, 0);

//     // Draw a straight line to the top-right corner
//     path.lineTo(size.width, 0);

//     // Draw a curve or wave from top-right to bottom-right
//     path.lineTo(size.width, size.height * 0.7);
//     path.quadraticBezierTo(
//         size.width - 50, size.height, size.width - 100, size.height * 0.8);

//     // Draw a straight line to the bottom-left corner
//     path.lineTo(0, size.height * 0.9);

//     // Finally, close the path to form the shape
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
