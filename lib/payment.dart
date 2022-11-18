import 'package:flutter/material.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:iamport_flutter/Iamport_certification.dart';
import 'package:iamport_flutter/iamport_payment.dart';

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
          amount: 1000,                                               // 결제금액
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
