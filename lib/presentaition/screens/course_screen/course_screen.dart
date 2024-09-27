import 'package:dio/dio.dart';
import 'package:BrainBlox/presistance/bloc/courses_bloc/course_cubit.dart';
import 'package:BrainBlox/presistance/bloc/lecture_cubit/lecture_cubit.dart';
import 'package:BrainBlox/presistance/model/course_model.dart';
import 'package:BrainBlox/presistance/model/lecture_model.dart';
import 'package:BrainBlox/presentaition/screens/course_screen/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class CourseScreen extends StatefulWidget {
  CourseScreen({super.key, this.courseModel});

  CourseModel? courseModel;

  static const String routeName = "course";

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late CourseModel courseModel;
  late CourseCubit _courseCubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.courseModel != null) {
      courseModel = widget.courseModel!;
    } else {
      final Map<String, dynamic> courseData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      courseModel = CourseModel.fromJson(courseData['courseData']);
    }

    _courseCubit = context.read<CourseCubit>();
    _courseCubit.fetchLectures(courseModel.id);

    return Scaffold(
        body: BlocConsumer<CourseCubit, CourseState>(
      listener: (context, courseState) {},
      builder: (context, courseState) {
        if (courseState is CourseFailureState) {
          return const Center(child: Text('Something went wrong'));
        } else if (courseState is LecturesLoadingState) {
          return ListView(
            children: [
              _buildCourseHeader(courseModel, true),
              _buildTeacherInfo(true),
              _buildLectureList([], true),
            ],
          );
        } else {
          return ListView(
            children: [
              _buildCourseHeader(courseModel, false),
              _buildTeacherInfo(false),
              _buildLectureList(
                  (courseState as LecturesLoadedState).lectures, false),
            ],
          );
        }
      },
    ));
  }

  Widget _buildCourseHeader(CourseModel course, bool isLoading) {
    if (isLoading) {
      return _buildShimmerCourseHeader();
    }

    return SafeArea(
      child: Stack(
        children: [
          Hero(
            tag: course.title,
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(course.imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                course.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCourseHeader() {
    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 230,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTeacherInfo(bool isLoading) {
    if (isLoading) {
      return _buildShimmerTeacherInfo();
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSVUrrx8ohez67j1Qq8uKMrhwXwg1CJp1aDw&s'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'mohammed mostafa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Instructor',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Expert in Flutter',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerTeacherInfo() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 20, color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Container(width: 80, height: 15, color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Container(width: 100, height: 20, color: Colors.grey[300]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureList(List<LectureModel> lectures, bool isLoading) {
    if (isLoading) {
      return _buildShimmerLectureList();
    }

    return BlocConsumer<LectureCubit, LectureState>(
      listener: (context, state) {
        if (state is LectureDownloadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
        if (state is LectureDownloaded) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PDFViewerScreen(
              filePath: state.filePath,
            );
          }));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lectures',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              ...lectures.asMap().entries.map((entry) {
                return _buildLectureSection(entry.value, entry.key, state);
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLectureSection(
      LectureModel lecture, int index, LectureState state) {
    return ExpansionTile(
      title: Text(
        lecture.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.grey[100],
      collapsedBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      childrenPadding: const EdgeInsets.all(16.0),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Icon(Icons.book, color: Theme.of(context).primaryColor),
      trailing: Icon(Icons.expand_more, color: Theme.of(context).primaryColor),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
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
            children: [
              ListTile(
                title: const Text('Lecture Pdf'),
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                trailing: (state is LectureDownloading && state.index == index)
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).primaryColor,
                            )),
                      )
                    : IconButton(
                        icon: Icon(Icons.download,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          context.read<LectureCubit>().downloadLecture(
                              lecture.fileUrl, lecture.title, index);
                        },
                      ),
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey[300]),
              ListTile(
                title: const Text('Assignment File'),
                leading: const Icon(Icons.assignment, color: Colors.orange),
                trailing: IconButton(
                  icon: Icon(Icons.download,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    _downloadLecture('Assignment File', lecture.title);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLectureList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 45),
        ...List.generate(
          4,
          (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  void _downloadLecture(String pdfUrl, String name) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/lecture_$name.pdf';

      Dio dio = Dio();
      await dio.download(pdfUrl, path, onReceiveProgress: (received, total) {
        final progress = received / total;
        print('Download progress: ${(progress * 100).toStringAsFixed(2)}%');
      });
    } catch (e) {
      print(e);
    }
  }
}
