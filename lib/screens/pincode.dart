import 'package:dashboard/globals.dart';
import 'package:flutter/material.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  PinCodeScreenState createState() => PinCodeScreenState();
}

class PinCodeScreenState extends State<PinCodeScreen> {
  String currentPin = '';
  // String passcode = "0000"; //sample passcode

  void updatePin(String newPin) {
    setState(() {
      if (currentPin.length < 4) {
        currentPin += newPin;
        if (currentPin.length == 4) {
          if (currentPin == pin) {
            Navigator.pop(context, true);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  content: Container(
                    color: Colors.transparent,
                    height: 80,
                    padding: const EdgeInsets.all(4),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incorrect MPIN Entered',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 13),
                        Text(
                          'The entered PIN is incorrect. Please try again.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        emptyPin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    });
  }

  void deletePin() {
    setState(() {
      print(pin);
      if (currentPin.isNotEmpty) {
        currentPin = currentPin.substring(0, currentPin.length - 1);
      }
    });
  }

  void emptyPin() {
    setState(() {
      currentPin = ''; // Set the pin to an empty string
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan, Colors.indigo],
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CRASH CART',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Enter your MPIN',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Don\'t share your MPIN with anyone!',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildCircle(currentPin.isNotEmpty),
                            const SizedBox(width: 16),
                            _buildCircle(currentPin.length > 1),
                            const SizedBox(width: 16),
                            _buildCircle(currentPin.length > 2),
                            const SizedBox(width: 16),
                            _buildCircle(currentPin.length > 3),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildNumberButton('1'),
                            _buildNumberButton('2'),
                            _buildNumberButton('3'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildNumberButton('4'),
                            _buildNumberButton('5'),
                            _buildNumberButton('6'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildNumberButton('7'),
                            _buildNumberButton('8'),
                            _buildNumberButton('9'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 12),
                            _buildNumberButton('0'),
                            const SizedBox(width: 12),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AnimatedOpacity(
                                  duration: const Duration(
                                      milliseconds:
                                          100), // Adjust the duration as needed
                                  opacity: currentPin.isNotEmpty
                                      ? 1.0
                                      : 0.0, // Fully visible when pin is not empty, fully transparent otherwise
                                  child: IconButton(
                                    onPressed: deletePin,
                                    icon: const Icon(
                                      Icons.arrow_circle_left_rounded,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(bool filled) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: filled ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return TextButton(
      onPressed: () => updatePin(number),
      child: Container(
        decoration:
            const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        width: 80,
        height: 80,
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
