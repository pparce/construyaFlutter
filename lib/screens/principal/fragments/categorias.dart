import 'package:construyaalcosto/models/category.dart';
import 'package:construyaalcosto/screens/principal/principal.dart';
import 'package:construyaalcosto/services/dialogs-connections-service.dart';
import 'package:construyaalcosto/services/connections-service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CategoriesFragment extends StatefulWidget {
  final Function backPress;
  CategoriesFragment({Key key, this.backPress}) : super(key: key);

  @override
  _CategoriesFragmentState createState() => _CategoriesFragmentState();
}

class _CategoriesFragmentState extends State<CategoriesFragment> {
  // List<Category> _categories;
  List<CategoryList> _categories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  _getCategories() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DialogsConnections.showLoadingDialog(context);
    });
    final Response response = await Connections().get(Connections.CATEGORIES);
    if (response != null && response.statusCode == 200) {
      List<Categorie> categoriesAux =
          List<Categorie>.from(response.data.map((x) => Categorie.fromJson(x)));
      DialogsConnections.hideLoadingDialog(context);
      _buildCategoryList(categoriesAux);
      setState(() {});
    } else {
      DialogsConnections.hideLoadingDialog(context);
      DialogsConnections.showRetryDialog(
        context,
        _getCategories,
        widget.backPress,
      );
    }
  }

  void _buildCategoryList(List<Categorie> _categories) {
    List<Categorie> categoriresFathers =
        _categories.where((element) => element.category == null).toList();
    this._categories = [];
    for (var item in categoriresFathers) {
      this._categories.add(CategoryList(
          category: item,
          isExpanded: false,
          subList: _categories
              .where((element) => element.category == item.id)
              .toList()));
    }
  }

  List<Widget> _getCategoriesItems() {
    List<Widget> items = [];
    for (var item in _categories) {
      if (item.subList.isEmpty) {
        items.add(ListTile(
          title: Text(item.category.name),
          onTap: () {
            _onTapCategory(item.category);
          },
        ));
      } else {
        items.add(ExpansionTile(
          title: Text(item.category.name),
          children: item.subList
              .map<Widget>(
                (e) => ListTile(
                  title: Text(e.name),
                  onTap: () {
                    _onTapCategory(item.category);
                  },
                ),
              )
              .toList(),
        ));
      }
    }
    return items;
  }

  void _onTapCategory(Categorie categorie) {
    Navigator.of(context).pushNamed('/productos', arguments: categorie);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: _getCategoriesItems(),
      ),
    );
  }
}
