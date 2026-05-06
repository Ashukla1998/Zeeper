// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CalculatorScreen extends StatefulWidget {
//   final Function(double, String) onAdd;

//   CalculatorScreen({required this.onAdd});

//   @override
//   _CalculatorScreenState createState() => _CalculatorScreenState();
// }

// class _CalculatorScreenState extends State<CalculatorScreen> {
//   String display = "0";
//   String expression = "";

//   double firstValue = 0;
//   String operator = "";
//   bool isNewInput = true;

//   bool showTypeSelector = false;

//   void onNumberTap(String value) {
//     setState(() {
//       if (isNewInput) {
//         display = value;
//         isNewInput = false;
//       } else {
//         display += value;
//       }
//       expression += value;
//     });
//   }

//   void onOperatorTap(String op) {
//     setState(() {
//       firstValue = double.parse(display);
//       operator = op;
//       expression += " $op ";
//       isNewInput = true;
//     });
//   }

//   void onEqualsTap() {
//     double secondValue = double.parse(display);
//     double result = 0;

//     if (operator == "+") result = firstValue + secondValue;
//     if (operator == "-") result = firstValue - secondValue;
//     if (operator == "*") result = firstValue * secondValue;
//     if (operator == "/")
//       result = secondValue != 0 ? firstValue / secondValue : 0;

//     HapticFeedback.mediumImpact();

//     setState(() {
//       display = result.toStringAsFixed(2);
//       expression = display;
//       isNewInput = true;
//       showTypeSelector = true;
//     });
//   }

//   void saveTransaction(String type) {
//     widget.onAdd(double.parse(display), type);
//     setState(() {
//       showTypeSelector = false;
//     });
//   }

//   void clearAll() {
//     setState(() {
//       display = "0";
//       expression = "";
//       firstValue = 0;
//       operator = "";
//       isNewInput = true;
//       showTypeSelector = false;
//     });
//   }

//   void backspace() {
//     setState(() {
//       if (display.length > 1) {
//         display = display.substring(0, display.length - 1);
//         if (expression.isNotEmpty) {
//           expression = expression.substring(0, expression.length - 1);
//         }
//       } else {
//         display = "0";
//         expression = "";
//         isNewInput = true;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             // 🔝 DISPLAY
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     AnimatedOpacity(
//                       duration: Duration(milliseconds: 200),
//                       opacity: expression.isEmpty ? 0.3 : 1,
//                       child: Text(
//                         expression,
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey[500],
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     AnimatedSwitcher(
//                       duration: Duration(milliseconds: 300),
//                       child: Text(
//                         display,
//                         key: ValueKey(display),
//                         style: TextStyle(
//                           fontSize: 56,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),

//                     // 💰 TYPE SELECTOR
//                     AnimatedSwitcher(
//                       duration: Duration(milliseconds: 300),
//                       child: showTypeSelector
//                           ? Row(
//                               key: ValueKey("selector"),
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 buildTypeButton("Cash", Colors.green),
//                                 SizedBox(width: 10),
//                                 buildTypeButton("UPI", Colors.blue),
//                               ],
//                             )
//                           : SizedBox.shrink(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // 🔘 KEYPAD
//             Expanded(
//               flex: 5,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Column(
//                   children: [
//                     buildRow(["C", "⌫", "/", "*"]),
//                     buildRow(["7", "8", "9", "-"]),
//                     buildRow(["4", "5", "6", "+"]),
//                     buildRow(["1", "2", "3", "="]),
//                     buildRow(["0"]),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTypeButton(String label, Color color) {
//     return ElevatedButton(
//       onPressed: () => saveTransaction(label.toLowerCase()),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: Text(label),
//     );
//   }

//   Widget buildRow(List<String> buttons) {
//     return Expanded(
//       child: Row(
//         children: buttons.map((btn) {
//           return Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(6),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: btn == "C"
//                       ? Colors.redAccent
//                       : btn == "="
//                       ? Colors.greenAccent
//                       : Color(0xFF1E1E1E),
//                   elevation: 6,
//                   shadowColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (btn == "C")
//                     clearAll();
//                   else if (btn == "⌫")
//                     backspace();
//                   else if (btn == "=")
//                     onEqualsTap();
//                   else if (["+", "-", "*", "/"].contains(btn))
//                     onOperatorTap(btn);
//                   else
//                     onNumberTap(btn);
//                 },
//                 child: Text(
//                   btn,
//                   style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorScreen extends StatefulWidget {
  final Function(double, String) onAdd;

  const CalculatorScreen({super.key, required this.onAdd});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = "0";
  String expression = "";

  double firstValue = 0;
  String operator = "";
  bool isNewInput = true;

  bool showTypeSelector = false;

  void onNumberTap(String value) {
    setState(() {
      if (isNewInput || display == "0") {
        display = value;
        isNewInput = false;
      } else {
        display += value;
      }

      expression += value;
    });
  }

  void onOperatorTap(String op) {
    setState(() {
      firstValue = double.parse(display);
      operator = op;
      expression += " $op ";
      isNewInput = true;
    });
  }

  void onEqualsTap() {
    double secondValue = double.parse(display);
    double result = 0;

    if (operator == "+") {
      result = firstValue + secondValue;
    } else if (operator == "-") {
      result = firstValue - secondValue;
    } else if (operator == "*") {
      result = firstValue * secondValue;
    } else if (operator == "/") {
      result = secondValue != 0 ? firstValue / secondValue : 0;
    }

    HapticFeedback.mediumImpact();

    setState(() {
      display = result.toStringAsFixed(2);
      expression = display;
      isNewInput = true;
      showTypeSelector = true;
    });
  }

  void saveTransaction(String type) {
    widget.onAdd(double.parse(display), type);

    setState(() {
      showTypeSelector = false;
    });
  }

  void clearAll() {
    setState(() {
      display = "0";
      expression = "";
      firstValue = 0;
      operator = "";
      isNewInput = true;
      showTypeSelector = false;
    });
  }

  void backspace() {
    setState(() {
      if (display.length > 1) {
        display = display.substring(0, display.length - 1);

        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else {
        display = "0";
        expression = "";
        isNewInput = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      body: SafeArea(
        child: Column(
          children: [
            // DISPLAY AREA
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      expression,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 8),

                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        display,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: showTypeSelector
                          ? Row(
                              key: const ValueKey("selector"),
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                buildTypeButton("Cash", Colors.green),

                                const SizedBox(width: 10),

                                buildTypeButton("UPI", Colors.blue),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // KEYPAD
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: [
                    buildRow(["C", "⌫", "/", "*"]),
                    buildRow(["7", "8", "9", "-"]),
                    buildRow(["4", "5", "6", "+"]),
                    buildRow(["1", "2", "3", "="]),
                    buildRow(["0"]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTypeButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () => saveTransaction(label.toLowerCase()),

      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shadowColor: Colors.black,

                  backgroundColor: btn == "C"
                      ? Colors.redAccent
                      : btn == "="
                      ? Colors.green
                      : const Color(0xFF1E1E1E),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () {
                  if (btn == "C") {
                    clearAll();
                  } else if (btn == "⌫") {
                    backspace();
                  } else if (btn == "=") {
                    onEqualsTap();
                  } else if (["+", "-", "*", "/"].contains(btn)) {
                    onOperatorTap(btn);
                  } else {
                    onNumberTap(btn);
                  }
                },

                child: Text(
                  btn,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
