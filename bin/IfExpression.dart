import 'RCFAE.dart';

class IfExpression extends RCFAE {
  RCFAE test;
  RCFAE truth;
  RCFAE falsity;

  IfExpression(this.test, this.truth, this.falsity);

  @override
  num getValue() {
    if (test.getValue() == 0) {
      return truth.getValue();
    }
    return falsity.getValue();
  }

  @override
  String toString() => '<IfExpression $test $truth $falsity>';
}