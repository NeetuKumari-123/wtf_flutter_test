import 'package:get/get.dart';

import '../modules/role_selection/bindings/role_selection_binding.dart';
import '../modules/role_selection/views/role_selection_view.dart';
import '../modules/guru_onboarding/bindings/guru_onboarding_binding.dart';
import '../modules/guru_onboarding/views/guru_onboarding_view.dart';
import '../modules/guru_home/bindings/guru_home_binding.dart';
import '../modules/guru_home/views/guru_home_view.dart';
import '../modules/trainer_login/bindings/trainer_login_binding.dart';
import '../modules/trainer_login/views/trainer_login_view.dart';
import '../modules/trainer_home/bindings/trainer_home_binding.dart';
import '../modules/trainer_home/views/trainer_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROLE_SELECTION;

  static final routes = [
    GetPage(
      name: _Paths.ROLE_SELECTION,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),
    GetPage(
      name: _Paths.GURU_ONBOARDING,
      page: () => const GuruOnboardingView(),
      binding: GuruOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.GURU_HOME,
      page: () => const GuruHomeView(),
      binding: GuruHomeBinding(),
    ),
    GetPage(
      name: _Paths.TRAINER_LOGIN,
      page: () => const TrainerLoginView(),
      binding: TrainerLoginBinding(),
    ),
    GetPage(
      name: _Paths.TRAINER_HOME,
      page: () => const TrainerHomeView(),
      binding: TrainerHomeBinding(),
    ),
  ];
}
