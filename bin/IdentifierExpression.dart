import 'RCFAE.dart';

class IdentifierExpression extends RCFAE {
  String symbol;

  IdentifierExpression(this.symbol);

  @override
  num getValue() => super.getValue();

  @override
  String toString() => '<IdentifierExpression $symbol>';
}