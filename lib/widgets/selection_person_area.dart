import 'package:flutter/material.dart';
import 'package:super_quest/routes.dart';
import 'package:super_quest/utils/constants.dart';

class SelectionPersonArea extends StatelessWidget {
  const SelectionPersonArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: 240,
      decoration: BoxDecoration(
          image: DecorationImage(image: ExactAssetImage('assets/images/fundo-domvs.png'),fit: BoxFit.fill ),
        border: Border.all(
          width: 3
        ),
        color: Colors.black
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.lucas
           // '/lucas'
          );
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lucão - FlutterMan',
              style: TextStyle(
                color: Colors.white
              ),
              ),
              SizedBox(height: 40),
              Image.asset('assets/images/lucas.png', height: 180,),
              SizedBox(height: 30),
              Text(lucasDescription,
              textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
            ],
        ),
      ),
    );
  }
}
