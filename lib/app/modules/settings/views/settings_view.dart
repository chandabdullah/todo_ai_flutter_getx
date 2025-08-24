import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ready_widgets/ready_widgets.dart';
import 'package:todo_ai/app/data/app_constants.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GetBuilder<SettingsController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
            centerTitle: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔍 Search Bar
              _searchBar(theme),

              const SizedBox(height: 24),
              _sectionTitle("ACCOUNT", theme),

              // 👤 Profile Card
              _settingsCard(theme, [
                ListTile(
                  leading: ReadyAvatar(
                    imageUrl: "https://avatars.githubusercontent.com/u/64844413?v=4",
                    size: 50,
                  ),


                  title: Text("Abdullah", style: theme.textTheme.bodyLarge),
                  subtitle: Text(
                    "abdullah@thenextlevelsoftware.com",
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.iconTheme.color?.withOpacity(0.6),
                  ),
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 12),

              // 🌙 Dark Mode Toggle
              _settingsCard(theme, [
                SwitchListTile(
                  title: Text("Dark Mode", style: theme.textTheme.bodyLarge),
                  secondary: Icon(
                    Icons.dark_mode,
                    color: theme.iconTheme.color?.withOpacity(0.8),
                  ),
                  value: controller.isDarkMode,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (val) => controller.toggleDarkMode(val),
                ),
              ]),

              const SizedBox(height: 24),
              _sectionTitle("PREFERENCES", theme),

              // ⚙️ Preferences
              _settingsCard(theme, [
                _settingsTile("Display", Icons.display_settings, theme, () {}),
                _divider(theme),
                _settingsTile(
                  "Notification",
                  Icons.notifications_outlined,
                  theme,
                  () {},
                ),
              ]),

              const SizedBox(height: 24),
              _sectionTitle("SUPPORT", theme),

              // 🛠 Support
              _settingsCard(theme, [
                _settingsTile(
                  "Privacy",
                  Icons.privacy_tip_outlined,
                  theme,
                  () {},
                ),
                _divider(theme),
                _settingsTile("Support", Icons.help_outline, theme, () {}),
              ]),

              const SizedBox(height: 24),

              // 🚪 Logout
              _settingsCard(theme, [
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // TODO: handle logout
                  },
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  // 🔎 Search Bar
  Widget _searchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: theme.iconTheme.color?.withAlpha((0.6 * 255).toInt()),
          ),
          const SizedBox(width: 8),
          Text(
            "Search settings",
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  // 📌 Section title
  Widget _sectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.hintColor,
        ),
      ),
    );
  }

  // 📦 Card wrapper
  Widget _settingsCard(ThemeData theme, List<Widget> children) {
    return Material(
      color: theme.cardColor,
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Column(children: children),
      ),
    );
  }

  // ⚙️ Tile
  Widget _settingsTile(
    String title,
    IconData icon,
    ThemeData theme,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: theme.iconTheme.color),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.iconTheme.color?.withOpacity(0.6),
      ),
      onTap: onTap,
    );
  }

  // ─ Divider
  Widget _divider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: theme.dividerColor.withOpacity(0.5),
    );
  }
}
