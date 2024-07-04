import 'package:flutter/material.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/screens/login_display.dart';
import 'package:trakify/screens/sign_in.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/text.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  IntroState createState() => IntroState();
}

class IntroState extends State<Intro> {
  
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: MyColor.bluePrimary,
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 100,),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPageContent(context, 'assets/images/intro_1.png', "Get clarity, greater insights of your sites"),
                _buildPageContent(context, 'assets/images/intro_2.jpg', "Real-time site updates at your fingertips"),
                _buildPageContent(context, 'assets/images/intro_3.jpg', "Streamline your sales by adding your team members over here"),
              ],
            ),
          ),
          _buildPageIndicator(),
          const SizedBox(height: 80,),
          AppearAnimation( delay: 1200,
            child: ElevatedButton(
              style: ButtonStyle(
                shadowColor: WidgetStateProperty.all(Colors.blue),
                surfaceTintColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.white),
                elevation: WidgetStateProperty.all(4.0),
              ),
              onPressed: () {Navigator.push(context, CustomPageRoute(nextPage: const LoginDisplayScreen(), direction: 0,),);},
              child: const MySimpleText(text: 'GET STARTED !', size: 20, color: Colors.blue,),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, String imagePath, String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeInAnimation(delay: 1, direction: 'down',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imagePath,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.75,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 50,),
              Padding(padding: const EdgeInsets.all(8.0),
                child: FadeInAnimation(delay: 0.5, direction: 'up',
                    child: MySimpleText(text: text, size: 20, color: Colors.white,)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: _currentPage == index ? 18 : 8, height: _currentPage == index ? 8 : 8,
          decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(200),
            color: _currentPage == index ? MyColor.white : MyColor.white.withOpacity(0.6),
          ),
        );
      }),
    );
  }
}