import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kevit_prac/screens/auth/auth_provider.dart';
import '../../utils/dimensions.dart';
import '../../utils/my_color.dart';
import '../../utils/style.dart';
import '../../widget/default_text.dart';
import '../feed/feed.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColor.primaryColor, MyColor.secondryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultText(
                      text:"Welcome Back 👋",
                      textStyle: outfitifBoldText,
                      fontSize: Dimensions.fontOverExtraLarge,
                      textColor: MyColor.colorBlack,
                    ),
                    const SizedBox(height: 8),
                    DefaultText(
                      text:"Login to continue",
                      textStyle: outfitifRegularText,
                      fontSize: Dimensions.fontMediumLarge,
                      textColor: MyColor.uniqueColor,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Enter your username',
                        hintStyle: outfitifRegularText.copyWith(
                          color: MyColor.uniqueColor,
                          fontSize: Dimensions.fontLarge,
                        ),
                        labelStyle: outfitifRegularText.copyWith(
                          color: MyColor.colorBlack,
                          fontSize: Dimensions.fontLarge,
                        ),
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: MyColor.uniqueColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColor.primaryColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final username = _controller.text.trim();
                          if (username.isNotEmpty) {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('login_name', username);
                            ref.read(authProvider.notifier).state = username;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => FeedScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a username'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: MyColor.primaryColor,
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
