import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/blocs/login/login_bloc.dart';
import 'src/blocs/images/images_bloc.dart';
import 'src/repositories/picsum_repository.dart';
import 'src/ui/login_page.dart';
import 'src/ui/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final picsumRepo = PicsumRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
        BlocProvider<ImagesBloc>(create: (_) => ImagesBloc(repository: picsumRepo)),
      ],
      child: MaterialApp(
        title: 'Picsum App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat', // uses local font if provided
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginPage(),
          '/home': (_) => const HomePage(),
        },
      ),
    );
  }
}
