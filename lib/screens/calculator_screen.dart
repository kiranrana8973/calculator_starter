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

  String _expression = '';
  String _result = '';

  String _pretty(String s) => s.replaceAll('*', '×').replaceAll('/', '÷');

  String _label(String l) {
    if (l == '*') return '×';
    if (l == '/') return '÷';
    if (l == '<-') return '⌫';
    return l;
  }

  String _evaluate(String expr) {
    try {
      final tokens = RegExp(
        r'\d+\.?\d*|[+\-*/%]',
      ).allMatches(expr).map((m) => m[0]!).toList();
      if (tokens.isEmpty) return '';

      // Pass 1: high-precedence operators (* / %).
      final reduced = <Object>[double.parse(tokens.first)];
      for (int i = 1; i + 1 < tokens.length; i += 2) {
        final op = tokens[i];
        final n = double.parse(tokens[i + 1]);
        if (op == '*' || op == '/' || op == '%') {
          final a = reduced.removeLast() as double;
          if ((op == '/' || op == '%') && n == 0) return 'Error';
          reduced.add(switch (op) {
            '*' => a * n,
            '/' => a / n,
            _ => a % n,
          });
        } else {
          reduced.add(op);
          reduced.add(n);
        }
      }

      // Pass 2: low-precedence operators (+ -).
      double result = reduced.first as double;
      for (int i = 1; i + 1 < reduced.length; i += 2) {
        final op = reduced[i] as String;
        final n = reduced[i + 1] as double;
        result = op == '+' ? result + n : result - n;
      }

      if (result.isNaN || result.isInfinite) return 'Error';
      return result == result.truncateToDouble()
          ? result.toInt().toString()
          : '$result';
    } catch (_) {
      return 'Error';
    }
  }

  void _onTap(String label) {
    setState(() {
      if (label == 'C') {
        _expression = '';
        _result = '';
      } else if (label == '<-') {
        if (_result.isNotEmpty) {
          _result = '';
        } else if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (label == '=') {
        if (_expression.isNotEmpty) {
          _result = _evaluate(_expression);
        }
      } else if ('+-*/%'.contains(label)) {
        if (_result.isNotEmpty) {
          _expression = _result;
          _result = '';
        }
        if (_expression.isEmpty) return;
        final last = _expression[_expression.length - 1];
        if ('+-*/%'.contains(last)) {
          _expression =
              _expression.substring(0, _expression.length - 1) + label;
        } else {
          _expression += label;
        }
      } else {
        if (_result.isNotEmpty) {
          _expression = '';
          _result = '';
        }
        _expression += label;
      }
    });
  }

  Color _bgFor(String label) {
    if (label == 'C' || label == '<-') return const Color(0xFFFFE9E9);
    if (label == '=') return const Color(0xFF1E88E5);
    if ('+-*/%'.contains(label)) return const Color(0xFFE3F2FD);
    return const Color(0xFFF5F5F7);
  }

  Color _fgFor(String label) {
    if (label == 'C' || label == '<-') return const Color(0xFFD32F2F);
    if (label == '=') return Colors.white;
    if ('+-*/%'.contains(label)) return const Color(0xFF1565C0);
    return Colors.black87;
  }

  Widget _displayCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 110),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_result.isNotEmpty)
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                _pretty(_expression),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _result.isNotEmpty
                  ? _result
                  : (_expression.isEmpty ? '0' : _pretty(_expression)),
              style: const TextStyle(
                fontSize: 56,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        const cols = 4;
        const rows = 5;
        final cellW = (constraints.maxWidth - spacing * (cols - 1)) / cols;
        final cellH = (constraints.maxHeight - spacing * (rows - 1)) / rows;
        return GridView.count(
          crossAxisCount: cols,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: cellW / cellH,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final label in _buttons)
              ElevatedButton(
                onPressed: () => _onTap(label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _bgFor(label),
                  foregroundColor: _fgFor(label),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: FittedBox(
                  child: Text(
                    _label(label),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFB),
      appBar: AppBar(
        title: const Text('Calculator App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 4, child: _displayCard()),
                    const SizedBox(width: 16),
                    Expanded(flex: 6, child: _buttonGrid()),
                  ],
                ),
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _displayCard(),
                      const SizedBox(height: 16),
                      Expanded(child: _buttonGrid()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
