part of 'lecture_cubit.dart';

abstract class LectureState {
  final int index;
  const LectureState(this.index);
}

class LectureInitial extends LectureState {
  LectureInitial(int index) : super(index);
}

class LectureDownloading extends LectureState {
  final String progress;
  LectureDownloading(this.progress, int index) : super(index);
}

class LectureDownloaded extends LectureState {
  final String filePath;

  LectureDownloaded(this.filePath, int index) : super(index);
}

class LectureDownloadFailure extends LectureState {
  final String error;

  LectureDownloadFailure(this.error, int index) : super(index);
}
