import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vaxpass/services/crud/crud_exceptions.dart';

import '../../../constants/document_types.dart';
import '../../../constants/genders.dart';
import '../../../models/models.dart';
import '../../crud/certificate_service.dart';
import '../auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      log('AuthEventSendEmailVerification');
      await provider.sendEmailVerification();
      emit(state);
    });

    // should register
    on<AuthEventShouldRegister>((event, emit) {
      log('AuthEventShouldRegister');
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });

    // forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      log('AuthEventForgotPassword');
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // user just wants to go to forgot-password screen
      }

      // user wants to actually send a forgot-password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });

    // register
    on<AuthEventRegister>((event, emit) async {
      log('AuthEventRegister');
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsEmailVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });

    // register user info
    on<AuthEventRegisterUserInfo>((event, emit) async {
      log('AuthEventRegisterUserInfo');
      final systemID = provider.currentUser!.id;
      final name = event.name;
      final countryCode = event.countryCode;
      final documentType = event.documentType;
      final countryID = event.countryID;
      final gender = event.gender;
      final dataOfBirth = event.dateOfBirth;
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else {
        await DatabaseService().createUser(
          user: DatabaseUser(
            null,
            systemID: systemID,
            name: name,
            countryCode: countryCode,
            documentType: _documentTypeToInt(documentType),
            countryID: countryID,
            gender: _genderToInt(gender),
            dateOfBirth: dataOfBirth,
            email: user.email!,
          ),
        );
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });

    // initialize
    on<AuthEventInitialize>((event, emit) async {
      log('AuthEventInitialize');
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsEmailVerification(isLoading: false));
      } else {
        try {
          // open the database
          await DatabaseService().open();
          // check if user information exists
          try {
            await DatabaseService().getUser();
            emit(
              AuthStateLoggedIn(
                user: user,
                isLoading: false,
              ),
            );
          } on ExceptionCouldNotFoundUser {
            emit(
              AuthStateRegisterUserInfo(
                user: user,
                isLoading: false,
              ),
            );
          }
        } on ExceptionCouldNotObtainDatabasePassword {
          emit(AuthStateLoggedOut(
            exception: ExceptionCouldNotObtainDatabasePassword(),
            isLoading: false,
          ));
        }
      }
    });

    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        final userID = provider.currentUser!.id;
        final secureKey = 'pw:$email:$userID';
        const secureStorage = FlutterSecureStorage();
        // if there is no password hash in the Flutter Secure Storage,
        // generate one and store it
        final secureValue = await secureStorage.read(key: secureKey);
        if (secureValue == null) {
          final pwBytes = utf8.encode(password);
          final pwHash = sha256.convert(pwBytes).toString();
          log(pwHash);
          await secureStorage.write(key: secureKey, value: pwHash);
        }

        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsEmailVerification(isLoading: false));
        } else {
          // emit(
          //   const AuthStateLoggedOut(
          //     exception: null,
          //     isLoading: false,
          //   ),
          // );
          // emit(
          //   const AuthStateLoggedOut(
          //     exception: null,
          //     isLoading: false,
          //   ),
          // );
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    // log out
    on<AuthEventLogOut>((event, emit) async {
      log('AuthEventLogOut');
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
            loadingText: 'Please wait while logging you in',
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }
}

int _genderToInt(String gender) {
  if (genderList.contains(gender)) {
    return genderList.indexOf(gender);
  }
  return -1;
}

int _documentTypeToInt(String documentType) {
  if (documentTypeList.contains(documentType)) {
    return documentTypeList.indexOf(documentType);
  }
  return -1;
}
