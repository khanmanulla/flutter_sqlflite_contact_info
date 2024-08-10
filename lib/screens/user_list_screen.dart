import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_info/common/helpers/snackbar_helper.dart';
import 'package:user_info/common/styles/color_palate.dart';
import 'package:user_info/common/styles/font_size.dart';
import 'package:user_info/common/styles/form_styles.dart';
import 'package:user_info/common/utils/form_formatter.dart';
import 'package:user_info/models/user_model.dart';
import 'package:user_info/providers/user_provider.dart';
import 'package:user_info/screens/user_detail_screen.dart';
import 'package:user_info/screens/user_form_screen.dart';
import 'package:user_info/widgets/show_custom_alert_dialog.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text;
    Provider.of<UserProvider>(context, listen: false).searchUsers(searchQuery);
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isSearching = false;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? confirmed = await showCustomAlertDialog(
          context,
          title: 'Please confirm',
          message: 'Do you want to exit the app?',
          confirmButtonText: 'Yes',
          cancelButtonText: 'No',
          confirmButtonColor: Colors.blue,
          cancelButtonColor: Colors.grey,
        );
        return confirmed ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          // title: Text('Contact List', style: FormStyles.black20TextStyles()),
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Search ...', border: InputBorder.none),
                )
              : Text('Contact List', style: FormStyles.black20TextStyles()),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
            if (_isSearching)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              ),
          ],
        ),
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userProvider.users.isEmpty) {
              return Center(child: Text("No Contacts Available", style: FormStyles.black20TextStyles()));
            }
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              strokeWidth: 4.0,
              onRefresh: () async {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                return userProvider.refreshUsers();
              },
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(color: ColorPalate.lightGrey);
                  },
                  itemCount: userProvider.users.length,
                  itemBuilder: (context, index) {
                    if (index >= userProvider.users.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final user = userProvider.users[index];
                    print(user.dob);
                    return InkWell(
                        onTap: () {
                          userProvider.selectUser(user);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailScreen()));
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                  backgroundColor: ColorPalate.getRandomColor(),
                                  radius: 25,
                                  child: Text("${user.firstName?[0].toUpperCase()} ${user.lastName?[0].toUpperCase()}", style: FormStyles.white20TextStyle())),
                              title: Text("${user.firstName}  ${user.lastName}", style: FormStyles.black16TextStyles()),
                              subtitle: Text("${user.mobile}", style: FormStyles.grey14TextStyle()),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await showCustomAlertDialog(
                                      context,
                                      title: 'Confirm Delete',
                                      message: 'Are you sure you want to delete ${user.firstName} ${user.lastName}?',
                                      confirmButtonText: 'Yes',
                                      cancelButtonText: 'No',
                                      confirmButtonColor: ColorPalate.red,
                                      cancelButtonColor: ColorPalate.grey,
                                    );

                                    setState(() {
                                      userProvider.deleteUser(user.id ?? 0);
                                      SnackBarHelper.showSuccessSnackBar(context, "${user.firstName} ${user.lastName} removed");
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: ColorPalate.red)),
                            )));
                  }),
            );
          },
        ),
        bottomNavigationBar: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            // print("from screen----> ${userProvider.totalPages}");
            if (userProvider.users.isEmpty || userProvider.isLoading || userProvider.totalPages == 1) {
              return const SizedBox.shrink();
            }
            return BottomAppBar(
              notchMargin: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if ((userProvider.pageNo == 0) || userProvider.isLoading) {
                        return;
                      } else {
                        _previousPage(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: (userProvider.pageNo == 0) || userProvider.isLoading ? ColorPalate.grey : null,
                      backgroundColor: userProvider.isLoading ? ColorPalate.lightGrey : null,
                    ),
                    child: const Text('Previous'),
                  ),
                  Text('Page ${userProvider.pageNo + 1} of ${userProvider.totalPages}', style: const TextStyle(fontSize: FontSize.medium)),
                  ElevatedButton(
                    onPressed: () {
                      if ((userProvider.pageNo + 1 == userProvider.totalPages) || userProvider.isLoading) {
                        return;
                      } else {}
                      _nextPage(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: (userProvider.pageNo + 1 == userProvider.totalPages) || userProvider.isLoading ? ColorPalate.grey : null,
                      backgroundColor: (userProvider.pageNo + 1 == userProvider.totalPages) || userProvider.isLoading ? ColorPalate.lightGrey : null,
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserFormScreen()),
              );
            }),
      ),
    );
  }

  void _previousPage(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadPreviousPage();
  }

  void _nextPage(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadNextPage();
  }
}
