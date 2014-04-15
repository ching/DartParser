import 'dart:core';

import 'Parser.dart';
import 'ArithmeticExpression.dart';
import 'NumericExpression.dart';

class ParserTest {
  static final double EPSILON = .000001;
  @Test
  void testParseNumericExpression() {
    Parser parser = new Parser("3");
    ArithmeticExpression ae = parser.parse();
    assertTrue(ae instanceof NumericExpression);
    assertEquals(3, ((NumericExpression) ae).getValue(), EPSILON);

    parser = new Parser("-12.7");
    ae = parser.parse();
    assertTrue(ae instanceof NumericExpression);
    assertEquals(-12.7, ((NumericExpression) ae).getValue(), EPSILON);

    // This should fail, since the number is malformed.
    parser = new Parser("327..46a");
    try {
      parser.parse();
      fail("Parse should have failed.");
    } catch (ParseException e) {
      // Exception expected.
    }
  }

  @Test
  public void testRecursiveExpression() throws ParseException {
    // Test some valid expressions.
    Parser parser = new Parser("{ + 1 2 }");
    ArithmeticExpression ae = parser.parse();
    assertTrue(ae instanceof AdditionExpression);

    parser = new Parser("{ + 1 { - 3 4 } }");
    ae = parser.parse();
    assertTrue(ae instanceof AdditionExpression);
    assertTrue(((AdditionExpression) ae).getLhs() instanceof NumericExpression);
    assertTrue(((AdditionExpression) ae).getRhs() instanceof SubtractionExpression);

    // Test failures.
    final String[] failingExpressions = { "{ + 7 2", "{ }", "{ + 7 }", "{ * 6 4 }" };
    for (int i = 0; i < failingExpressions.length; i++) {
      parser = new Parser(failingExpressions[i]);
      try {
        parser.parse();
        fail("Parse should have failed on: " + failingExpressions[i]);
      } catch (ParseException e) {
        // Exception expected.
      }
    }
  }

  @Test
  public void testSplitString() {
    String[] result = Parser.splitString("{+ 1 2}");
    assertEquals("{", result[0]);
    assertEquals("+", result[1]);
    assertEquals("1", result[2]);
    assertEquals("2", result[3]);
    assertEquals("}", result[4]);
    assertEquals(5, result.length);

    result = Parser.splitString("   {     + 1 2}");
    assertEquals(5, result.length);
  }
}
