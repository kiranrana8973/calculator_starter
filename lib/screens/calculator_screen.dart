import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const List<String> _buttons = [
    'C',
    '*',
    '/',
    '<-',
    '1',
    '2',
    '3',
    '+',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '*',
    '%',
    '0',
    '.',
    '=',
  ];

  String _display = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 28, color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
                children: [
                  for (final label in _buttons)
                    ElevatedButton(
                      onPressed: () {
                        if (label == 'C') {
                          setState(() => _display = '');
                        } else if (label == '<-') {
                          if (_display.isNotEmpty) {
                            setState(() {
                              _display = _display.substring(
                                0,
                                _display.length - 1,
                              );
                            });
                          }
                        } else if (label == '=') {
                          // your logic goes here
                        } else if ('+-*/%'.contains(label)) {
                          // your logic goes here
                        } else {
                          setState(() => _display += label);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEDEDED),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(label, style: const TextStyle(fontSize: 28)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
