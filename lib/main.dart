import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_shop/payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:iamport_flutter/iamport_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<String> imgList=[
    'https://cdn.pixabay.com/photo/2022/11/02/04/07/deer-7563934_640.jpg',
    'https://cdn.pixabay.com/photo/2022/10/21/08/39/cat-7536508_640.jpg',
    'https://cdn.pixabay.com/photo/2021/12/22/03/10/self-care-6886590_640.jpg'
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body:Column(
        children: [
          Container(
            height:280,
            child:Padding(
              padding: const EdgeInsets.all(10),
              child: Swiper(
                autoplay:true,
                scale:.9,
                viewportFraction: .8,
                control:const SwiperControl(),
                pagination: const SwiperPagination(),
                itemCount:imgList.length,
                itemBuilder:(BuildContext context,int index){
                  return Image.network(imgList[index]);
                }
              )
            )
          ),
          Container(
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=>Payment(),
                  )
                );
              },
              child: const Text('Pay'),
            ),
          )
        ],
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Payment extends StatelessWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      initialChild: Container(
          child:Center(
              child:Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0.0,30.0,0.0,0.0),
                    child: const Text(
                      '잠시만 기다려 주세요....',
                      style:TextStyle(fontSize:20.0),
                    ),
                  )
                ],
              )
          )
      ),
      userCode: 'imp71268423',
      data: PaymentData(
          pg: 'html5_inicis',                                          // PG사
          payMethod: 'card',                                           // 결제수단
          name: '아임포트 결제데이터 분석',                                  // 주문명
          merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
          amount: 100,                                               // 결제금액
          buyerName: '홍길동',                                           // 구매자 이름
          buyerTel: '01012345678',                                     // 구매자 연락처
          buyerEmail: 'example@naver.com',                             // 구매자 이메일
          buyerAddr: '서울시 강남구 신사동 661-16',                         // 구매자 주소
          buyerPostcode: '06018',                                      // 구매자 우편번호
          appScheme: 'example',                                        // 앱 URL scheme
          displayCardQuota : [2,3]                                     //결제창 UI 내 할부개월수 제한
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(
          context,
          '/result',
          arguments: result,
        );
      },
    );
  }
}
