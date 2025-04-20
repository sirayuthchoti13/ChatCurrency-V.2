import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({super.key});

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  final TextEditingController budgetController = TextEditingController();
  String selectedCurrency = 'USD';

  // 🌍 อัตราแลกเปลี่ยนตัวอย่าง (1 USD = ? สกุลอื่น)
  final Map<String, double> currencyRates = {
    'USD': 1.0,
    'THB': 36.5,
    'EUR': 0.92,
    'JPY': 153.4,
    'GBP': 0.80,
    'CNY': 7.1,
    'KRW': 1380.0,
    'AUD': 1.52,
    'CAD': 1.36,
    'CHF': 0.91,
    'SGD': 1.34,
    'HKD': 7.83,
    'NZD': 1.66,
    'INR': 83.2,
    'RUB': 94.5,
    'ZAR': 18.4,
    'SEK': 10.8,
    'NOK': 10.7,
    'MXN': 17.0,
    'BRL': 5.0,
  };

  final Map<String, double> stocks = {
    "AAPL": 172.35,
    "GOOGL": 2835.22,
    "TSLA": 702.41,
    "AMZN": 3334.34,
    "MSFT": 305.22,
    "META": 215.44,
    "NVDA": 860.11,
    "NFLX": 415.23,
    "INTC": 42.78,
    "BABA": 85.67,
  };

  Map<String, double> investmentDistribution = {};

  void recommendStocks() {
    double? budgetInput = double.tryParse(budgetController.text);
    if (budgetInput == null || budgetInput <= 0) return;

    // แปลงงบประมาณกลับเป็น USD
    double budgetInUSD = budgetInput / currencyRates[selectedCurrency]!;

    setState(() {
      investmentDistribution.clear();
      double totalUsed = 0;

      stocks.forEach((stock, price) {
        if (budgetInUSD >= price) {
          int quantity = budgetInUSD ~/ price;
          double investedAmount = quantity * price;
          if (investedAmount > 0) {
            investmentDistribution[stock] = investedAmount;
            totalUsed += investedAmount;
          }
        }
      });

      investmentDistribution.updateAll((key, value) => (value / totalUsed) * 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'คำแนะนำการลงทุน',
          style: GoogleFonts.prompt(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: budgetController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'งบประมาณ',
                        labelStyle: GoogleFonts.prompt(fontSize: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  DropdownButton<String>(
                    value: selectedCurrency,
                    items: currencyRates.keys.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCurrency = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: recommendStocks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  textStyle: GoogleFonts.prompt(fontSize: 18, color: Colors.white),
                ),
                child: Text('แนะนำหุ้น'),
              ),
              SizedBox(height: 24),
              if (investmentDistribution.isEmpty)
                Text(
                  'ไม่มีหุ้นที่แนะนำสำหรับงบประมาณนี้',
                  style: GoogleFonts.prompt(fontSize: 16, color: Colors.red),
                )
              else ...[
                Text(
                  'สัดส่วนการลงทุนที่แนะนำ:',
                  style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                PieChart(
                  dataMap: investmentDistribution,
                  chartType: ChartType.disc,
                  chartRadius: MediaQuery.of(context).size.width / 1.6,
                  legendOptions: LegendOptions(
                    legendPosition: LegendPosition.bottom,
                    showLegendsInRow: true,
                    legendTextStyle: GoogleFonts.prompt(),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValuesInPercentage: true,
                    showChartValues: true,
                    chartValueStyle: GoogleFonts.prompt(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
