import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class PDFViewerScreen extends StatefulWidget {
  final String filePath;

  const PDFViewerScreen({super.key, required this.filePath});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int pages = 0;
  int currentPage = 0;
  bool isLoading = true;
  bool isFullScreen = false;
  bool nightMode = false;
  double currentZoom = 1.0;
  PDFViewController? pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nightMode ? Colors.black : Colors.white,
      appBar: isFullScreen
          ? null
          : AppBar(
              backgroundColor: nightMode ? Colors.black : Colors.white,
              elevation: 0,
              title: Text(
                "Lecture",
                style:
                    TextStyle(color: nightMode ? Colors.white : Colors.black),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.brightness_6),
                  onPressed: () {
                    setState(() {
                      nightMode = !nightMode;
                    });
                    // pdfViewController?.setNightMode(nightMode);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {
                    setState(() {
                      isFullScreen = true;
                    });
                  },
                ),
              ],
            ),
      body: Stack(
        children: [
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                isFullScreen = true;
              });
            },
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                nightMode ? Colors.white : Colors.black,
                BlendMode.difference,
              ),
              child: PDFView(
                filePath: widget.filePath,
                autoSpacing: true,
                enableSwipe: true,
                pageSnap: true,
                swipeHorizontal: true,
                // nightMode: nightMode,
                onRender: (pages) {
                  setState(() {
                    this.pages = pages!;
                    isLoading = false;
                  });
                },
                onViewCreated: (PDFViewController viewController) {
                  setState(() {
                    pdfViewController = viewController;
                  });
                },
                onPageChanged: (currentPage, totalPages) {
                  setState(() {
                    this.currentPage = currentPage!;
                  });
                },
              ),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          if (!isFullScreen)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.navigate_before,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        if (currentPage > 0) {
                          currentPage--;
                          pdfViewController?.setPage(currentPage);
                        }
                      },
                    ),
                    Text(
                      'Page ${currentPage + 1} / $pages',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                    IconButton(
                      icon: Icon(Icons.navigate_next,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        if (currentPage < pages - 1) {
                          currentPage++;
                          pdfViewController?.setPage(currentPage);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isFullScreen
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFullScreen = false;
                });
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.fullscreen_exit,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
