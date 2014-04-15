import 'ArithmeticExpression.dart';

abstract class BinaryExpression extends ArithmeticExpression {
  ArithmeticExpression lhs;
  ArithmeticExpression rhs;

  BinaryExpression(ArithmeticExpression lhs, ArithmeticExpression rhs) {
      this.setLhs(lhs);
      this.setRhs(rhs);
    }

    void setLhs(ArithmeticExpression lhs) {
      this.lhs = lhs;
    }

    ArithmeticExpression getLhs() {
      return lhs;
    }

    void setRhs(ArithmeticExpression rhs) {
      this.rhs = rhs;
    }

    ArithmeticExpression getRhs() {
      return rhs;
    }
}
