import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async'; //

class AnimatedCalendarScreen extends StatefulWidget {
  const AnimatedCalendarScreen({super.key});

  @override
  State<AnimatedCalendarScreen> createState() => _AnimatedCalendarScreenState();
}

class _AnimatedCalendarScreenState extends State<AnimatedCalendarScreen>
    with SingleTickerProviderStateMixin {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDate;
  late DateTime? _selectedDate;
  bool _isLoading = false;
  final Map<DateTime, List<String>> _events = {};

  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _calendarFormat = CalendarFormat.month;
    _focusedDate = DateTime.now();
    _selectedDate = null;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _simulateLoading();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _events[_focusedDate] = ['Event 1', 'Event 2', 'Event 3'];
    });

    _controller.forward();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDate = focusedDay;
      _controller.reset();
    });

    _simulateLoading();
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Container(
                height: 16.0,
                width: 150.0,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                height: 14.0,
                width: 100.0,
                color: Colors.grey[300],
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventList() {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: ListView.builder(
        itemCount: _events[_focusedDate]?.length ?? 0,
        itemBuilder: (context, index) {
          final event = _events[_focusedDate]?[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SizedBox(
              height: 65,
              child: Center(
                child: ListTile(
                  title: Text(
                    event ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: const Text(
                    'Event details',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueAccent,
                    size: 16,
                  ),
                  tileColor: Colors.white54,
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 50.ms * index)
                    .slideX(
                        begin: 0.2,
                        end: 0,
                        duration: 400.ms,
                        delay: 60.ms * index)
                    .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        delay: 60.ms * index),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Animated Calendar Widget
        TableCalendar(
          focusedDay: _focusedDate,
          firstDay: DateTime(2020),
          lastDay: DateTime(2050),
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
          ),
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ), // Animation for selected date highlight
            todayDecoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ).animate().fadeIn(duration: 500.ms),

        const SizedBox(height: 8.0),

        Expanded(
          child: _isLoading ? _buildShimmerLoading() : _buildEventList(),
        ),
      ],
    );
  }
}
