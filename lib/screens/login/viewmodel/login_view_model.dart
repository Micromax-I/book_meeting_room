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

  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  EmployeeResponse? _employee;

  EmployeeResponse? get employee => _employee;

  bool get isLoading => _state == ViewState.loading;

  VersionResponse? _versionResponse;

  VersionResponse? get versionResponse => _versionResponse;

  Future<bool> authenticateUser({
    required String userName,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      _state = ViewState.loading;
      _errorMessage = '';
      notifyListeners();

      final response = await repository.authenticateUser(
        userName: userName,
        password: password,
      );

      _employee = response;

      if (response?.Ecode == null) {
        _state = ViewState.error;
        _errorMessage = 'User id or password invalid';

        notifyListeners();

        return false;
      }

      await _saveLoginData(
        userName: userName,
        password: password,
        rememberMe: rememberMe,
        response: response!,
      );

      _state = ViewState.success;

      notifyListeners();

      return true;
    } catch (e) {
      _state = ViewState.error;

      _errorMessage = e.toString().replaceFirst('Exception: ', '');

      notifyListeners();

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

  Future<LoginSavedData> loadSavedData() async {
    final remember = await prefs.getBool('rememberMe') ?? false;

    if (!remember) {
      return LoginSavedData(rememberMe: false, userName: '', password: '');
    }

    final userName = await prefs.getString('userName') ?? '';

    final password = await prefs.getString('password') ?? '';

    return LoginSavedData(
      rememberMe: true,
      userName: userName,
      password: password,
    );
  }

  void resetState() {
    _state = ViewState.idle;
    _errorMessage = '';

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
      _errorMessage = e.toString().replaceFirst('Exception: ', '');

      _state = ViewState.error;

      notifyListeners();
    }
  }
}
