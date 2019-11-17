import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_shop/service/service_method.dart';
import '../model/category.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
      child: Center(
        child: Text('类别'),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      print(data);
      CategoryBigListModel list = CategoryBigListModel.fromJson(data['data']);
      list.data.forEach((item) => print(item.mallCategoryName));
    });
  }
}
