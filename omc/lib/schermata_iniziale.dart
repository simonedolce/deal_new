import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util/strings.dart';


class SchermataIniziale extends StatelessWidget {
  final PageController _pageController = PageController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> sendDataToJava(context) async {
    const platform = MethodChannel('com.example.omc/init');
    try {
      await platform.invokeMethod('insert_user', {
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text,
      });
      Navigator.pushNamed(context, '/homePage');
    } catch (e) {
    }
  }


  void _startApp(BuildContext context) {
    sendDataToJava(context);

  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          // Slide 1
          Container(
            margin: EdgeInsets.all(16.0), // Margini globali
            child: const Center(child: Text(Strings.slideUno)),
          ),
          // Slide 2
          Container(
            margin: EdgeInsets.all(16.0),
            child: const Center(child: Text(Strings.slideDue)),
          ),
          // Slide 3 con il bottone di avvio
          Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(Strings.slideTre),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      inputField('Password', obscureFlag: true, controller: passwordController),
                      inputField('Conferma Password', obscureFlag: true, validatorFunc: (value) => validateConfirmPassword(value, passwordController.text, passwordValidator),controller: confirmPasswordController),                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    if(_key.currentState!.validate()){
                      Navigator.pop(context);
                      _startApp(context);
                    }
                  },
                  child: Text('Conferma'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String? passwordValidator(String? formText){
  if(isNull(formText)){
    return 'Il valore è obbligatorio';
  }
  if(isTooShort(formText)){
    return 'Il valore deve essere lungo almeno 4 cifre';
  }
  return null;
}

String? validateConfirmPassword(String? value, String primaryValue, String? Function(String?)? validatorFunc) {
  if (validatorFunc != null) {
    if (value != primaryValue) {
      return 'Le password non corrispondono';
    }
    return validatorFunc(value);
  }
  return null;
}


bool isNull(String? formText){
  if(formText == null || formText.isEmpty) return true ;
  return false;
}

bool isTooShort(String? formText){
  if(formText!.length < 4) return true;
  return false;
}


Widget inputField(
    String label,
    {
      bool obscureFlag = false,
      String? Function(String?)? validatorFunc = passwordValidator,
      required TextEditingController controller
    }
    ) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
    ),

    keyboardType: TextInputType.numberWithOptions(decimal: false),
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ],

    obscureText: obscureFlag,
    validator: validatorFunc
  );
}

