import 'package:flutter/material.dart';

class LoginBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ClipPath(
      clipper: MyClipper(),
      child: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: AssetImage(
                "assets/images/mywaybg.jpg"), //!! need to change it to networkImagae & make it dynamic
            fit: BoxFit.scaleDown,
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20.0, bottom: 100.0),
        child: Column(
          children: <Widget>[
            Text(
              "",
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            Text(
              "",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(100.0, 50.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
