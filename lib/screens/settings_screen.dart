import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _dailyReminder = true;
  bool _soundEnabled = false;
  bool _darkMode = false;
  bool _weekStartMonday = true;
  String _defaultView = 'All Tasks';
  String _defaultPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3949AB),
                            Color(0xFF5C6BC0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Text(
                              'AJ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Alex Johnson',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'alex.johnson@email.com',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Pro',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SettingsSection(
                    title: 'Notifications',
                    children: [
                      _ToggleSetting(
                        icon: Icons.notifications_rounded,
                        iconColor: AppTheme.primary,
                        title: 'Push Notifications',
                        subtitle: 'Get task reminders',
                        value: _notifications,
                        onChanged: (v) =>
                            setState(() => _notifications = v),
                      ),
                      _ToggleSetting(
                        icon: Icons.alarm_rounded,
                        iconColor: const Color(0xFFFF9800),
                        title: 'Daily Reminder',
                        subtitle: 'Remind at 9:00 AM every day',
                        value: _dailyReminder,
                        onChanged: (v) =>
                            setState(() => _dailyReminder = v),
                      ),
                      _ToggleSetting(
                        icon: Icons.volume_up_rounded,
                        iconColor: const Color(0xFF26C6DA),
                        title: 'Sound & Vibration',
                        subtitle: 'Notification sound',
                        value: _soundEnabled,
                        onChanged: (v) =>
                            setState(() => _soundEnabled = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SettingsSection(
                    title: 'Appearance',
                    children: [
                      _ToggleSetting(
                        icon: Icons.dark_mode_rounded,
                        iconColor: const Color(0xFF5C6BC0),
                        title: 'Dark Mode',
                        subtitle: 'Enable dark theme',
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                      ),
                      _SelectSetting(
                        icon: Icons.view_list_rounded,
                        iconColor: const Color(0xFFEC407A),
                        title: 'Default View',
                        selectedValue: _defaultView,
                        options: const [
                          'All Tasks',
                          'Today\'s Tasks',
                          'High Priority',
                        ],
                        onChanged: (v) =>
                            setState(() => _defaultView = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SettingsSection(
                    title: 'Tasks',
                    children: [
                      _SelectSetting(
                        icon: Icons.flag_rounded,
                        iconColor: AppTheme.priorityMedium,
                        title: 'Default Priority',
                        selectedValue: _defaultPriority,
                        options: const ['High', 'Medium', 'Low'],
                        onChanged: (v) =>
                            setState(() => _defaultPriority = v),
                      ),
                      _ToggleSetting(
                        icon: Icons.calendar_view_week_rounded,
                        iconColor: const Color(0xFF66BB6A),
                        title: 'Week starts on Monday',
                        subtitle: 'Calendar week start day',
                        value: _weekStartMonday,
                        onChanged: (v) =>
                            setState(() => _weekStartMonday = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SettingsSection(
                    title: 'About',
                    children: [
                      _TapSetting(
                        icon: Icons.info_rounded,
                        iconColor: AppTheme.primary,
                        title: 'About TaskNest',
                        subtitle: 'Version 1.0.0',
                        onTap: () {},
                      ),
                      _TapSetting(
                        icon: Icons.star_rounded,
                        iconColor: const Color(0xFFFFB300),
                        title: 'Rate the App',
                        subtitle: 'Share your feedback',
                        onTap: () {},
                      ),
                      _TapSetting(
                        icon: Icons.privacy_tip_rounded,
                        iconColor: AppTheme.textSecondary,
                        title: 'Privacy Policy',
                        subtitle: '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // App logo
                  Center(
                    child: Column(
                      children: [
                        const AppLogo(size: 36),
                        const SizedBox(height: 8),
                        Text(
                          '© 2025 TaskNest. All rights reserved.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppTheme.textSecondary
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 4),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            children: children
                .asMap()
                .entries
                .map((e) => Column(
                      children: [
                        e.value,
                        if (e.key < children.length - 1)
                          const Divider(
                            height: 1,
                            indent: 56,
                            color: AppTheme.divider,
                          ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSetting({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary)),
                if (subtitle.isNotEmpty)
                  Text(subtitle,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _SelectSetting extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _SelectSetting({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary)),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppTheme.cardBg,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(title,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                      const SizedBox(height: 12),
                      ...options.map(
                        (o) => ListTile(
                          title: Text(o,
                              style: const TextStyle(
                                  fontFamily: 'Poppins')),
                          trailing: o == selectedValue
                              ? const Icon(Icons.check_circle_rounded,
                                  color: AppTheme.primary)
                              : null,
                          onTap: () {
                            onChanged(o);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedValue,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: iconColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapSetting extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TapSetting({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
