import 'RCFAE.dart';

class ApplicationExpression extends RCFAE{
  RCFAE methodName;
  RCFAE paramName;

  ApplicationExpression(this.methodName, this.paramName);

  @override
  num getValue() => paramName.getValue();

  @override
  String toString() => '<ApplicationExpression $methodName $paramName>';
}