import 'package:flutter/material.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final List<String> symbols = [
    "AAPL",
    "GOOGL",
    "TSLA",
    "AMZN",
    "MSFT",
    "META",
    "NVDA",
    "NFLX",
    "INTC",
    "BABA"
  ];

  Map<String, dynamic> stockData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMockStockPrices();
  }

  Future<void> fetchMockStockPrices() async {
    
    await Future.delayed(Duration(seconds: 2));

    
    final mockData = {
      "AAPL": {"c": 172.35},
      "GOOGL": {"c": 2835.22},
      "TSLA": {"c": 702.41},
      "AMZN": {"c": 3334.34},
      "MSFT": {"c": 305.22},
      "META": {"c": 215.44},
      "NVDA": {"c": 860.11},
      "NFLX": {"c": 415.23},
      "INTC": {"c": 42.78},
      "BABA": {"c": 85.67},
    };

    setState(() {
      stockData = mockData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตลาดหุ้น'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: symbols.length,
              itemBuilder: (context, index) {
                final symbol = symbols[index];
                final data = stockData[symbol];
                return Card(
                  margin: EdgeInsets.all(12),
                  child: ListTile(
                    leading: Icon(Icons.show_chart, color: Colors.green),
                    title: Text(symbol),
                    subtitle: Text('ราคา: \$${data["c"].toString()}'),
                  ),
                );
              },
            ),
    );
  }
}
