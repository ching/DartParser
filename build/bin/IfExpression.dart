import 'ArithmeticExpression.dart';

class IfExpression extends ArithmeticExpression {
  ArithmeticExpression test;
  ArithmeticExpression truth;
  ArithmeticExpression falsity;

  IfExpression(this.test, this.truth, this.falsity);

  bool isNearZero(double d) {
    final double epsilon = .00001;
    return d < epsilon && d > -epsilon;
  }

  @override
  double getValue() {
    if (isNearZero(test.getValue())) {
      return truth.getValue();
    } else {
      return falsity.getValue();
    }
  }

}