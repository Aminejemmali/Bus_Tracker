import 'package:bustrackerapp/screens/AdminScreens/AddBus.dart';
import 'package:bustrackerapp/screens/AdminScreens/AddCircuit.dart';
import 'package:bustrackerapp/screens/AdminScreens/Buses.dart';
import 'package:bustrackerapp/screens/AdminScreens/EditBus.dart';
import 'package:bustrackerapp/screens/AdminScreens/circuit.dart';
import 'package:bustrackerapp/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:bustrackerapp/screens/AdminScreens/AddStation.dart';
import 'package:bustrackerapp/screens/AdminScreens/AdminHome.dart';
import 'package:bustrackerapp/screens/AdminScreens/BusPage.dart';
import 'package:bustrackerapp/screens/AdminScreens/EditStation.dart';
import 'package:bustrackerapp/screens/Forgetpassword.dart';
import 'package:bustrackerapp/screens/Login.dart';
import 'package:bustrackerapp/screens/Register.dart';
import 'package:bustrackerapp/screens/UserScreens/UserHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(Home());
}
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:AppBarTheme(
          backgroundColor: const Color(0xFFFFC25C),
        ),
        fontFamily: 'Abel',
        primaryColor: const Color(0xFFFFC25C),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
                color: Colors.black45,
            fontSize: 20),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
            backgroundColor: const Color(0xFFEFD8B2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor:  Colors.amber,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor:  Colors.amber,
          width: 250,
          elevation: 20,
        ),
        cardTheme: CardTheme(

          shadowColor: Colors.amber,
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          color: const Color(0xCFFCFC64),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.brown,

          subtitleTextStyle: TextStyle(
            fontSize: 18 ,
            color: Colors.brown,
          )
        ),
        dialogTheme: DialogTheme(
          backgroundColor:  const Color(0xFFFFC25C),

          contentTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color:Colors.brown
          ),
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          )
        ),
        snackBarTheme: SnackBarThemeData(
           backgroundColor:  const Color(0xFFFFC25C),
          contentTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,

          )
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 35.0, // Your desired font size
            color: Colors.black, // Your desired font color
          ),
          subtitle1: TextStyle(
            fontSize: 23.0, // Your desired font size
            color: Colors.black, // Your desired font color
          ),
          subtitle2: TextStyle(
            fontSize: 21.0, // Your desired font size
            color: Colors.black, // Your desired font color
          ),
        ),
      ),
      initialRoute: AdminHomeScreen.id,
      routes: {
        RegisterPage.id: (context) => const RegisterPage(),
        LoginPage.id: (context) => const LoginPage(),
        ForgotPassword.id: (context) => const ForgotPassword(),
        HomeScreen.id: (context) =>  HomeScreen(),
        AdminHomeScreen.id: (context) => AdminHomeScreen(),
        AddStationForm.id: (context) => AddStationForm(),
        BusPage.id: (context) {
          final int? stationId =
          ModalRoute.of(context)!.settings.arguments as int?;
          return BusPage(stationId: stationId);
        },
        EditStationForm.id: (context) {
          final int? stationId =
          ModalRoute.of(context)!.settings.arguments as int?;
          return EditStationForm(stationId: stationId);
        },
        BusesPage.id: (context) => BusesPage(),
        AddBus.id: (context) => AddBus(),
        EditBusForm.id: (context) {
          final int? busId =
          ModalRoute.of(context)!.settings.arguments as int?;
          return EditBusForm(busId: busId);
        },
        CircuitPage.id: (context) => CircuitPage(),
         AddCircuit.id: (context) => AddCircuit(),
      },
    );
  }
}
