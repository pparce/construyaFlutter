import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget accion;
  const EmptyScreen({Key key, this.icon, this.label, this.accion = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.grey[500],
            size: 52,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
          accion ?? Container()
        ],
      ),
    );
  }
}
