import 'package:flutter/material.dart';
import 'package:flutter_application/convert_page.dart';
import 'package:flutter_application/history_page.dart';
import 'package:flutter_application/info_page.dart';
import 'package:flutter_application/stock_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'investment_page.dart';

class HomePage extends StatefulWidget {
  final List<String> historyList;

  const HomePage({super.key, this.historyList = const []});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  String fromCurrency = 'USD';
  String toCurrency = 'THB';
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> currencies = [
    'USD',
    'THB',
    'EUR',
    'JPY',
    'GBP',
    'CNY',
    'KRW',
    'AUD',
    'CAD',
    'CHF',
    'SGD',
    'HKD',
    'NZD',
    'INR',
    'RUB',
    'ZAR',
    'SEK',
    'NOK',
    'MXN',
    'BRL'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void swapCurrencies() {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) {
      _controller.reset();
    }
    _controller.forward(from: 0.0);

    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
  }

  void incrementAmount() {
    setState(() {
      double currentAmount = double.tryParse(amountController.text) ?? 0;
      amountController.text = (currentAmount + 1).toString();
    });
  }

  void decrementAmount() {
    setState(() {
      double currentAmount = double.tryParse(amountController.text) ?? 0;
      if (currentAmount > 0) {
        amountController.text = (currentAmount - 1).toString();
      }
    });
  }

  void handleConvert() {
    if (amountController.text.isEmpty) {
      Fluttertoast.showToast(msg: "กรุณากรอกจำนวนเงิน");
      return;
    }

    double? amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      Fluttertoast.showToast(msg: "กรุณากรอกจำนวนเงินที่ถูกต้อง");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConvertPage(
            amount: amount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            historyList: widget.historyList,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แปลงสกุลเงิน',
          style: GoogleFonts.prompt(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "ประวัติ"),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "หุ้น"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: "การลงทุน"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "ข้อมูล"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HistoryPage(historyList: widget.historyList)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StockPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InvestmentPage()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoPage()),
            );
          }
        },
      ),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/exchange_image.jpg'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'กรอกจำนวนเงิน',
                      labelStyle: GoogleFonts.prompt(fontSize: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.redAccent),
                              onPressed: decrementAmount),
                          IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.green),
                              onPressed: incrementAmount),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<String>(
                        value: fromCurrency,
                        onChanged: (value) =>
                            setState(() => fromCurrency = value!),
                        items: currencies.map((currency) {
                          return DropdownMenuItem(
                              value: currency,
                              child:
                                  Text(currency, style: GoogleFonts.prompt()));
                        }).toList(),
                      ),
                      RotationTransition(
                        turns: _animation,
                        child: IconButton(
                          icon: Icon(Icons.swap_horiz,
                              size: 36, color: Colors.blueAccent),
                          onPressed: swapCurrencies,
                        ),
                      ),
                      DropdownButton<String>(
                        value: toCurrency,
                        onChanged: (value) =>
                            setState(() => toCurrency = value!),
                        items: currencies.map((currency) {
                          return DropdownMenuItem(
                              value: currency,
                              child:
                                  Text(currency, style: GoogleFonts.prompt()));
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: handleConvert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    ),
                    child: Text(
                      'แปลงสกุลเงิน',
                      style: GoogleFonts.prompt(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
