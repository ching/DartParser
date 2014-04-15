import 'ArithmeticExpression.dart';
import 'BinaryExpression.dart';

class SubtractionExpression extends BinaryExpression {
  SubtractionExpression(ArithmeticExpression lhs, ArithmeticExpression rhs) :
    super(lhs, rhs);

  @override
  double getValue() => lhs.getValue() - rhs.getValue();
}
