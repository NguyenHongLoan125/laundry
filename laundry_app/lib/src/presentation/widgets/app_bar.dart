import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final VoidCallback returnArrow;


  const CustomAppBar({
    super.key,
    required this.title,
    required this.returnArrow,
  });

  @override
  Widget build(BuildContext context){
    return AppBar(
      centerTitle: true,
      title: Text(title,),
      leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios)
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
