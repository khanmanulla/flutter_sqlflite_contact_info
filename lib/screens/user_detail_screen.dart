import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_info/common/styles/color_palate.dart';
import 'package:user_info/common/utils/form_formatter.dart';
import 'package:user_info/common/styles/form_styles.dart';
import 'package:user_info/providers/user_provider.dart';
import 'package:user_info/screens/user_form_screen.dart';

class UserDetailScreen extends StatefulWidget {
  // final UserModel user;

  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details", style: FormStyles.black20TextStyles()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserFormScreen(existingUser: userProvider.selectedUser)));
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.selectedUser;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorPalate.getRandomColor(),
                      radius: 50,
                      child: Text("${user?.firstName?[0].toUpperCase()} ${user?.lastName?[0].toUpperCase()}",
                          style: FormStyles.black32TextStyles()),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${user?.firstName}  ${user?.lastName}", style: FormStyles.black20TextStyles()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                Text('Contact Information', style: FormStyles.black20TextStyles()),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(user?.mobile ?? 'N/A'),
                ),
                Text('Date of Birth', style: FormStyles.black20TextStyles()),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(FormFormatter.formatDate(user?.dob ?? '')),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Call'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Message'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
