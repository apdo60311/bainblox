import 'package:brain_blox/presentaition/widgets/categories_row.dart';
import 'package:brain_blox/presentaition/widgets/courses_row.dart';
import 'package:brain_blox/presentaition/widgets/home_screen_banner.dart';
import 'package:brain_blox/presistance/bloc/auth/auth_cubit.dart';
import 'package:brain_blox/presistance/bloc/courses_bloc/course_cubit.dart';
import 'package:brain_blox/presentaition/screens/account_screen/account_screen.dart';
import 'package:brain_blox/presentaition/screens/calender_screen/calendar_screen.dart';
import 'package:brain_blox/presistance/model/category_model.dart';
import 'package:brain_blox/presistance/model/course_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brain_blox/core/widgets/animated_grid.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart'; // For screen transitions

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _fabAnimationController;
  late Animation<Offset> _fabAnimation;

  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;

  final List<IconData> _bottomNavIcons = [
    Icons.home,
    Icons.calendar_month_outlined,
  ];

  final List<CategoryModel> categories = [
    CategoryModel(
        title: 'Math',
        description: 'Mathematics',
        imageUrl:
            'https://cdn-icons-png.freepik.com/256/1739/1739515.png?semt=ais_hybrid'),
    CategoryModel(
        title: 'Art',
        description: 'Art',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/4893/4893176.png'),
    CategoryModel(
        title: 'Science',
        description: 'Science',
        imageUrl:
            'https://cdn-icons-png.freepik.com/256/12236/12236782.png?semt=ais_hybrid'),
  ];

  final List<CourseModel> courses = [
    CourseModel(
        title: 'Python Programming',
        description: 'python',
        imageUrl: 'https://img-c.udemycdn.com/course/240x135/567828_67d0.jpg',
        id: '',
        instructor: '',
        lectures: [],
        students: []),
    CourseModel(
        title: 'Angular',
        description: 'Angular',
        imageUrl: 'https://img-c.udemycdn.com/course/240x135/756150_c033_4.jpg',
        id: '',
        instructor: '',
        lectures: [],
        students: []),
  ];

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fabAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0 || index == 1) {
        _scaleAnimationController.reset();
        _scaleAnimationController.forward();
      } else {
        _scaleAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is UserAuthSuccess) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Text(
                    '${authState.user.name} 👋',
                    style: const TextStyle(fontSize: 24),
                  )
                ],
              ),
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              centerTitle: false,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: 'profileImage',
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            authState.user.image ??
                                'https://via.placeholder.com/150'),
                        radius: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              reverse: _selectedIndex != 0,
              transitionBuilder: (Widget child, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _getSelectedScreen(),
            ),
            floatingActionButton: SlideTransition(
              // scale: _fabAnimation,
              position: _fabAnimation,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).primaryColor,
                shape: const CircleBorder(),
                child: ScaleTransition(
                    scale: _scaleAnimation,
                    child:
                        const Icon(Icons.notifications, color: Colors.white)),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              icons: _bottomNavIcons,
              activeIndex: _selectedIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              backgroundColor: Colors.white,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Colors.grey,
              splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
              iconSize: 24,
              onTap: _onItemTapped,
              elevation: 8,
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return _buildCoursesScreen();
      case 2:
        return _buildAccountScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (context, coursesState) {
        if (coursesState is CourseFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(coursesState.error)));
        }
      },
      builder: (context, coursesState) {
        if (coursesState is CoursesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (coursesState is CoursesLoadedState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const HomeScreenBanner(),
                sectionLabel('Categories'),
                CategoriesRow(
                  categories: categories,
                ),
                sectionLabel('Enroll Course'),
                CoursesRow(courses: courses),
                // AnimatedGridWidget(courses: coursesState.courses),
              ],
            ),
          );
        } else {
          return const Center(child: Text("Something went wrong"));
        }
      },
    );
  }

  Padding sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesScreen() {
    return const AnimatedCalendarScreen();
  }

  Widget _buildAccountScreen() {
    return const Center(child: Text("Notification Screen"));
  }
}
