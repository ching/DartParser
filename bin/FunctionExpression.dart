import 'RCFAE.dart';
import 'IdentifierExpression.dart';

class FunctionExpression extends RCFAE {
  IdentifierExpression symbol;
  RCFAE body;

  FunctionExpression(this.symbol, this.body);

  @override
  num getValue() => body.getValue();

  @override
  String toString() => '<FunctionExpression $symbol $body>';
}