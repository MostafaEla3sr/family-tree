// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:sulala/presentaion/home_screen/family_tree_screen.dart';
import 'data/cubit/family_tree_cubit.dart';

void main() {
  final dio = Dio(BaseOptions(
    baseUrl:
        'https://al-mousa.masool.net/api', // Replace with your actual base URL
  ));

  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Tree',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => FamilyTreeCubit(dio,
            'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5YzMyZDA3ZC1jMWQ1LTQ1N2ItOTMxYi1hMmEwY2YyYTAxMzciLCJqdGkiOiJjOGQ2N2E4MjQ3OTBhZGE5MjU5OWZiNDZlM2M5MGI5YWYwNTQ0YzI1ZTU2Mzc5MzM0ZDcwNWNlOTM2ODU2NDhiMjY5YTRiZDQ4ZWM1MDlhZSIsImlhdCI6MTcyNDIzOTAzMC4zODUxNzYsIm5iZiI6MTcyNDIzOTAzMC4zODUxOCwiZXhwIjoxNzU1Nzc1MDMwLjM4MDAyLCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.bz4TEzJrVHvUTtKPro-8M6ZmUdIng2-R-gHBJwLBm1zTh3svUsoGq99-iqJ2oFT-G8jzZDxX1QThKNjYbhcmuH1fe-fgjul2tABUd6ERXbk60eL3op6Y-Yjssmv4Se0PvqA4d1ueOsnjMFsti79DgSlEKUnjIkAKEy97wOarjm51daftLkgmNC_Nu4xL00z5NyO_l2mFJ_vM_shjIKCmvaiYM4pBrxrlaG1EWCsHY3KscmoJW634O5Do-E0SY1zIwTN75FFUzFWeuzu-wN06b6OHJZngLlc_QjNMChgK1oXmdQxONagBbPib-DEHKPMphBAL5MRvKFMYJCWeloetX6lhUiWHR0ylgtK2dhh0zQIAzlAvAohSpSMubGYCKwS4Wtnm7sliFfk4K8VEUOFRP-xIb7PQ4paTsFenZMVTsUqLHOK42LdxI44hpLcMZX6M-GBcdNCNocdA1ZCSNXF2hUYp7T-lpzcP9MqnRX0YWshfnKj4jiCeR82Q2M89CQCs-r69qxsMyg_DFsPgWutGuphTr1aYoiyksz6mOJx7KMCxfrZOtcYPhIFim7o2Jn-RE07EIXdF3PPlQdXqcR4v0n6SVzUilk2jZ3DSZOjNIsBCPEjNpfKRpT3SLSByy9zfK44X5v7zoO3lgsRHoGKbgkbNhYJi1830N-8Zkqnq0vY'),
        child: FamilyTreeScreen(),
      ),
    );
  }
}
