import 'package:flutter/material.dart';

class ConvertPage extends StatefulWidget {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final List<String> historyList;

  const ConvertPage({
    super.key,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.historyList,
  });

  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  double? result;
  bool isLoading = true;

  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'THB': 36.5,
    'EUR': 0.92,
    'JPY': 151.2,
    'GBP': 0.79,
    'CNY': 7.1,
    'KRW': 1380.0,
    'AUD': 1.53,
    'CAD': 1.36,
    'CHF': 0.89,
    'SGD': 1.35,
    'HKD': 7.82,
    'NZD': 1.62,
    'INR': 83.4,
    'RUB': 92.0,
    'ZAR': 18.1,
    'SEK': 10.7,
    'NOK': 10.5,
    'MXN': 16.6,
    'BRL': 5.2,
  };

  @override
  void initState() {
    super.initState();
    convertCurrency();
  }

  void convertCurrency() {
    double fromRate = exchangeRates[widget.fromCurrency] ?? 1.0;
    double toRate = exchangeRates[widget.toCurrency] ?? 1.0;

    setState(() {
      result = widget.amount / fromRate * toRate;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ผลการแปลงสกุลเงิน',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(color: Colors.green)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.amount} ${widget.fromCurrency} =',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '${result!.toStringAsFixed(2)} ${widget.toCurrency}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      widget.historyList.add(
                        '${widget.amount} ${widget.fromCurrency} -> ${result!.toStringAsFixed(2)} ${widget.toCurrency}',
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'บันทึกและกลับไป',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
