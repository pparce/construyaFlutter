import 'package:flutter/material.dart';

class Qty extends StatefulWidget {
  final Function onTextChange;
  Qty({Key key, this.onTextChange}) : super(key: key);

  @override
  _QtyState createState() => _QtyState();
}

class _QtyState extends State<Qty> {
  TextEditingController controller;
  int qty = 1;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: qty.toString());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  _onAdd() {
    qty++;
    controller.text = qty.toString();
    widget.onTextChange(qty);
  }

  _onLess() {
    if (qty > 1) {
      qty--;
      controller.text = qty.toString();
      widget.onTextChange(qty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        // height: 40,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Theme.of(context).accentColor,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: Theme.of(context).accentColor)),
                ),
                height: 45,
                child: InkWell(
                  splashColor: Colors.blue[100],
                  onTap: () {
                    _onLess();
                  },
                  child: Icon(Icons.remove),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 4),
                // width: 30,
                height: 45,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  controller: controller,
                  onChanged: (value) {
                    widget.onTextChange(value);
                  },
                  style: TextStyle(fontSize: 18),
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Theme.of(context).accentColor)),
                ),
                height: 45,
                child: InkWell(
                  splashColor: Colors.blue[100],
                  onTap: () {
                    _onAdd();
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
