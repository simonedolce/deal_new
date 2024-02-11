import 'package:deal/main.dart';
import 'package:deal/model/user.dart';
import 'package:deal/services/user-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-input-decorator.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

import '../util/routes.dart';
import '../util/strings.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}
List<ContentConfig> listContentConfig = [];
class _IntroductionState extends State<Introduction> {

  late final TextEditingController _passwordController;
  late final TextEditingController _confermaPasswordController;

  final UserService userService = UserService();

  final GlobalKey<FormState> _keyPasswordForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _confermaPasswordController = TextEditingController();

    listContentConfig.add(
      const ContentConfig(
        title: Strings.captOne,
        textAlignTitle: TextAlign.center,
        heightImage: 300,
        widthImage: 300,
        description: Strings.intrOne,
        textAlignDescription: TextAlign.left,
        pathImage: "images/deal.png",
        backgroundColor: CommonColors.background,
      )
    );
    listContentConfig.add(
        const ContentConfig(
          title: Strings.captTwo,
          textAlignTitle: TextAlign.center,
          heightImage: 300,
          widthImage: 300,
          description: Strings.intrTwo,
          textAlignDescription: TextAlign.left,
          backgroundColor: CommonColors.background,
        )
    );
    listContentConfig.add(
        const ContentConfig(
          title: Strings.captThree,
          textAlignTitle: TextAlign.center,
          heightImage: 300,
          widthImage: 300,
          description: Strings.intrThree,
          textAlignDescription: TextAlign.left,
          backgroundColor: CommonColors.background,
        )
    );
    listContentConfig.add(
          ContentConfig(
            title: Strings.captFour,
          centerWidget: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10
              ),
              child: Form(
                key: _keyPasswordForm,
                child: Wrap(
                  spacing: 20, // to apply margin in the main axis of the wrap
                  runSpacing: 20,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: DealInputDecorator(label: 'Password').dealInputDecorator,
                      validator: (value) => passwordValidator(value!, _confermaPasswordController),
                    ),
                    TextFormField(
                        controller: _confermaPasswordController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: DealInputDecorator(label: 'Conferma Password').dealInputDecorator
                    ),
                  ],
                ),
              )
            ),
          ),
          description: Strings.intrFour,
            textAlignDescription: TextAlign.left,
          backgroundColor: CommonColors.background,
        )
    );
  }

  void onDonePress() {
    if(_keyPasswordForm.currentState!.validate()){
      initiateApp();
    }

  }

  void initiateApp(){
    User user = User(password: _passwordController.text);

    userService.put(user);

    Navigator.popAndPushNamed(
      context,
      RoutesDef.dashBoard
    );
  }

  String? passwordValidator(String plainPassword, TextEditingController controllerConfirmPassword) {
    String confirmPassword = controllerConfirmPassword.text;

    if(plainPassword.isEmpty){
      return "Inserire una password";
    }

    if(plainPassword.length < 4){
      return "La password deve essere lunga almeno quattro caratteri";
    }

    if(plainPassword != confirmPassword){
      return "Le password non coincidono";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: onDonePress,
    );
  }
}
