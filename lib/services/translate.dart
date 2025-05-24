import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class TranslationService {
  static const Map<String, Map<String, String>> _translations = {
    'profile': {'en': 'Profile', 'ar': 'الملف الشخصي', 'he': 'פרופיל'},
    'upgrade': {'en': 'Upgrade', 'ar': 'ترقية', 'he': 'שדרוג'},
    'store_name': {'en': 'Store Name', 'ar': 'اسم المتجر', 'he': 'שם החנות'},
    'phone_number': {
      'en': 'Phone Number',
      'ar': 'رقم الهاتف',
      'he': 'מספר טלפון',
    },
    'email': {'en': 'Email', 'ar': 'البريد الإلكتروني', 'he': 'אימייל'},
    'change_subscription_plan': {
      'en': 'Change Subscription Plan',
      'ar': 'تغيير خطة الاشتراك',
      'he': 'שנה תוכנית מנוי',
    },
    'working_hours': {
      'en': 'Working Hours',
      'ar': 'ساعات العمل',
      'he': 'שעות עבודה',
    },
    'password': {'en': 'Password', 'ar': 'كلمة المرور', 'he': 'סיסמה'},
    'save': {'en': 'Save', 'ar': 'حفظ', 'he': 'שמור'},
    'confirm_password': {
      'en': 'Confirm Password',
      'ar': 'تأكيد كلمة المرور',
      'he': 'אשר סיסמה',
    },
    'edit': {'en': 'Edit', 'ar': 'تعديل', 'he': 'ערוך'},
    'state': {'en': 'State', 'ar': 'الدولة', 'he': 'מדינה'},
    'city': {'en': 'City', 'ar': 'المدينة', 'he': 'עיר'},
    'country': {'en': 'Country', 'ar': 'البلد', 'he': 'מדינה'},
    'pincode': {'en': 'Pincode', 'ar': 'الرمز البريدي', 'he': 'מיקוד'},
    'update_profile': {
      'en': 'Update Profile',
      'ar': 'تحديث الملف الشخصي',
      'he': 'עדכן פרופיל',
    },
    'orders': {'en': 'Orders', 'ar': 'الطلبات', 'he': 'הזמנות'},
    'delete': {'en': 'Delete', 'ar': 'حذف', 'he': 'מחק'},
    'filter': {'en': 'Filter', 'ar': 'تصفية', 'he': 'סינון'},
  };

  static String translate(BuildContext context, String key) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    return _translations[key]?[lang] ?? key;
  }
}
