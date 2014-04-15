import 'dart:collection';
import 'dart:io';

import 'ArithmeticExpression.dart';
import 'AdditionExpression.dart';
import 'IfExpression.dart';
import 'NumericExpression.dart';
import 'ParseException.dart';
import 'SubtractionExpression.dart';

class Parser {
  static final String LBRACE = '{';
  static final String RBRACE = '}';
  static final String PLUS = '+';
  static final String MINUS = '-';
  static final String IF0 = 'if0';

  Queue<String> remainingTokens = new Queue<String>();

  Parser(String program) {
    remainingTokens.addAll(splitString(program));
  }

  ArithmeticExpression parse() => parseAE();

  static List<String> splitString(String s)  =>
      s.replaceAll(LBRACE, ' ' + LBRACE + ' ')
        .replaceAll(RBRACE, ' ' + RBRACE + ' ')
        .trim()
        .split(' +');

  String nextToken() {
    if (hasNextToken()) {
      return remainingTokens.first;
    }
    throw new ParseException('Unexpectedly reached end of input.');
   }

  String consumeToken() {
    if (hasNextToken()) {
      return remainingTokens.removeFirst();
    }
    throw new ParseException('Unexpectedly reached end of input.');
   }

  bool hasNextToken() => remainingTokens.length > 0;

  ArithmeticExpression parseAE() {
    // Check for an addition or subtraction
    if (nextToken() == LBRACE) {
      consumeToken();
      // The following token must be either PLUS or MINUS.
      if (nextToken() == PLUS) {
        consumeToken();
        ArithmeticExpression lhs = parseAE();
        ArithmeticExpression rhs = parseAE();
        // The remaining token must be a right brace.
        if (consumeToken() == RBRACE) {
          return new AdditionExpression(lhs, rhs);
        }
      } else if (nextToken() == MINUS) {
        consumeToken();
        ArithmeticExpression lhs = parseAE();
        ArithmeticExpression rhs = parseAE();
        // The remaining token must be a right brace.
        if (consumeToken() == RBRACE) {
          return new SubtractionExpression(lhs, rhs);
        }
      } else if (nextToken() == IF0) {
          consumeToken();
          ArithmeticExpression test = parseAE();
          ArithmeticExpression truth = parseAE();
          ArithmeticExpression falsity = parseAE();
          if (consumeToken() == RBRACE) {
            return new IfExpression(test, truth, falsity);
          }
       }
       throw new ParseException('Malformed/Unbalanced compound expression.');
    }
    // If it's not an addition or subtraction, it must be a number.
    try {
      double d = double.parse(nextToken());
      consumeToken();
      return new NumericExpression(d);
    } catch (NumberFormatException) {
        throw new ParseException('Unable to parse as number:' + nextToken());
    }
  }
}


void main() { // exit when end of input stream reached
  stdin.readLineSync();
  for (;;) {
    stdout.writeln('Enter an expression to parse');
    String input = stdin.readLineSync();
    if (input == null) {
      break;
    }
    stdout.writeln('Your input is $input');
    Parser parser = new Parser(input);
    try {
      ArithmeticExpression ae = parser.parse();
      String aeValue = ae.getValue().toString();
      stdout.writeln('The expressed parsed correctly, yielding: $aeValue');
      stdout.writeln('Its values is $aeValue');
    } on ParseException catch (e) {
      stdout.writeln('Parse error: $e');
    }
  }
}
