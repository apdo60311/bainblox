import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'lecture_state.dart';

class LectureCubit extends Cubit<LectureState> {
  LectureCubit() : super(LectureInitial(0));

  Future<bool> isLectureDownloaded(String name) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/lecture_$name.pdf';
    return File(path).exists();
  }

  Future<void> downloadLecture(String fileUrl, String name, int index) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/lecture_$name.pdf';

      if (await isLectureDownloaded(name)) {
        emit(LectureDownloaded(path, index));
        return;
      }

      Dio dio = Dio();
      await dio.download(
        fileUrl,
        path,
        onReceiveProgress: (received, total) {
          final progress = received / total;
          emit(LectureDownloading((progress * 100).toStringAsFixed(2), index));
        },
        deleteOnError: true,
      ).then((value) => emit(LectureDownloaded(path, index)));
    } catch (e) {
      emit(LectureDownloadFailure("Error downloading or opening file", index));
    }
  }
}
