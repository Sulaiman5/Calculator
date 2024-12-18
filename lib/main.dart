import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String input = '';
  double finalResult = 0;
  late int prassequl = 0, prasskey = 0, prassroot = 0;
  
  //final result method
double calculate(String expression) {
  List<String> operations = expression.split(RegExp(r'(\+|-|\×|\÷)'));
  List<String> operators = expression.split(RegExp(r'\d+(\.\d+)?')).where((element) => element.isNotEmpty).toList();

  double result = double.tryParse(operations[0]) ?? 0;
    if(result==0){
    double? ss = double.tryParse(expression.replaceAll('%', ''));
     result = (ss!/100);
   }
  for (int i = 1; i < operations.length; i++) {
    double value = double.tryParse(operations[i]) ?? 0;
    String operator = operators[i - 1];

    switch (operator) {
      case '+':
        result += value;
        break;
      case '-':
        result -= value;
        break;
      case '×':
        result *= value;
        break;
      case '÷':
        result /= value;
        break;
      default:
        break;
    }
    // Handle percentage separately after applying other operations
    if (operations[i].endsWith('%')) {
      double percentage = double.tryParse(operations[i].replaceAll('%', '')) ?? 0;
      switch (operator) {
        case '+':
          result += (result * (percentage / 100));
          break;
        case '-':
          result -= (result * (percentage / 100));
           break;
        case '×':
          result *= (1 + (percentage / 100)); // Multiply by 1 + percentage/100 to get the percentage of the current value
          break;
        case '÷':
          result /= (1 + (percentage / 100)); // Divide by 1 + percentage/100 to get the percentage of the current value
          break;
        default:
          break;
      }
    }
  }

  return result;
}


