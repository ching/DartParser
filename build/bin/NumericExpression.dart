import 'ArithmeticExpression.dart';

class NumericExpression extends ArithmeticExpression {
  double value;

  NumericExpression(this.value);

  double getValue() => value;
}