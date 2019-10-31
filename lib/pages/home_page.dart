import 'package:flutter/material.dart';
import '../service/service_method.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在请求数据';
  @override
  void initState() {
    // TODO: implement initState

    // TODO 请求首页数据
    getHomePageContent().then((val) {
      setState(() {
        homePageContent = val.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活'),
      ),
      body: SingleChildScrollView(
        child: Text(homePageContent),
      ),
    );
  }
}
