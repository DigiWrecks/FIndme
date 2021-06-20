import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../email.dart';

class RegisterWebCompany extends StatefulWidget {
  final PageController controller;

  const RegisterWebCompany({Key key, this.controller}) : super(key: key);
  @override
  _RegisterWebCompanyState createState() => _RegisterWebCompanyState();
}

class _RegisterWebCompanyState extends State<RegisterWebCompany> {
  TextEditingController businessName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cvr = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  signUp() async {
    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
    if(businessName.text.isNotEmpty && phone.text.isNotEmpty && email.text.isNotEmpty &&password.text.isNotEmpty && cvr.text.isNotEmpty && username.text.isNotEmpty){
      pd.show(
          message: 'Please wait',
          type: SimpleFontelicoProgressDialogType.custom,
          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
      );
      ///auth
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text,
            password: password.text
        );

        ///save details
        await FirebaseFirestore.instance.collection('companies').doc(email.text).set({
          'name': businessName.text,
          'email': email.text,
          'phone': phone.text,
          'cvr': cvr.text,
          'username': username.text,
          'status': 'approved',
          'playerID': ''
        });
        //todo:change approved to pending

        ///send notification
        // await Email.sendEmail('Findmee has received your details, please wait to be approved from team', 'Welcome to Findmee', to: email.text);
        widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          pd.hide();
          MessageDialog.show(
            context: context,
            text: 'The password provided is too weak',
          );
        } else if (e.code == 'email-already-in-use') {
          pd.hide();
          MessageDialog.show(
            context: context,
            text: 'The account already exists for that email',
          );
        }
      } catch (e) {
        pd.hide();
        MessageDialog.show(
          context: context,
          text: 'Something went wrong',
        );
      }
    }
    else{
      pd.hide();
      MessageDialog.show(
          context: context,
          text: 'Please fill all fields',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(width*0.075),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(30),),
            CustomText(text: 'Tilmeld dig nu',size: ScreenUtil().setSp(80),align: TextAlign.start,color: Color(0xff52575D),),
            SizedBox(height: width*0.03,),
            InputField(hint: 'Fimanavn',controller: businessName,),
            InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
            InputField(hint: 'Mobiltelefon',type: TextInputType.phone,controller: phone),
            InputField(hint: 'CVR',controller: cvr,),
            InputField(hint: 'Brugernavn',controller: username,),
            InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
            SizedBox(height: ScreenUtil().setHeight(40),),

            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
              child: Button(
                text: 'Tilmeld',
                onclick: ()=>signUp(),
                padding: width*0.01,
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: (){
                      widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    },
                    child: CustomText(text: "Er du allerede tilmeldt? Log ind her",color: Colors.black, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
