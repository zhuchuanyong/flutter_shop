import 'package:flutter/material.dart';
import "package:provide/provide.dart";
import 'package:flutter_shop/pages/index_page.dart';
import 'package:flutter_shop/provide/child_category.dart';

void main() {
  var providers = Providers();
  var childCategory = ChildCategory();
  providers..provide(Provider<ChildCategory>.value(childCategory));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false, // 去掉debug
        theme: ThemeData(primaryColor: Colors.pink //主题背景色
            ),
        home: IndexPage(),
      ),
    );
  }
}
