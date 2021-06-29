import 'dart:convert';

import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:findmee/widgets/toggle-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatesWebWorker extends StatefulWidget {
  final PageController controller;

  const DatesWebWorker({Key key, this.controller}) : super(key: key);

  @override
  _DatesWebWorkerState createState() => _DatesWebWorkerState();
}

class _DatesWebWorkerState extends State<DatesWebWorker> {
  int selectedDay = 1;
  List x = [
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(width*0.075),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(30),),
            CustomText(text: 'Datoer.',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
            SizedBox(height: ScreenUtil().setHeight(50),),
            CustomText(text: 'Vælg gerne dato/datoer og tider når du vil arbejde',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
            SizedBox(height: width*0.03,),

            ///dropdown
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:  Color(0xfff5f5f5),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
                  child: Center(
                    child: DropdownButton(
                      underline: Divider(color:  Color(0xfff5f5f5),height: 0,thickness: 0,),
                      dropdownColor: Color(0xfff5f5f5),
                      iconEnabledColor: Colors.black,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(child: CustomText(text: 'Mandag',font: 'GoogleSans',),value: 1,),
                        DropdownMenuItem(child: CustomText(text: 'Tirsdag',font: 'GoogleSans',),value: 2,),
                        DropdownMenuItem(child: CustomText(text: 'Onsdag',font: 'GoogleSans',),value: 3,),
                        DropdownMenuItem(child: CustomText(text: 'Torsdag',font: 'GoogleSans',),value: 4,),
                        DropdownMenuItem(child: CustomText(text: 'Fredag',font: 'GoogleSans',),value: 5,),
                        DropdownMenuItem(child: CustomText(text: 'Lørdag',font: 'GoogleSans',),value: 6,),
                        DropdownMenuItem(child: CustomText(text: 'Søndag',font: 'GoogleSans',),value: 7,),
                      ],
                      onChanged:(newValue){
                        setState(() {
                          selectedDay = newValue;
                        });
                      },
                      value: selectedDay,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(180),),


            ///shifts
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).primaryColor,width: 2)
              ),
              child: Column(
                children: [
                  ///header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                        color: Theme.of(context).primaryColor
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                      child: CustomText(text: 'Muligheder',color: Colors.white,align: TextAlign.start,size: ScreenUtil().setSp(45),),
                    ),
                  ),

                  ///body
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(50)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ToggleButton(
                                  text: 'Morgen',
                                  onclick: (){
                                    setState(() {
                                      x[selectedDay-1]['mor'] = !x[selectedDay-1]['mor'];
                                    });
                                  },
                                  isSelected: x[selectedDay-1]['mor'],
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setHeight(40),),
                              Expanded(
                                child: ToggleButton(
                                  text: 'Eftermiddag',
                                  onclick: (){
                                    setState(() {
                                      x[selectedDay-1]['eve'] = !x[selectedDay-1]['eve'];
                                    });
                                  },
                                  isSelected: x[selectedDay-1]['eve'],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40),),
                          Center(
                            child: ToggleButton(
                              text: 'Nat',
                              onclick: (){
                                setState(() {
                                  x[selectedDay-1]['nig'] = !x[selectedDay-1]['nig'];
                                });
                              },
                              isSelected: x[selectedDay-1]['nig'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(250),),


            SizedBox(height: ScreenUtil().setHeight(120),),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
              child: Button(text: 'Næste',padding: width*0.01,onclick: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Map data = jsonDecode(prefs.getString('data'));

                List datesAndShifts = [];
                for(int i=0;i<x.length;i++){
                  if(x[i]['mor']){
                    datesAndShifts.add('${i+1}mor');
                  }
                  if(x[i]['eve']){
                    datesAndShifts.add('${i+1}eve');
                  }
                  if(x[i]['nig']){
                    datesAndShifts.add('${i+1}nig');
                  }
                }

                data['datesAndShifts'] = datesAndShifts;
                prefs.setString('data', jsonEncode(data));
                widget.controller.animateToPage(5,curve: Curves.ease,duration: Duration(milliseconds: 200));
              }
              ),
            )

          ],
        ),
      ),
    );
  }
}