// From Dart API.
import 'dart:core';
import 'package:unittest/unittest.dart';

// From DartParser.
import 'Parser.dart';
import 'RCFAE.dart';
import 'NumericExpression.dart';
import 'AdditionExpression.dart';
import 'SubtractionExpression.dart';
import 'BinaryExpression.dart';
import 'ParseException.dart';
import 'IdentifierExpression.dart';
import 'IfExpression.dart';
import 'FunctionExpression.dart';
import 'ApplicationExpression.dart';


void main() {
// Failed tests are commented out for cleaner output.

  test('testSplitString_correctInput', () {
    List<String> result = Parser.splitString("{ + 1 2 }");
        expect("{", result[0]);
        expect("+", result[1]);
        expect("1", result[2]);
        expect("2", result[3]);
        expect("}", result[4]);
        expect(5, result.length);
  });

  test('testSplitString_incorrectInput', () {
    List<String> result = Parser.splitString("   {     + 1 2}");
    assert(5 != result.length);
  });

  test('testParseNumericExpression_correctInput', () {
    Parser parser = new Parser("3");
    RCFAE rcfae = parser.parse();
    assert(rcfae is NumericExpression);
    expect(3, rcfae.getValue());

    parser = new Parser("-12");
    rcfae = parser.parse();
    assert(rcfae is NumericExpression);
    expect(-12, rcfae.getValue());

    parser = new Parser("-11.0");
    rcfae = parser.parse();
    assert(rcfae is NumericExpression);
    expect(-11.0, rcfae.getValue());

    parser = new Parser("-1");
    rcfae = parser.parse();
    assert(rcfae is NumericExpression);
    expect(-1, rcfae.getValue());

    parser = new Parser("0");
    rcfae = parser.parse();
    assert(rcfae is NumericExpression);
    expect(0, rcfae.getValue());
  });

  test('testParseNumericExpression_incorrectInput', () {
    final List<String> failingExpressions = ["abc", "a35", "@#%@", " ", "_"];
      Parser parser = new Parser("abc");
      for (int i = 0; i < failingExpressions.length; i++) {
        Parser parser = new Parser(failingExpressions[i]);
        try {
          RCFAE rcfae = parser.parse();
          assert(rcfae is! NumericExpression);
          } on ParseException catch(e) {
            // Exception is thrown
          }
      }
    });

  test('testParseRecursiveExpression_correctInput', () {
   Parser parser = new Parser("{ + 1 2 }");
   RCFAE rcfae = parser.parse();
   assert(rcfae is AdditionExpression);

   parser = new Parser("{ - 1 2 }");
   rcfae = parser.parse();
   assert(rcfae is SubtractionExpression);

   parser = new Parser("{ + 1 { - 3 4 } }");
   rcfae = parser.parse();
   assert(rcfae is AdditionExpression);
   BinaryExpression binRcfae = rcfae;
   assert(binRcfae.getLhs() is NumericExpression);
   assert(binRcfae.getRhs() is SubtractionExpression);

   parser = new Parser("{ + { - 1 4 } { - 3 4 } }");
   rcfae = parser.parse();
   assert(rcfae is AdditionExpression);
   binRcfae = rcfae;
   assert(binRcfae.getLhs() is SubtractionExpression);
   assert(binRcfae.getRhs() is SubtractionExpression);

   parser = new Parser("{ + { + { - { - 1 4 } { - 3 4 } } 5 } { + 6 3 } }");
   rcfae = parser.parse();
   assert(rcfae is AdditionExpression);
   binRcfae = rcfae;
   assert(binRcfae.getLhs() is AdditionExpression);
   assert(binRcfae.getRhs() is AdditionExpression);
  });

  test('testParseRecursiveExpression_incorrectInput', () {
    final List<String> failingExpressions = ["----", "{ cc c}", "{ + 7 }", "{ * 6 4 }" ];
    for (int i = 0; i < failingExpressions.length; i++) {
      Parser parser = new Parser(failingExpressions[i]);
      try {
       RCFAE rcfae = parser.parse();
       fail("Parse should have failed on: $failingExpressions[i]");
      } on ParseException catch(e) {
        // Exception is thrown
      }
    }
  });

  test('testParseAddtionExpression_correctInput', () {
    final List<String> correctExpressions = ["{ + 7 2 }", "{ + 4 4 }", "{ + 5 5 }", "{ + 0 0 }" ];
    for (int i = 0; i < correctExpressions.length; i++) {
      Parser parser = new Parser(correctExpressions[i]);
      RCFAE rcfae = parser.parse();
      assert(rcfae is AdditionExpression);
    }
  });

  test('testParseAddtionExpression_incorrectInput', () {
     final List<String> failingExpressions = ["{% + +}", "4", "x", "{ - 0 0 }", "{ fun { x } 2 }" ];
     for (int i = 0; i < failingExpressions.length; i++) {
       Parser parser = new Parser(failingExpressions[i]);
       try {
         RCFAE rcfae = parser.parse();
         assert(rcfae is! AdditionExpression);
       } on ParseException catch(e) {
         // Exception is thrown.
       }
     }
   });

  test('testParseSubtractionExpression_correctInput', (){
    final List<String> correctExpressions = ["{ - 7 2 }", "{ - 4 4 }", "{ - 5 5 }", "{ - 0 0 }" ];
    for (int i = 0; i < correctExpressions.length; i++) {
      Parser parser = new Parser(correctExpressions[i]);
      RCFAE rcfae = parser.parse();
      assert(rcfae is SubtractionExpression);
     }
   });

  test('testParseSubtractionExpression_incorrectInput', (){
     final List<String> failingExpressions = ["{+ { + s s } 5 }", "4", "x", "{ + 0 0 }", "{ fun { x } 2 }" ];
     for (int i = 0; i < failingExpressions.length; i++) {
       Parser parser = new Parser(failingExpressions[i]);
       try {
         RCFAE rcfae = parser.parse();
         assert(rcfae is! SubtractionExpression);
       } on ParseException catch(e) {
         // Exception is thrown.
       }
     }
   });

  test('testParseIdentifierExpression_correctInput', (){
      final List<String> correctExpressions = ["{ x }", "{ name }", "{ hello }", "{ id }" ];
      for (int i = 0; i < correctExpressions.length; i++) {
        Parser parser = new Parser(correctExpressions[i]);
        RCFAE rcfae = parser.parse();
        assert(rcfae is IdentifierExpression);
       }
   });

  test('testParseIdentifierExpression_incorrectInput', (){
        final List<String> failingExpression = ["x", "name", "89798", "{ d id }", " "];
        for (int i = 0; i < failingExpression.length; i++) {
          Parser parser = new Parser(failingExpression[i]);
          try {
            RCFAE rcfae = parser.parse();
            assert(rcfae is! IdentifierExpression);
          } on ParseException catch(e) {
            // Exception is thrown.
          }
       }
   });

  test('testParseIfExpression_correctInput', (){
        final List<String> correctExpressions = ["{ if0 1 0 0 }", "{ if0 1 1 0 }", "{ if0 { + 0 0 } 0 1 }",
                                                 "{ if0 { - 1 0 } { + 1 0 } { - 1 1 } }" ];
        for (int i = 0; i < correctExpressions.length; i++) {
          Parser parser = new Parser(correctExpressions[i]);
          RCFAE ae = parser.parse();
          assert(ae is IfExpression);
       }
   });

   test('testParseIfExpression_incorrectInput', () {
          final List<String> failingExpression = ["{1 0 0 }", "{ 1 if0 }", " {}",
                                                   "{ if0 {0 } { + 1 0 } { - 1 1" ];
          for (int i = 0; i < failingExpression.length; i++) {
            Parser parser = new Parser(failingExpression[i]);
            try {
              RCFAE rcfae = parser.parse();
              assert(rcfae is! IfExpression);
            } on ParseException catch(e) {
              // Exception is thrown.
            }
         }
     });

  test('testParseFunctionExpression_correctInput', () {
        final List<String> correctExpressions = ["{ fun { x } 0 }", "{ fun { id } { + 9 9 } }",
                                                 "{ fun { f } { - { + 0 1 } { + 0 0 } } }",
                                                 "{ fun { sdsdg } { + 1 0 } }" ];
        for (int i = 0; i < correctExpressions.length; i++) {
          Parser parser = new Parser(correctExpressions[i]);
          RCFAE rcfae = parser.parse();
          assert(rcfae is FunctionExpression);
       }
   });

  test('testParseFunctionExpression_incorrectInput', () {
        final List<String> failingExpression = [" s x 0 ", "{s{id}{+99}}",
                                                 "funk { funk } { - { + 0 1 } { + 0 0 } } }",
                                                 "{ fun { + 1 0 } }" ];
        for (int i = 0; i < failingExpression.length; i++) {
          Parser parser = new Parser(failingExpression[i]);
          try {
            RCFAE rcfae = parser.parse();
            assert(rcfae is! FunctionExpression);
          } on ParseException catch(e) {
            // Exception is thrown.
          }
       }
   });

  test('testApplicationExpression_correctInput', () {
    final List<String> correctExpressions = ["{ app 0 0 }", "{ app 3 3 }", "{ app { + 2 2 } { - 2 2 } }",
                                             "{ app { + { - 4 4 } { - 4 4 } } 1 }"];
    for (int i = 0; i < correctExpressions.length; i++) {
      Parser parser = new Parser(correctExpressions[i]);
      RCFAE rcfae = parser.parse();
      assert(rcfae is ApplicationExpression);
    }
  });

  test('testApplicationExpression_incorrectInput', () {
      final List<String> failingExpression = ["{ apple 0 0 }", "plication 3 3 }",
                                              "{ tapp + 2 2 } { 2 2 } }",
                                              "{ { - 4 4 } } 1 }"];
      for (int i = 0; i < failingExpression.length; i++) {
        Parser parser = new Parser(failingExpression[i]);
        try {
          RCFAE rcfae = parser.parse();
          assert(rcfae is! ApplicationExpression);
        } on ParseException catch(e) {
          // Exception is thrown.
        }
      }
    });
}
