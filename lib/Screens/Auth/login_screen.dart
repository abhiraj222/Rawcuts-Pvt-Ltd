import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Providers/auth_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/location_provider.dart';

class SignInPage extends StatefulWidget {
  static const String id = 'sign_in_page';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _validPhoneNumber2 = false;

  var _phoneNumberController = TextEditingController();
  var _nameController = TextEditingController();
  String userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: auth.error == 'Invalid OTP' ? true : false,
                  child: Container(
                    child: Column(
                      children: [
                        PrimaryText(
                          text: '${auth.error}',
                          color: Colors.red,
                          size: 12,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                PrimaryText(
                  text: 'Register',
                  size: 25,
                  color: AppColors.primary,
                ),
                PrimaryText(
                  text: 'Enter Your Phone Number to Proceed',
                  size: 15,
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    focusColor: AppColors.primary,
                    prefixText: '+91',
                    labelText: '10 digit mobile number',
                  ),
                  autofocus: true,
                  maxLength: 10,
                  controller: _phoneNumberController,
                  onChanged: (value) {
                    if (value.length == 10) {
                      setState(() {
                        _validPhoneNumber2 = true;
                      });
                    } else {
                      setState(() {
                        _validPhoneNumber2 = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber2 ? false : true,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: () {
                            String number = '+91${_phoneNumberController.text}';

                            auth
                                .verifyPhone(
                                    context: context,
                                    number: number,
                                    latitude: locationData.latitude,
                                    longitude: locationData.longitude,
                                    address: locationData
                                        .selectedAddress.addressLine,
                                    name: userName)
                                .then((value) {
                              _phoneNumberController.clear();
                              _nameController.clear();
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: _validPhoneNumber2
                              ? Colors.deepOrange
                              : Colors.grey,
                          splashColor: AppColors.white,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: auth.loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white),
                                  )
                                : PrimaryText(
                                    text: _validPhoneNumber2
                                        ? 'PROCEED'
                                        : 'ENTER DETAILS',
                                    color: AppColors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
