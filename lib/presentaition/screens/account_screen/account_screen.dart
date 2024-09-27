import 'package:BrainBlox/presistance/bloc/auth/auth_cubit.dart';
import 'package:BrainBlox/presistance/model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late AnimationController _profileAnimationController;
  late AnimationController _actionButtonAnimationController;
  late AnimationController _coursesAnimationController;
  late AnimationController _achievementsAnimationController;
  late AnimationController _progressAnimationController;

  @override
  void initState() {
    super.initState();

    _profileAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _actionButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _coursesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _achievementsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _profileAnimationController.forward();
    _actionButtonAnimationController.forward();
  }

  @override
  void dispose() {
    _profileAnimationController.dispose();
    _actionButtonAnimationController.dispose();
    _coursesAnimationController.dispose();
    _achievementsAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is UserAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserAuthSuccess) {
              return ListView(
                children: [
                  _buildProfileHeader(context, state.user),
                  _buildAnimatedActionButtons(),
                  _buildAnimatedProfileSections(),
                ],
              );
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Stack(
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.5),
                Theme.of(context).primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Hero(
                tag: 'profileImage',
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(
                    user.image ?? 'https://via.placeholder.com/150',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${user.email} - ${user.phone}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedActionButtons() {
    return VisibilityDetector(
      key: const Key('action_buttons'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          _actionButtonAnimationController.forward();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAnimatedActionButton(Icons.bookmark, 'Saved'),
            _buildAnimatedActionButton(Icons.report_problem, 'Report Issue'),
            _buildAnimatedActionButton(Icons.arrow_forward, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _actionButtonAnimationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(icon, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProfileSections() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Enrolled Courses'),
          const SizedBox(height: 8),
          _buildAnimatedCoursesList([
            'Arabic Language',
            'Physics',
            'Biology',
            'Chemistry',
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Achievements'),
          const SizedBox(height: 8),
          _buildAchievementsList([
            'Student Achievement 1',
            'Student Achievement 2',
            'Student Achievement 3',
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Progress'),
          const SizedBox(height: 8),
          _buildAnimatedProgressBar('Arabic Language', 0.75),
          _buildAnimatedProgressBar('Physics', 0.5),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildAnimatedCoursesList(List<String> courses) {
    return VisibilityDetector(
      key: const Key('courses'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          _coursesAnimationController.forward();
        }
      },
      child: AnimationLimiter(
        child: Column(
          children: courses.asMap().entries.map((entry) {
            int index = entry.key;
            String course = entry.value;
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50,
                child: FadeInAnimation(
                  child: ListTile(
                    leading:
                        Icon(Icons.book, color: Theme.of(context).primaryColor),
                    title: Text(course),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle course navigation
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAchievementsList(List<String> achievements) {
    return VisibilityDetector(
      key: const Key('achievements'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          // print('object');
          _achievementsAnimationController.reset();
          _achievementsAnimationController.forward();
        }
      },
      child: AnimationLimiter(
        child: Column(
          children: achievements.asMap().entries.map((entries) {
            return AnimationConfiguration.staggeredList(
              position: entries.key,
              duration: const Duration(milliseconds: 500),
              child: FadeInAnimation(
                child: AnimatedBuilder(
                  animation: _achievementsAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: Tween<double>(begin: 0, end: 1)
                          .animate(
                            CurvedAnimation(
                              parent: _achievementsAnimationController,
                              curve: Interval(
                                entries.key / achievements.length,
                                (entries.key + 1) / achievements.length,
                                curve: Curves.easeInOut,
                              ),
                            ),
                          )
                          .value,
                      child: ListTile(
                        leading: const Icon(Icons.star, color: Colors.green),
                        title: Text(entries.value),
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAnimatedProgressBar(String courseName, double progress) {
    return VisibilityDetector(
      key: Key('progress_bar_$courseName'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          _progressAnimationController.reset();
          _progressAnimationController.forward();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(courseName, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _progressAnimationController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressAnimationController.value * progress,
                  backgroundColor: Colors.grey[300],
                  color: Theme.of(context).primaryColor,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                );
              },
            ),
            const SizedBox(height: 4),
            Text('${(progress * 100).toInt()}% completed',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
