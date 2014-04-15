import 'RCFAE.dart';
import 'BinaryExpression.dart';

class SubtractionExpression extends BinaryExpression {
  SubtractionExpression(RCFAE lhs, RCFAE rhs) :
    super(lhs, rhs);

  @override
  num getValue() => lhs.getValue() - rhs.getValue();

  @override
  String toString() => '<SubtractionExpression $lhs $rhs>';
}
