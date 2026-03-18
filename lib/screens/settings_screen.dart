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
  bool _darkMode = false;
  bool _reminders = true;
  String _defaultPriority = 'Medium';
  String _sortBy = 'Due Date';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),

            // Profile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
                    child: const Center(child: Text('AJ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alex Johnson', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('alex@taskmanager.io', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.edit_rounded, color: Colors.white.withOpacity(0.6), size: 20),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App branding
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16), boxShadow: AppTheme.cardShadow),
              child: Row(
                children: [
                  const AppLogo(size: 40, showText: true),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                    child: const Text('v1.0', style: TextStyle(color: AppTheme.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notifications
            _SectionHeader(label: 'Notifications'),
            const SizedBox(height: 12),
            _SettingsCard(children: [
              _ToggleSetting(icon: Icons.notifications_rounded, label: 'Push Notifications', value: _notifications, onChanged: (v) => setState(() => _notifications = v)),
              const Divider(height: 1),
              _ToggleSetting(icon: Icons.alarm_rounded, label: 'Task Reminders', value: _reminders, onChanged: (v) => setState(() => _reminders = v)),
            ]),
            const SizedBox(height: 24),

            // Preferences
            _SectionHeader(label: 'Preferences'),
            const SizedBox(height: 12),
            _SettingsCard(children: [
              _ToggleSetting(icon: Icons.dark_mode_rounded, label: 'Dark Mode', value: _darkMode, onChanged: (v) => setState(() => _darkMode = v)),
              const Divider(height: 1),
              _SelectSetting(
                icon: Icons.flag_rounded,
                label: 'Default Priority',
                value: _defaultPriority,
                options: const ['High', 'Medium', 'Low'],
                onChanged: (v) => setState(() => _defaultPriority = v),
              ),
              const Divider(height: 1),
              _SelectSetting(
                icon: Icons.sort_rounded,
                label: 'Sort Tasks By',
                value: _sortBy,
                options: const ['Due Date', 'Priority', 'Category', 'Created'],
                onChanged: (v) => setState(() => _sortBy = v),
              ),
            ]),
            const SizedBox(height: 24),

            // Data
            _SectionHeader(label: 'Data'),
            const SizedBox(height: 12),
            _SettingsCard(children: [
              _TapSetting(icon: Icons.cloud_upload_rounded, label: 'Backup Tasks', onTap: () {}),
              const Divider(height: 1),
              _TapSetting(icon: Icons.cloud_download_rounded, label: 'Restore Tasks', onTap: () {}),
              const Divider(height: 1),
              _TapSetting(icon: Icons.delete_sweep_rounded, label: 'Clear Completed', onTap: () {}, isDanger: true),
            ]),
            const SizedBox(height: 24),

            // About
            _SectionHeader(label: 'About'),
            const SizedBox(height: 12),
            _SettingsCard(children: [
              _InfoRow(label: 'Version', value: '1.0.0'),
              const Divider(height: 1),
              _InfoRow(label: 'Build', value: '2024.1'),
              const Divider(height: 1),
              _TapSetting(icon: Icons.info_outline_rounded, label: 'Licenses', onTap: () {}),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600));
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(14), boxShadow: AppTheme.cardShadow),
      child: Column(children: children),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleSetting({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14))),
          Switch(value: value, onChanged: onChanged, activeColor: AppTheme.primary),
        ],
      ),
    );
  }
}

class _SelectSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  const _SelectSetting({required this.icon, required this.label, required this.value, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...options.map((o) => ListTile(
                  title: Text(o),
                  trailing: o == value ? const Icon(Icons.check_rounded, color: AppTheme.primary) : null,
                  onTap: () { onChanged(o); Navigator.pop(context); },
                )),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14))),
            Text(value, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _TapSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;
  const _TapSetting({required this.icon, required this.label, required this.onTap, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: isDanger ? AppTheme.danger : AppTheme.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(color: isDanger ? AppTheme.danger : AppTheme.textPrimary, fontSize: 14))),
            Icon(Icons.chevron_right_rounded, color: isDanger ? AppTheme.danger.withOpacity(0.5) : AppTheme.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
