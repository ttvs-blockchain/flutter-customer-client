import 'package:flutter/material.dart';
import 'package:vaxpass/services/auth/auth_service.dart';
import 'package:vaxpass/services/crud/certificate_service.dart';

class NewCertificateView extends StatefulWidget {
  const NewCertificateView({Key? key}) : super(key: key);

  @override
  _NewCertificateViewState createState() => _NewCertificateViewState();
}

class _NewCertificateViewState extends State<NewCertificateView> {
  DatabaseCertificate? _certificate;
  late final CertificateService _certificateService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _certificateService = CertificateService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final certificate = _certificate;
    if (certificate == null) {
      return;
    }
    final text = _textController.text;
    await _certificateService.updateCertificate(
      certificate: certificate,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseCertificate> createNewCertificate() async {
    final existingCertificate = _certificate;
    if (existingCertificate != null) {
      return existingCertificate;
    }
    final currentUser = AuthService.fireBase().currentUser!;
    final email = currentUser.email!;
    final owner = await _certificateService.getUser(email: email);
    return await _certificateService.createCertificate(owner: owner);
  }

  void _deleteCertificateIfTextIsEmpty() {
    final certificate = _certificate;
    if (_textController.text.isEmpty && certificate != null) {
      _certificateService.deleteCertificate(id: certificate.id);
    }
  }

  void _saveCertificateIfTextNotEmpty() async {
    final certificate = _certificate;
    final text = _textController.text;
    if (certificate != null && text.isNotEmpty) {
      await _certificateService.updateCertificate(
        certificate: certificate,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteCertificateIfTextIsEmpty();
    _saveCertificateIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Certificate'),
      ),
      body: FutureBuilder(
        future: createNewCertificate(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _certificate = snapshot.data as DatabaseCertificate;
              _setupTextControllerListener();
              return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your content...',
                  ));
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
