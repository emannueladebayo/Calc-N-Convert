import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _result = "0";
  final TextEditingController _controller = TextEditingController();
  bool _isFinalResult = false;

  void _onPressed(String text) {
    setState(() {
      bool isOperator = ["+", "-", "×", "÷", "^", "√"].contains(text);
      if (_isFinalResult && !isOperator) {
        _controller.text = text;
        _result = "0";
        _isFinalResult = false;
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
        return;
      }

      final val = _controller.value;
      int start = val.selection.start;
      int end = val.selection.end;

      if (start == -1) {
        start = _controller.text.length;
        end = _controller.text.length;
      }

      final prefix = _controller.text.substring(0, start);
      final suffix = _controller.text.substring(end);

      if (text == "()√") {
        _controller.text = "$prefix()√$suffix";
        _controller.selection = TextSelection.collapsed(offset: start + 1);
      } else {
        _controller.text = prefix + text + suffix;
        _controller.selection = TextSelection.collapsed(
          offset: start + text.length,
        );
      }

      _isFinalResult = false;
    });
  }

  void _clearAll() {
    setState(() {
      _controller.clear();
      _result = "0";
      _isFinalResult = false;
    });
  }

  void _backspace() {
    final text = _controller.text;
    final val = _controller.value;
    if (text.isEmpty) return;

    setState(() {
      if (val.selection.start != val.selection.end) {
        _controller.text = text.replaceRange(
          val.selection.start,
          val.selection.end,
          "",
        );
        _controller.selection = TextSelection.collapsed(
          offset: val.selection.start,
        );
      } else if (val.selection.start > 0) {
        final offset = val.selection.start;
        _controller.text = text.replaceRange(offset - 1, offset, "");
        _controller.selection = TextSelection.collapsed(offset: offset - 1);
      }
      _isFinalResult = false;
    });
  }

  void _calculate() {
    if (_controller.text.isEmpty) return;

    try {
      String input = _controller.text;
      input = input.replaceAll('×', '*').replaceAll('÷', '/');

      final rootRegex = RegExp(r'\((\d+(\.\d+)?)\)√(\d+(\.\d+)?)');

      while (input.contains('√')) {
        var match = rootRegex.firstMatch(input);
        if (match != null) {
          // Standard math for nth root: x^(1/n)
          input = input.replaceFirst(
            match.group(0)!,
            "(${match.group(3)}^(1/${match.group(1)}))",
          );
        } else {
          input = input.replaceFirst('()√', 'sqrt').replaceFirst('√', 'sqrt');
        }
      }

      // ignore: deprecated_member_use
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      // ignore: deprecated_member_use
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _result = eval % 1 == 0
            ? eval.toInt().toString()
            : eval.toStringAsFixed(4);
        _isFinalResult = true;
      });
    } catch (e) {
      setState(() => _result = "Error");
    }
  }

  Widget _btn(String text, {Color? bg, Color? txt, VoidCallback? action}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: bg ?? Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: action ?? () => _onPressed(text),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: txt ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextField(
                  controller: _controller,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 32, color: Colors.black87),
                  decoration: const InputDecoration(border: InputBorder.none),
                  readOnly: true,
                  showCursor: true,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  _btn(
                    "AC",
                    bg: Colors.orange,
                    txt: Colors.black,
                    action: _clearAll,
                  ),
                  _btn("(", bg: Colors.grey[300]),
                  _btn(")", bg: Colors.grey[300]),
                  _btn("÷", bg: Colors.blue[50], txt: Colors.blue),
                ],
              ),
              Row(
                children: [
                  _btn("7"),
                  _btn("8"),
                  _btn("9"),
                  _btn("×", bg: Colors.blue[50], txt: Colors.blue),
                ],
              ),
              Row(
                children: [
                  _btn("4"),
                  _btn("5"),
                  _btn("6"),
                  _btn("-", bg: Colors.blue[50], txt: Colors.blue),
                ],
              ),
              Row(
                children: [
                  _btn("1"),
                  _btn("2"),
                  _btn("3"),
                  _btn("+", bg: Colors.blue[50], txt: Colors.blue),
                ],
              ),
              Row(
                children: [
                  _btn("0"),
                  _btn(".", bg: Colors.grey[300]),
                  _btn(
                    "()√",
                    bg: Colors.grey[300],
                  ), // The custom nth-root button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onLongPress: _clearAll,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Colors.orange[300],
                          ),
                          onPressed: _backspace,
                          child: const Icon(
                            Icons.backspace_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _btn("^", bg: Colors.grey[300]),
                  _btn(
                    "=",
                    bg: Colors.blue,
                    txt: Colors.white,
                    action: _calculate,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
