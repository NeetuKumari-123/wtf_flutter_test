import 'package:get/get.dart';
import 'package:wtf_flutter_test/app/modules/video_call/views/pre_join_screen.dart';

import '../modules/call_request/bindings/call_request_binding.dart';
import '../modules/call_request/views/call_request_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chat_list/bindings/chat_list_binding.dart';
import '../modules/chat_list/views/chat_list_view.dart';
import '../modules/guru_home/bindings/guru_home_binding.dart';
import '../modules/guru_home/views/guru_home_view.dart';
import '../modules/guru_onboarding/bindings/guru_onboarding_binding.dart';
import '../modules/guru_onboarding/views/guru_onboarding_view.dart';
import '../modules/role_selection/bindings/role_selection_binding.dart';
import '../modules/role_selection/views/role_selection_view.dart';
import '../modules/session_logs/bindings/session_logs_binding.dart';
import '../modules/session_logs/views/session_logs_view.dart';
import '../modules/trainer_home/bindings/trainer_home_binding.dart';
import '../modules/trainer_home/views/trainer_home_view.dart';
import '../modules/trainer_login/bindings/trainer_login_binding.dart';
import '../modules/trainer_login/views/trainer_login_view.dart';
import '../modules/trainer_requests/bindings/trainer_requests_binding.dart';
import '../modules/trainer_requests/views/trainer_requests_view.dart';
import '../modules/video_call/bindings/video_call_binding.dart';
import '../modules/video_call/controllers/video_call_controller.dart';
import '../modules/video_call/views/video_call_view.dart';

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
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_LIST,
      page: () => const ChatListView(),
      binding: ChatListBinding(),
    ),
    GetPage(
      name: _Paths.CALL_REQUEST,
      page: () => const CallRequestView(),
      binding: CallRequestBinding(),
    ),
    GetPage(
      name: _Paths.TRAINER_REQUESTS,
      page: () => const TrainerRequestsView(),
      binding: TrainerRequestsBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_CALL,
      page: () => const VideoCallView(),
      binding: VideoCallBinding(),
    ),
    GetPage(
      name: Routes.PRE_JOIN,
      page: () => const PreJoinView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VideoCallController>(() => VideoCallController());
      }),
    ),
    GetPage(
      name: _Paths.SESSION_LOGS,
      page: () => const SessionLogsView(),
      binding: SessionLogsBinding(),
    ),
  ];
}
