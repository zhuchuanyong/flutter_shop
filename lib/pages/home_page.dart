import 'package:flutter/material.dart';
import 'dart:convert';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart'; // 轮播插件
import 'package:flutter_screenutil/flutter_screenutil.dart'; //适配ui
import 'package:url_launcher/url_launcher.dart'; // 拨打电话

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
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            // 数据处理
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navgatorList = (data['data']['category'] as List).cast();
            String adPicture =
                data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList =
                (data['data']['recommend'] as List).cast();
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(swiperDateList: swiper),
                  TopNavigator(navgatorList: navgatorList),
                  AdBanner(AdPicture: adPicture),
                  LeaderPhone(
                      leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommend(recommendList: recommendList)
                ],
              ),
            );
          } else {
            return Center(
              child: Text('加载中'),
            );
          }
        },
      ),
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;
  SwiperDiy({Key key, this.swiperDateList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750), // 设置轮播图片宽高
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            '${swiperDateList[index]['image']}',
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 九宫格组件
class TopNavigator extends StatelessWidget {
  final List navgatorList;
  TopNavigator({Key key, this.navgatorList}) : super(key: key);
  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navgatorList.length > 0) {
      this.navgatorList.removeRange(10, this.navgatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(340),
      // height: ScreenUtil().setHeight(340),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
          crossAxisCount: 5,
          padding: EdgeInsets.all(5.0),
          children: navgatorList.map((item) {
            return _gridViewItemUI(context, item);
          }).toList()),
    );
  }
}

// 广告条
class AdBanner extends StatelessWidget {
  final String AdPicture;
  const AdBanner({Key key, this.AdPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(AdPicture),
    );
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; //店长电话
  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  // 标题组件
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品单独项
  Widget _item(context, index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(350),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 0.5, color: Colors.black12)),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(decoration: TextDecoration.lineThrough),
            )
          ],
        ),
      ),
    );
  }

// 横向列表
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(350),
      // margin: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(context, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(410),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}
