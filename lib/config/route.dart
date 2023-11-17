import 'package:school/modules/announcement/screens/announcement_screen.dart';
import 'package:school/modules/gallary/screen/gallary_screen.dart';
import 'package:school/modules/gallary/screen/gallary_detile_screen.dart';
import 'package:school/modules/student_report/screens/student_report_screen.dart';
import 'package:school/screens/pages/pick_up_card_page.dart';
import 'package:school/screens/pages/teacher_homeworks_add.dart';

import '../modules/events/screen/events_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/login.dart';
import '../screens/pages/about_accreditation_page.dart';
import '../screens/pages/about_campuses_page.dart';
import '../screens/pages/about_core_beliefs_page.dart';
import '../screens/pages/about_introduction_page.dart';
import '../screens/pages/about_school_history_page.dart';
import '../screens/pages/about_vision_page.dart';
import '../screens/pages/attendance_calendar_page.dart';
import '../screens/pages/attendance_page.dart';
import '../modules/canteen/screen/canteen_screen.dart';
import '../screens/pages/class_results_page.dart';
import '../screens/pages/e_learning.dart';
import '../screens/pages/e_learning_subject_page.dart';
import '../screens/pages/exam_schedule_page.dart';
import '../screens/pages/feedback_page.dart';
import '../screens/pages/feedback_send.dart';
import '../screens/pages/homeworks_page.dart';
import '../screens/pages/homeworks_portal.dart';
import '../screens/pages/iwallet.dart';
import '../screens/pages/limit_purchase.dart';
import '../screens/pages/notification_page.dart';
import '../screens/pages/pos_history.dart';
import '../screens/pages/pos_page.dart';
import '../screens/pages/teacher_homeworks.dart';
import '../screens/pages/terms_conditions.dart';
import '../screens/pages/timetable_page.dart';
import '../screens/pages/top_up.dart';
import '../screens/profile_screen.dart';

var route02 = {
  'dashboard': (context) => DashboardScreen(),
  'announcement': (context) => AnnouncementScreen(),
  'attendance': (context) => AttendancePage(),
  'timetable': (context) => TimetablePage(),
  'exam_schedule': (context) => ExamSchedulePage(),
  'homeworks': (context) => HomeworksPage(),
  'teacher_homeworks': (context) => TeacherHomeworks(),
  'class_results': (context) => ClassResultsPage(),
  'feedback': (context) => FeedbackPage(),
  'feedback_send': (context) => FeedbackSendPage(
        sortFilter: [],
      ),
  'e_learning_subject': (context) => ELearningSubjectPage(),
  'introduction': (context) => IntroductionPage(),
  'school_history': (context) => SchoolHistoryPage(),
  'vision': (context) => VisionPage(),
  'core_beliefs': (context) => CoreBeliefsPage(),
  'accreditation': (context) => AccreditationPage(),
  'campuses': (context) => CampusesPage(),
  'login': (context) => LoginScreen(),
  'profile_screen': (context) => ProfileScreen(),
  'notification': (context) => NotificationPage(),
  'e_learning': (context) => ELearningPage(),
  'homeworks_portal': (context) => HomeworksPortal(),
  'teacher_homeworks_add': (context) => TeacherHomeworksAdd(),
  'attendance_calendar': (context) => AttendanceCalendar(),
  'pick_up_card': (context) => ScanScreen(),
  'canteen': (context) => CanteenScreen(),
  'pos_order': (context) => PosOrder(),
  'pos_history': (context) => PosHistory(),
  'top_up': (context) => TopUp(),
  'events': (context) => EventScreen(),
  'gallary': (context) => GallaryScreen(),
  'gallary_datail': (context) => GallaryDetail(),
  'i_wallet': (context) => IWallet(
        index: 0,
      ),
  'limit_purchase': (context) => LimitPurchase(),
  'terms_conditions': (context) => TermsAndConditions(),
  'student_report': (context) => StudentReportScreen()
};
