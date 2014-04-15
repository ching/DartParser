import 'RCFAE.dart';

abstract class BinaryExpression extends RCFAE {
  RCFAE lhs;
  RCFAE rhs;

  BinaryExpression(this.lhs, this.rhs);

  RCFAE getLhs() => lhs;
  RCFAE getRhs() => rhs;
}
