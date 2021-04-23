import 'package:flutter/material.dart';
import '../User.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

TextStyle _style() {
  return TextStyle(fontWeight: FontWeight.bold);
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Scaffold(
        appBar: CustomAppBar(user),
        body: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Name"),
              SizedBox(
                height: 4,
              ),
              Text(
                user.firstName + " " + user.lastName,
                //user.firstName + " " + user.lastName,
                style: _style(),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Email",
                style: _style(),
              ),
              SizedBox(
                height: 4,
              ),
              Text(user.email),
              SizedBox(
                height: 16,
              ),
              Text(
                "University",
                style: _style(),
              ),
              SizedBox(
                height: 4,
              ),
              Text(user.university),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(top: 40),
                child: SpringButton(
                  SpringButtonType.OnlyScale,
                  Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 0),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Colors.deepPurpleAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text(
                        "  Logout  ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  //scaleCoefficient: 1,
                  onTap: () {
                    user.logOut();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 320);

  final User user;

  CustomAppBar(this.user);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(top: statusBarHeight + 20),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(("assets/images/background.jpg")),
              fit: BoxFit.fitWidth,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
            ),
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]),
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage("https://expertphotography.com/wp-content/uploads/2020/08/social-media-profile-photos.jpg"),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 20,
                                offset: Offset(0, 3),
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        user.firstName + " " + user.lastName,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height - 70);
    p.lineTo(size.width, size.height);

    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
