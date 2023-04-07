// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

PreferredSizeWidget? CustomAppBar({
  Widget? title,
  List<Widget>? actions,
  double? height,
  String? bgImage,
  bool? light,
}) {
  return PreferredSize(
    preferredSize: Size(double.infinity, height ?? kToolbarHeight),
    child: AppBar(
      title: title!,
      actions: actions!,
      automaticallyImplyLeading: false,
      foregroundColor: light == true ? Colors.white : Colors.black,
      flexibleSpace: bgImage != null
          ? Image.network(
              bgImage,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(.35),
              colorBlendMode: BlendMode.multiply,
            )
          : FlexibleSpaceBar(),
    ),
  );
}

Widget DismissKeyboard(BuildContext context, {required Widget child}) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: child,
  );
}

Widget TButton(
  BuildContext context, {
  required String text,
  required void Function()? onPressed,
  bool? primary,
}) {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: checkPrimary(primary, context),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 30),
      side: BorderSide(color: Colors.black.withOpacity(.25)),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(color: Colors.black),
    ),
  );
}

checkPrimary(bool? primary, BuildContext context) {
  if (primary != null) {
    if (primary == true) {
      return Theme.of(context).primaryColor;
    }
  }
  return Theme.of(context).cardColor;
}
