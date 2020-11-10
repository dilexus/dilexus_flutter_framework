import 'package:dilexus/imports.dart';

class Fragment extends StatelessWidget {
  final Color color;
  final Widget child;
  final int flex;

  Fragment({this.child, this.color, this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex != null ? flex : 1,
      child: Container(
        color: color != null ? color : Colors.transparent,
        child: child != null ? child : Container(),
      ),
    );
  }
}
