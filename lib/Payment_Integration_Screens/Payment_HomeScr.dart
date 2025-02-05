import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // stripe payment intent
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              makePayment();
            },
            child: Text("Make Payment")),
      ),
    );
  }

  // make payment which help to create payment intent
  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.light,
        merchantDisplayName: "Ali",
        googlePay: gpay,
      ));
      displayPaymentSheet();
    } catch (e) {
      print("Error: $e");
    }
  }

// display payment sheet which help to show the payment page
  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // call the function to update the data in your database or service you provide
    } catch (e) {
      print("Error: $e");
    }
  }

// create payment intent which help to create payment intent
  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "100",
        "currency": "USD",
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51Qp8gzGA2pf4pHeXDg2aZXVspQNFjRcfdSA8k8LjvyXtEkQIYpyogjSr5JmCPCRuibq2CxsJu0nW0a2oyFDZa05500G30DMwlI",
            "Content-Type": "application/x-www-form-urlencoded",
          });

      return json.decode(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }
}
