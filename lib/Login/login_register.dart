import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ChezIslem/Login/admin_login.dart';

import '../Home/home.dart';
import '../app.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 100,
                    child: Image(image: AssetImage('assets/images/banner.png')),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 200, // Adjust the height as needed
                    child: _buildQrView(context),
                  ),
                  const SizedBox(height: 35),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminLogin()),
                        );
                      },
                      child: const Text(
                        'Admin Login',
                        style: TextStyle(color: Color(0xFFE85852)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.redAccent,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanned) {
        isScanned = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => App(),
          ),
        );

      }
    });
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        // Your logic for login or register here
      },
      child: Text(
        'Login', // You can customize the text as needed
        style: const TextStyle(
          fontFamily: 'poppins',
          color: Color(0xFFE85852),
          fontWeight: FontWeight.w600,
          fontSize: 19,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
