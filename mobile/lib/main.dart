import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/pet_controller.dart';
import 'screens/login_screen.dart';
import 'screens/pet_list_screen.dart';
import 'screens/add_pet_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Doggzi Pet App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: InitialBinding(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/pets', page: () => const PetListScreen()),
        GetPage(name: '/add-pet', page: () => const AddPetScreen()),
      ],
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(PetController());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 80, color: Colors.blue),
                SizedBox(height: 24),
                Text(
                  'Doggzi Pet App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 24),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else {
          // Navigate based on login status
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (authController.isLoggedIn.value) {
              Get.offAllNamed('/pets');
            } else {
              Get.offAllNamed('/login');
            }
          });

          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
