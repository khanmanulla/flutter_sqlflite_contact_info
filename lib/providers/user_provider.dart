import 'package:flutter/material.dart';
import 'package:user_info/models/user_model.dart';
import 'package:user_info/services/database_service.dart';

class UserProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<UserModel> _users = [];
  bool _isLoading = false;
  int _pageNo = 0;
  int _limit = 10;
  int _totalPages = 0;
  UserModel? _selectedUser;
  String _searchQuery = '';

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  int get pageNo => _pageNo;
  UserModel? get selectedUser => _selectedUser;
  int get totalPages => _totalPages;

  UserProvider() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> userMaps;
      await getCount();
      if (_searchQuery.isEmpty) {
        userMaps = await _databaseService.getUsers(limit: _limit, offset: _pageNo * _limit);
      } else {
        userMaps = await _databaseService.searchUsers(_searchQuery);
      }
      _users = userMaps.map((map) => UserModel.fromJson(map)).toList();
      if (_users.isEmpty) {
        if (_pageNo > 0) {
          _pageNo--;
          await _loadUsers();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error getting user List: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getCount() async {
    int result = await _databaseService.getCount();
    int count = (result / _limit).ceil();
    _totalPages = count;
    return _totalPages;
  }

  Future<void> addUser(UserModel user) async {
    await _databaseService.insertUser(user.toJson());
    await _loadUsers();
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    await _databaseService.updateUser(user.id!, user.toJson());
    await _loadUsers();
    _selectedUser = user;
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    try {
      await _databaseService.deleteUser(id);
      await _loadUsers();
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading) return;

    if (_pageNo < _totalPages - 1) {
      _pageNo++;
      await _loadUsers();
    }
  }

  Future<void> loadPreviousPage() async {
    if (_isLoading) return;
    if (_pageNo > 0) {
      _pageNo--;
      await _loadUsers();
    }
  }

  Future<void> refreshUsers() async {
    await _loadUsers();
  }

  void selectUser(UserModel userModel) {
    _selectedUser = userModel;
    notifyListeners();
  }

  Future<void> searchUsers(String query) async {
    _searchQuery = query;
    _pageNo = 0;
    await _loadUsers();
  }
}
