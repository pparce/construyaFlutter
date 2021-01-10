import 'package:flutter/material.dart';

class ItemDrawer extends StatelessWidget {
  const ItemDrawer(
      {Key key,
      this.selected = false,
      this.background,
      this.title,
      this.icon,
      this.textColor = Colors.black,
      this.textColorSelected = Colors.white,
      this.onTap})
      : super(key: key);

  final String title;
  final IconData icon;
  final bool selected;
  final Color background;
  final textColor;
  final textColorSelected;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: InkWell(
        focusColor: Theme.of(context).accentColor,
        splashColor: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: ShapeDecoration(
              color: selected ? background : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? textColorSelected : textColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: selected ? textColorSelected : textColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
