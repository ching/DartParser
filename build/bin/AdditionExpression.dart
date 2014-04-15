import 'ArithmeticExpression.dart';
import 'BinaryExpression.dart';

class AdditionExpression extends BinaryExpression {
  AdditionExpression(ArithmeticExpression lhs, ArithmeticExpression rhs) :
    super(lhs, rhs);

  @override
  double getValue() => lhs.getValue() + rhs.getValue();
}




