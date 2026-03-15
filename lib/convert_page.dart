import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  final TextEditingController _amountController = TextEditingController();

  String _from = "USD";
  String _to = "NGN";
  double _result = 0;
  bool _isLoading = false;

  final String _apiKey = "d5a94e2e748cf906f58316b8";

  final List<String> _currencies = ["USD", "NGN", "EUR", "GBP", "CAD", "GHS"];

  String _getCurrencySymbol(String code) {
    const symbols = {
      "USD": "\$",
      "NGN": "₦",
      "EUR": "€",
      "GBP": "£",
      "CAD": "CA\$",
      "GHS": "GH₵",
    };
    return symbols[code] ?? "";
  }

  Future<void> _convert() async {
    final amountText = _amountController.text;

    if (amountText.isEmpty || amountText == ".") {
      setState(() => _result = 0);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(
        'https://v6.exchangerate-api.com/v6/$_apiKey/pair/$_from/$_to/$amountText',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _result = (data['conversion_result'] as num).toDouble();
        });
      }
    } catch (e) {
      // Hoping this handles any errors
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              onChanged: (value) => _convert(),
              decoration: InputDecoration(
                labelText: "Amount",
                prefixIcon: Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    _getCurrencySymbol(_from),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _from,
                    decoration: const InputDecoration(labelText: "From"),
                    items: _currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _from = val!);
                      _convert();
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.swap_horizontal_circle_rounded,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _to,
                    decoration: const InputDecoration(labelText: "To"),
                    items: _currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _to = val!);
                      _convert();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  0,
                  255,
                  76,
                ).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Converted Amount",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    child: Text(
                      "${_getCurrencySymbol(_to)} ${_result.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 2, 1),
                      ),
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: LinearProgressIndicator(minHeight: 2),
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
