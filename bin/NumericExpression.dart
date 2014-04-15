import 'RCFAE.dart';

class NumericExpression extends RCFAE {
  num value;

  NumericExpression(this.value);

  num getValue() => value;

  @override
  String toString() => '<NumericExpression $value>';
}