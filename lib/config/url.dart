import 'package:flutter_dotenv/flutter_dotenv.dart';

// # dotenv for protect the base url
String baseUrlSchool = dotenv.get('baseUrlSchool');
String baseUrlOdoo = dotenv.get('baseUrlOdoo');

const String registerFirebase = 'api/register_firebasetoken';
const String login = 'api/login';
const String logout = 'api/logout';
const String getAnnouncementList = 'api/getannouncementlist';
const String getAnnouncementDetail = 'api/getannouncementdetail';
const String getAttendanceList = 'api/getattendance';
const String getProfile = 'api/get-details';
const String getFeedback = 'api/getfeedback';
const String addFeedback = 'api/addfeedback';
const String getFeedbackDetail = 'api/getfeedbackdetail';
const String getFeedbackCategory = 'api/getfeedbackcategory';
const String getNotificationList = 'api/getnotificationlist';
const String getNotificationDetail = 'api/getnotificationdetail';
const String addNotificationMarkAsReadAll = 'api/markasread';
const String addNotificationMarkAsReadOneByOne = 'api/marknotificationread';
const String getExamSchedule = 'api/getexamlist';
const String getCourseList = 'api/getcourselist';
const String getVideoCourseList = 'api/getelearninglist';
const String getTimetableList = 'api/gettimetablelist';
const String changePassword = 'api/change-password';
const String assignmentList = 'api/assignment_list';
const String assignmentDetail = 'api/assignment_detail';
const String assignmentText = 'api/student_submit_assignment';
const String assignmentFiles = 'api/student_add_attachment';
const String assignmentRemoveFile = 'api/student_remove_attachment';
const String version = 'api/getsetting/version';
const String getCalendarAttendance = 'api/getmonthattendance';
const String getHomeSlide = 'api/getsetting/homeslide';
const String getCollectionCard = 'api/collection_card';
const String getDateTime = 'api/getdatetime';
const String getAttendanceDetail = 'api/getattendancedetail';
const String getAbaList = 'api/get_abaqrcodelist';
const String updateVersion = 'api/update_cur_ver';
