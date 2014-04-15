// From Dart API
import 'dart:collection';
import 'dart:io';

// From DartParser
import 'RCFAE.dart';
import 'AdditionExpression.dart';
import 'IfExpression.dart';
import 'NumericExpression.dart';
import 'ParseException.dart';
import 'SubtractionExpression.dart';
import 'FunctionExpression.dart';
import 'IdentifierExpression.dart';
import 'ApplicationExpression.dart';

class Parser {
  static final String LBRACE = '{'; // Signifies start of an expression.
  static final String RBRACE = '}'; // Signifies end of an expression.
  static final String PLUS = '+';   // Supports addition operations.
  static final String MINUS = '-';  // Supports subtraction operations.
  static final String IF0 = 'if0';  // Supports conditional statements.
  static final String FUN = 'fun';  // Supports function definitions.
  static final String APP = 'app';  // Supports application of functions.
  static final String ID = 'id';    // Supports naming functions;

  ListQueue<String> remainingTokens = new ListQueue<String>();

  Parser(String program) {
    remainingTokens.addAll(splitString(program));
  }

  RCFAE parse() => parseRCFAE();

  static List<String> splitString(String s) => s.split(' ');

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

  bool hasNextToken() => remainingTokens.first != null;

  RCFAE parseRCFAE() {
    // Check for an addition or subtraction
    if (nextToken() == LBRACE) {
      consumeToken();
      // The following token must be either PLUS or MINUS.
      if (nextToken() == PLUS) {
        consumeToken();
        RCFAE lhs = parseRCFAE();
        RCFAE rhs = parseRCFAE();
        // The remaining token must be a right brace.
        if (consumeToken() == RBRACE) {
          return new AdditionExpression(lhs, rhs);
        }
      } else if (nextToken() == MINUS) {
        consumeToken();
        RCFAE lhs = parseRCFAE();
        RCFAE rhs = parseRCFAE();
        // The remaining token must be a right brace.
        if (consumeToken() == RBRACE) {
          return new SubtractionExpression(lhs, rhs);
        }
      } else if (nextToken() == IF0) {
          consumeToken();
          RCFAE test = parseRCFAE();
          RCFAE truth = parseRCFAE();
          RCFAE falsity = parseRCFAE();
          if (consumeToken() == RBRACE) {
            return new IfExpression(test, truth, falsity);
          }
       } else if (nextToken() == FUN) {
         consumeToken();
         RCFAE id = parseRCFAE();
         RCFAE body = parseRCFAE();
         if (consumeToken() == RBRACE) {
           return new FunctionExpression(id, body);
         }
       } else if (nextToken() == APP) {
         consumeToken();
         RCFAE mathodName = parseRCFAE();
         RCFAE methodBody = parseRCFAE();
         if (consumeToken() == RBRACE) {
           return new ApplicationExpression(mathodName, methodBody);
         }
       } else if (nextToken() is String) {
         String identifier = nextToken();
         consumeToken();
         if (consumeToken() == RBRACE) {
           return new IdentifierExpression(identifier);
         }
       }
      throw new ParseException('Malformed/Unbalanced compound expression.');
    }
    // If it's not an addition or subtraction, it must be a number.
    try {
      num d = num.parse(nextToken());
      consumeToken();
      return new NumericExpression(d);
    } catch (NumberFormatException) {
      throw new ParseException('Unable to parse as number: ' + nextToken());
    }
   }
}


void main() { // exit when end of input stream reached
  stdin.readLineSync();
  for (;;) {
    stdout.writeln('Please enter an expression to parse:');
    String input = stdin.readLineSync();
    if (input == null) {
      break;
    }
    stdout.writeln('Your input is $input');
    Parser parser = new Parser(input);
    try {
      RCFAE rcfae = parser.parse();
      stdout.writeln('Its parsed output is: $rcfae');
    } on ParseException catch (e) {
      stdout.writeln('Parse error: $e');
    }
  }
}
