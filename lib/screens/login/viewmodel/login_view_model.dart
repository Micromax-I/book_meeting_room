import '../../../core/base/base_viewmodel.dart';
import '../../../model/employee_response.dart';
import '../../../model/login_saved_data.dart';
import '../../../model/version_response.dart';
import '../../../repository/meeting_repository.dart';
import '../../../util/preference_helper.dart';

class LoginViewModel extends BaseViewModel {
  final MeetingRepository repository;
  final PreferenceHelper prefs;

  LoginViewModel({required this.repository, required this.prefs});

  EmployeeResponse? _employee;

  EmployeeResponse? get employee => _employee;

  bool get isLoading => state == ViewState.loading;

  VersionResponse? _versionResponse;

  VersionResponse? get versionResponse => _versionResponse;

  Future<bool> authenticateUser({
    required String userName,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      state = ViewState.loading;
      errorMessage = '';
      notifyListeners();

      final response = await repository.authenticateUser(
        userName: userName,
        password: password,
      );

      _employee = response;

      if (response?.Ecode == null) {
        setError('User id or password invalid');
        return false;
      }

      await _saveLoginData(
        userName: userName,
        password: password,
        rememberMe: rememberMe,
        response: response!,
      );

      state = ViewState.success;

      notifyListeners();

      return true;
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  Future<void> _saveLoginData({
    required String userName,
    required String password,
    required bool rememberMe,
    required EmployeeResponse response,
  }) async {
    await prefs.setString('password_check', password);

    if (rememberMe) {
      await prefs.setBool('rememberMe', true);

      await prefs.setString('userName', userName);

      await prefs.setString('password', password);
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('userName');
      await prefs.remove('password');
    }

    await prefs.setString('userName', userName);

    await prefs.setString('userId', userName);

    await prefs.setString('name', response.Name ?? '');

    await prefs.setInt('CabAccess', response.Cabaccess ?? 0);
  }

  LoginSavedData loadSavedData()  {
    final remember =  prefs.getBool('rememberMe') ?? false;

    if (!remember) {
      return LoginSavedData(rememberMe: false, userName: '', password: '');
    }

    final userName =  prefs.getString('userName') ?? '';

    final password =  prefs.getString('password') ?? '';

    return LoginSavedData(
      rememberMe: true,
      userName: userName,
      password: password,
    );
  }

  void resetState() {
    state = ViewState.idle;
    errorMessage = '';
    notifyListeners();
  }

  Future<void> checkVersion(String versionCode, String versionName) async {
    try {
      final response = await repository.checkVersion(
        versionCode: versionCode,
        versionName: versionName,
      );

      _versionResponse = response;
      notifyListeners();
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
