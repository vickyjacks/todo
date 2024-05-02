import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class DrawerPage extends StatefulWidget {

  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }
  int _selectedDestination = 0;

  @override
  Widget build(BuildContext context) {
    //  authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      backgroundColor: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn?  Colors.grey.shade900:Colors.white.withOpacity(0.9000000023841858),
     // backgroundColor: Colors.white.withOpacity(0.9000000023841858),
      child: SafeArea(
        child: ListView(
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, icon: const Icon(Icons.close)),
                )),
           Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, color: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn ? Colors.black :Colors.grey,size: 80,),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ) ,
            const SizedBox(
              height: 25,
            ),

            ///@@@@@@
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: InkWell(
                onTap: () {
                  selectDestination(0);
                },
                child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: (_selectedDestination == 0 && Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn==true)
                          ? Colors.black
                          :Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:   Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Provider.of<ThemeNotifier>(context, listen: false).isDarkModeOn ? Colors.white:Color(0xFF7B7B7B),
                              fontSize: 14.10,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        )
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
}
