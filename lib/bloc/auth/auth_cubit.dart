import 'package:BrainBlox/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(UserAuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> signUp(Map<String, dynamic> data, String password) async {
    emit(UserAuthLoading());
    try {
      UserModel user = UserModel.fromJson(data);

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: user.email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        ...user.toJson(),
        'created_at': FieldValue.serverTimestamp(),
      }).catchError((err) {
        emit(UserAuthFailure(err.toString()));
      });
      emit(UserAuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(UserAuthFailure(e.message ?? 'Unknown error'));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(UserAuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      var userData = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userData.exists) {
        return emit(UserAuthFailure('User data not found'));
      }

      UserModel user = UserModel.fromJson(userData.data() ?? {});
      emit(UserAuthSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(UserAuthFailure(e.message ?? 'Unknown error'));
    }
  }

  Future<void> signOut() async {
    emit(UserAuthLoading());
    try {
      await _auth.signOut();
      emit(UserLogout());
    } on FirebaseAuthException catch (e) {
      emit(UserAuthFailure(e.message ?? 'Unknown error'));
    }
  }

  Future checkCurrentUser() async {
    return await _getCurrentUser().then((user) {
      if (user != null) {
        emit(UserAuthSuccess(user));
      } else {
        emit(UserLogout());
      }
    }).catchError((error) {
      emit(UserAuthFailure(error.toString()));
    });
  }

  // get current user
  Future<UserModel?> _getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userData =
          await _firestore.collection('users').doc(user.uid.toString()).get();
      return UserModel.fromJson(userData.data() ?? {});
    }
    return null;
  }
}
