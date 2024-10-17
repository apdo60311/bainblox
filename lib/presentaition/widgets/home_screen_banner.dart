import 'package:flutter/material.dart';

class HomeScreenBanner extends StatefulWidget {
  const HomeScreenBanner({super.key});

  @override
  State<HomeScreenBanner> createState() => _HomeScreenBannerState();
}

class _HomeScreenBannerState extends State<HomeScreenBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _searchBarAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward().whenComplete(() {
        setState(() {});
      });

    _searchBarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SparkleEffect(
                        controller: _controller,
                        child: const Text(
                          'Let\'s Learn More!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SparkleEffect(
                        onlyOnce: true,
                        controller: _controller,
                        child: Text(
                          'see more',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SparkleEffect(
                    controller: _controller,
                    onlyOnce: true,
                    child: Image.asset(
                      'assets/images/home-banner-image.png',
                    ),
                  ),
                ),
              ],
            ),
            SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: _searchBarAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _searchBarAnimation.value == 0
                      ? 50
                      : MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText:
                          _searchBarAnimation.value == 1 ? 'Search...' : '',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SparkleEffect extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final bool onlyOnce;

  const SparkleEffect({
    Key? key,
    required this.child,
    required this.controller,
    this.onlyOnce = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (onlyOnce && controller.isCompleted) {
          return this.child;
        }
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withOpacity(0),
                Colors.white.withOpacity(0.5),
                Colors.white,
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0)
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              begin: Alignment(-1.0 + 2 * (controller.value % 1.0),
                  -1.0 + 2 * (controller.value % 1.0)),
              end: Alignment(1.0 + 2 * (controller.value % 1.0),
                  1.0 + 2 * (controller.value % 1.0)),
              tileMode: TileMode.repeated,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: child,
    );
  }
}
