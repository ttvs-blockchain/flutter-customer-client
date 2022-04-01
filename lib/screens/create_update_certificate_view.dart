// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:vaxpass/services/cloud/cloud_certificate.dart';
// import 'package:vaxpass/services/cloud/firebase_cloud_storage.dart';

// import '../services/auth/auth_service.dart';
// import '../utils/dialogs/cannot_share_empty_cert_dialog.dart';
// import '../utils/generics/get_arguments.dart';

// class CreateUpdateCertificateView extends StatefulWidget {
//   const CreateUpdateCertificateView({Key? key}) : super(key: key);

//   @override
//   _CreateUpdateCertificateViewState createState() =>
//       _CreateUpdateCertificateViewState();
// }

// class _CreateUpdateCertificateViewState
//     extends State<CreateUpdateCertificateView> {
//   // DatabaseCertificate? _certificate;
//   CloudCertificate? _certificate;

//   // late final CertificateService _certificateService;
//   late final FirebaseCloudStorage _certificateService;
//   late final TextEditingController _textController;

//   @override
//   void initState() {
//     // _certificateService = CertificateService();
//     _certificateService = FirebaseCloudStorage();
//     _textController = TextEditingController();
//     super.initState();
//   }

//   void _textControllerListener() async {
//     final certificate = _certificate;
//     if (certificate == null) {
//       return;
//     }
//     final text = _textController.text;
//     // await _certificateService.updateCertificate(
//     //   certificate: certificate,
//     //   text: text,
//     // );
//     await _certificateService.updateCertificate(
//       documentID: certificate.documentID,
//       text: text,
//     );
//   }

//   void _setupTextControllerListener() {
//     _textController.removeListener(_textControllerListener);
//     _textController.addListener(_textControllerListener);
//   }

//   // Future<DatabaseCertificate> createOrGetExistingCertificate(
//   Future<CloudCertificate> createOrGetExistingCertificate(
//       BuildContext context) async {
//     // final widgetCertificate = context.getArgument<DatabaseCertificate>();
//     final widgetCertificate = context.getArgument<CloudCertificate>();

//     if (widgetCertificate != null) {
//       _certificate = widgetCertificate;
//       _textController.text = widgetCertificate.text;
//       return widgetCertificate;
//     }

//     final existingCertificate = _certificate;
//     if (existingCertificate != null) {
//       return existingCertificate;
//     }
//     final currentUser = AuthService.fireBase().currentUser!;
//     // final email = currentUser.email!;
//     // final owner = await _certificateService.getUser(email: email);
//     // final newCertificate =
//     //     await _certificateService.createCertificate(owner: owner);
//     final userID = currentUser.id;
//     final newCertificate =
//         await _certificateService.createNewCertificate(ownerUserID: userID);
//     _certificate = newCertificate;
//     return newCertificate;
//   }

//   void _deleteCertificateIfTextIsEmpty() {
//     final certificate = _certificate;
//     if (_textController.text.isEmpty && certificate != null) {
//       // _certificateService.deleteCertificate(id: certificate.id);
//       _certificateService.deleteCertificate(documentID: certificate.documentID);
//     }
//   }

//   void _saveCertificateIfTextNotEmpty() async {
//     final certificate = _certificate;
//     final text = _textController.text;
//     if (certificate != null && text.isNotEmpty) {
//       // await _certificateService.updateCertificate(
//       //   certificate: certificate,
//       //   text: text,
//       // );
//       await _certificateService.updateCertificate(
//         documentID: certificate.documentID,
//         text: text,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _deleteCertificateIfTextIsEmpty();
//     _saveCertificateIfTextNotEmpty();
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Certificate'),
//         actions: <Widget>[
//           IconButton(
//             onPressed: () async {
//               final text = _textController.text;
//               if (_certificate == null || text.isEmpty) {
//                 await showCannotShareEmptyCertDialog(context);
//               } else {
//                 Share.share(text);
//               }
//             },
//             icon: const Icon(Icons.share),
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: createOrGetExistingCertificate(context),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               // _certificate = snapshot.data as DatabaseCertificate;
//               _certificate = snapshot.data as CloudCertificate;
//               _setupTextControllerListener();
//               return TextField(
//                   controller: _textController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   decoration: const InputDecoration(
//                     hintText: 'Start typing your content...',
//                   ));
//             default:
//               return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
