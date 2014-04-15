import 'RCFAE.dart';
import 'BinaryExpression.dart';

class AdditionExpression extends BinaryExpression {
  AdditionExpression(RCFAE lhs, RCFAE rhs) :
    super(lhs, rhs);

  @override
  num getValue() => lhs.getValue() + rhs.getValue();

  @override
  String toString() => '<AdditionExpression $lhs $rhs>';

}