String formatDouble(double value) {
  if (value % 1 == 0) {
    return value.toInt().toString(); // If the value is an integer, return it without decimal places
  } else {
    String stringValue = value.toString();
    List<String> parts = stringValue.split('.');
    if (parts.length == 2 && int.parse(parts[1]) == 0) {
      return parts[0]; // If digits after the decimal point are all zeros, exclude the decimal point
    } else {
      return stringValue; // Otherwise, return the original string representation
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator", style: TextStyle(fontSize: 25)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 220, 238, 237),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.end, 
        children: [
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.bottomRight,
                    color: Colors.transparent,
                    child: Text(
                      input,
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 244, 244, 245),
                    child: Text(
                      finalResult==0? "": formatDouble(finalResult).toString(),
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: const Color.fromARGB(255, 252, 253, 253),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 0;
                            prassroot = 1;
                            input = '$input\u221A'; //square root symbol
                          });
                        },
                        child: digitButton(context, '\u221A'),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                              prasskey = 1;
                              input = '$input%';
                              finalResult = calculate(input);
                          });
                        },
                        child: digitButton(context, "%"),
                      )),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            });
                          },
                          child: digitButton(context, "C"),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (prassequl == 1) {
                                input = '';
                                prasskey = 0;
                                prassequl = 0;
                                finalResult = 0;
                              }
                              prasskey = 1;
                              if (input.startsWith('√')) {
                                input = input.substring(0, input.length - 1);
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                              if (input.isNotEmpty) {
                                input = input.substring(0, input.length - 1);
                                finalResult = calculate(input);
                                if(input.length==1){
                                  input = '';
                                  prasskey = 0;
                                  prassequl = 0;
                                  finalResult = 0;
                                }
                              }
                              }
                            });
                          },
                          child: iconButton(context, Icons.backspace_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}1';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}1';
                            finalResult = calculate(input);
                            }
                          });
                        },
                        child: digitButton(context, "1"),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}2';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}2';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "2"),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}3';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}3';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "3"),
                      )),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (prassequl == 1) {
                                input = '';
                                prasskey = 0;
                                prassequl = 0;
                                finalResult = 0;
                              }
                              String lastCharacter = input.substring(input.length - 1);
                              if (lastCharacter == '+' ||
                                  lastCharacter == '-' ||
                                  lastCharacter == '×' ||
                                  lastCharacter == '÷' && prasskey == 0) {
                                input = input.substring(0, input.length - 1);
                                prasskey = 1;
                              }
                              if (prasskey == 1) {
                                input = '$input+';
                                prasskey = 0;
                              }
                            });
                          },
                          child: digitButton(context, "+"),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}4';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}4';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "4"),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}5';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}5';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "5"),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}6';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}6';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "6"),
                      )),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (prassequl == 1) {
                                input = '';
                                prasskey = 0;
                                prassequl = 0;
                                finalResult = 0;
                              }
                              String lastCharacter = input.substring(input.length - 1);
                              if (lastCharacter == '+' ||
                                  lastCharacter == '-' ||
                                  lastCharacter == '×' ||
                                  lastCharacter == '÷' && prasskey == 0) {
                                input = input.substring(0, input.length - 1);
                                prasskey = 1;
                              }
                              if (prasskey == 1) {
                                input = '$input-';
                                prasskey = 0;
                              }
                            });
                          },
                          child: digitButton(context, "-"),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}7';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}7';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "7"),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}8';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}8';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "8"),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}9';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}9';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "9"),
                      )),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (prassequl == 1) {
                                input = '';
                                prasskey = 0;
                                prassequl = 0;
                                finalResult = 0;
                              }
                              String lastCharacter = input.substring(input.length - 1);
                              if (lastCharacter == '+' ||
                                  lastCharacter == '-' ||
                                  lastCharacter == '×' ||
                                  lastCharacter == '÷' && prasskey == 0) {
                                input = input.substring(0, input.length - 1);
                                prasskey = 1;
                              }
                              if (prasskey == 1) {
                                input = '$input×'; //x or multiple
                                prasskey = 0;
                              }
                            });
                          },
                          child: digitButton(context, '\u00D7'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            if (prassequl == 1) {
                              input = '';
                              prasskey = 0;
                              prassequl = 0;
                              finalResult = 0;
                            }
                            prasskey = 1;
                            if (input.startsWith('√')) {
                                input = '${input}0';
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              } else {
                            input = '${input}0';
                            finalResult = calculate(input);
                              }
                          });
                        },
                        child: digitButton(context, "0"),
                      )),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (prassequl == 1) {
                                input = '';
                                prasskey = 0;
                                prassequl = 0;
                                finalResult = 0;
                              }
                              prasskey = 1;
                              input = '$input.';
                            });
                          },
                          child: digitButton(context, "."),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              prassequl = 1;
                              if(prassroot==0){
                               input = formatDouble(finalResult).toString();
                               finalResult = 0;
                              }else{
                              if (input.startsWith('√')) {
                                double number = double.tryParse(input.substring(1)) ?? 0;
                                if (number >= 0) {
                                   finalResult = sqrt(number);
                                }
                              }
                              prassroot = 0;
                              }
                            });
                          },
                          child: digitButton(context, "="),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (prassequl == 1) {
                                input = '';
                                prasskey = 0;
                                prassequl = 0;
                                finalResult = 0;
                              }
                              String lastCharacter = input.substring(input.length - 1);
                              if (lastCharacter == '+' ||
                                  lastCharacter == '-' ||
                                  lastCharacter == '×' ||
                                  lastCharacter == '÷' && prasskey == 0) {
                                input = input.substring(0, input.length - 1);
                                prasskey = 1;
                              }
                              if (prasskey == 1) {
                                input = '$input÷'; // divite
                                prasskey = 0;
                              }
                            });
                          },
                          child: digitButton(context, '\u00F7'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget digitButton(BuildContext context, String txt) {
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 220, 238, 237),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        txt,
        style: const TextStyle(fontSize: 35, color: Colors.black),
      ),
    );
  }

  Widget iconButton(BuildContext context, IconData iconData) {
    return Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 220, 238, 237),
            borderRadius: BorderRadius.circular(20)),
        child: Icon(iconData));
  }
}
