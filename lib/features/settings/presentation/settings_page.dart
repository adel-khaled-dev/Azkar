import 'package:azkar/core/constants/app_constants.dart';
import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/features/prayer_times/data/prayer_repository.dart';
import 'package:azkar/features/prayer_times/logic/prayer_cubit.dart';
import 'package:azkar/features/settings/logic/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse(AppConstants.developerWhatsapp);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        final telUri = Uri.parse('tel:${AppConstants.developerPhone}');
        await launchUrl(telUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذّر فتح تطبيق واتساب مباشرة')),
        );
      }
    }
  }

  static const _apkChannel = MethodChannel('com.adelkhalid.azkar/app_info');

  /// مشاركة ملف APK مباشرة عبر واتساب
  Future<void> _shareApkViaWhatsApp(BuildContext context) async {
    try {
      await _apkChannel.invokeMethod('shareApkViaWhatsApp');
    } catch (e) {
      // fallback: فتح واتساب بنص فقط
      if (context.mounted) {
        const msg = '🌙 تطبيق أذكاري — تطبيق إسلامي متكامل\nصنع بكل حب — عادل خالد ❤️';
        final encoded = Uri.encodeComponent(msg);
        await launchUrl(
          Uri.parse('whatsapp://send?text=$encoded'),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
        children: [
          // بطاقة الترويسة
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.primaryDeep, AppColors.primary],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                  child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 4),
                      Text(
                        AppConstants.appTagline,
                        style: TextStyle(color: Color(0xD9FFFFFF), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // قسم المظهر
          const _SectionTitle('المظهر والرؤية'),
          const SizedBox(height: 10),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) => _SettingsGroup(
              children: [
                _SettingTile(
                  icon: state.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  iconColor: AppColors.gold,
                  title: 'الوضع الداكن',
                  subtitle: state.isDark ? 'مفعّل بألوان مريحة وعالية التباين' : 'استخدم ألوانًا فاتحة',
                  trailing: Switch.adaptive(
                    value: state.isDark,
                    onChanged: (_) => context.read<SettingsCubit>().toggleDark(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // قسم الإشعارات والتذكيرات
          const _SectionTitle('التنبيهات والإشعارات'),
          const SizedBox(height: 10),
          _SettingsGroup(
            children: [
              BlocBuilder<PrayerCubit, PrayerState>(
                builder: (context, prayerState) => _SettingTile(
                  icon: Icons.notifications_active_rounded,
                  iconColor: AppColors.primary,
                  title: 'إشعارات الأذان',
                  subtitle: prayerState.notificationsEnabled ? 'تنبيه فوري بحلول موعد كل صلاة' : 'معطلة',
                  trailing: Switch.adaptive(
                    value: prayerState.notificationsEnabled,
                    onChanged: (val) => context.read<PrayerCubit>().setNotificationsEnabled(val),
                  ),
                ),
              ),
              const Divider(height: 1, indent: 64),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) => Column(
                  children: [
                    _SettingTile(
                      icon: Icons.access_time_filled_rounded,
                      iconColor: AppColors.amber,
                      title: 'الصلاة على النبي ﷺ',
                      subtitle: settingsState.salawatEnabled
                          ? 'يتكرر كل ${settingsState.salawatIntervalMinutes} دقيقة (إشعار فوري عند التفعيل)'
                          : 'معطل',
                      trailing: Switch.adaptive(
                        value: settingsState.salawatEnabled,
                        onChanged: (_) => context.read<SettingsCubit>().toggleSalawat(),
                      ),
                    ),
                    if (settingsState.salawatEnabled) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اختر تكرار التذكير بالدقائق:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [10, 20, 30, 45, 60].map((mins) {
                                final isSelected = settingsState.salawatIntervalMinutes == mins;
                                return ChoiceChip(
                                  label: Text(
                                    mins == 60 ? 'كل ساعة' : '$mins دقيقة',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected
                                          ? (isDark ? Colors.black : Colors.white)
                                          : (isDark ? AppColors.textDark : AppColors.textLight),
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: isDark ? const Color(0xFF26C49B) : AppColors.primary,
                                  backgroundColor: isDark
                                      ? AppColors.surfaceDarkHighlight
                                      : AppColors.backgroundLight,
                                  onSelected: (val) {
                                    if (val) {
                                      context.read<SettingsCubit>().setSalawatInterval(mins);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('تم تفعيل التذكير كل $mins دقيقة مع إرسال إشعار فوري'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // قسم مواقيت الصلاة والمدينة
          const _SectionTitle('مواقيت الصلاة والمدينة'),
          const SizedBox(height: 10),
          BlocBuilder<PrayerCubit, PrayerState>(
            builder: (context, prayerState) => _SettingsGroup(
              children: [
                _SettingTile(
                  icon: Icons.location_on_rounded,
                  iconColor: AppColors.rose,
                  title: 'المدينة الحالية',
                  subtitle: prayerState.city.displayName,
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => _showCityPicker(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // قسم المطور والتواصل (واتساب)
          const _SectionTitle('المطوّر والدعم الفني'),
          const SizedBox(height: 10),
          _SettingsGroup(
            children: [
              _SettingTile(
                icon: Icons.person_rounded,
                iconColor: AppColors.primary,
                title: 'تطوير المهندس',
                subtitle: AppConstants.developerName,
              ),
              const Divider(height: 1, indent: 64),
              _SettingTile(
                icon: Icons.chat_rounded,
                iconColor: const Color(0xFF25D366),
                title: 'تواصل عبر واتساب',
                subtitle: AppConstants.developerPhone,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'مراسلة',
                        style: TextStyle(
                          color: Color(0xFF25D366),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.open_in_new_rounded, size: 13, color: Color(0xFF25D366)),
                    ],
                  ),
                ),
                onTap: () => _openWhatsApp(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // قسم مشاركة التطبيق
          const _SectionTitle('شارك التطبيق'),
          const SizedBox(height: 10),
          _SettingsGroup(
            children: [
              _SettingTile(
                icon: Icons.send_rounded,
                iconColor: const Color(0xFF25D366),
                title: 'إرسال التطبيق عبر واتساب',
                subtitle: 'يُرسل ملف التطبيق (APK) مباشرةً عبر واتساب',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'إرسال',
                        style: TextStyle(
                          color: Color(0xFF25D366),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.open_in_new_rounded, size: 13, color: Color(0xFF25D366)),
                    ],
                  ),
                ),
                onTap: () => _shareApkViaWhatsApp(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // قسم حول التطبيق
          const _SectionTitle('عن التطبيق'),
          const SizedBox(height: 10),
          _SettingsGroup(
            children: [
              const _SettingTile(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.blue,
                title: 'الإصدار',
                subtitle: AppConstants.appVersion,
              ),
            ],
          ),
          const SizedBox(height: 28),

          Center(
            child: Column(
              children: [
                Text(
                  'نسأل الله أن ينفع به ويكتب أجر كل من شاركه',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'صنع بكل حب • عادل خالد',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'اختر مدينتك',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: PrayerRepository.defaultCities.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (subCtx, i) {
                    final city = PrayerRepository.defaultCities[i];
                    final isSelected = subCtx.watch<PrayerCubit>().state.city.id == city.id;
                    return ListTile(
                      title: Text(
                        city.nameAr,
                        style: TextStyle(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500),
                      ),
                      subtitle: Text(city.countryAr),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () {
                        context.read<PrayerCubit>().selectCity(city);
                        Navigator.of(subCtx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      );
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      );
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: trailing,
      );
}
