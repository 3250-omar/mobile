import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// اسم التطبيق الأساسي
  ///
  /// In ar, this message translates to:
  /// **'عروض الأسعار والفواتير'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get homeTitle;

  /// No description provided for @homeDescription.
  ///
  /// In ar, this message translates to:
  /// **'الواجهة الأساسية للتطبيق التي تعمل بدون اتصال بالإنترنت بنسبة 100%.'**
  String get homeDescription;

  /// No description provided for @scanTitle.
  ///
  /// In ar, this message translates to:
  /// **'المسح الضوئي'**
  String get scanTitle;

  /// No description provided for @scanUnavailableTitle.
  ///
  /// In ar, this message translates to:
  /// **'المسح الضوئي غير متوفر حالياً'**
  String get scanUnavailableTitle;

  /// No description provided for @scanUnavailableMessage.
  ///
  /// In ar, this message translates to:
  /// **'سيتم تفعيل ميزة التعرف الضوئي على خط اليد محلياً في مرحلة تالية.'**
  String get scanUnavailableMessage;

  /// No description provided for @productsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get productsTitle;

  /// No description provided for @productsUnavailableTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل المنتجات غير مفعل'**
  String get productsUnavailableTitle;

  /// No description provided for @productsUnavailableMessage.
  ///
  /// In ar, this message translates to:
  /// **'ستتاح إدارة المنتجات وقوائم الأسعار المحلية في مرحلة قادمة.'**
  String get productsUnavailableMessage;

  /// No description provided for @quotationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'عروض الأسعار'**
  String get quotationsTitle;

  /// No description provided for @quotationsUnavailableTitle.
  ///
  /// In ar, this message translates to:
  /// **'عروض الأسعار غير مفعلة'**
  String get quotationsUnavailableTitle;

  /// No description provided for @quotationsUnavailableMessage.
  ///
  /// In ar, this message translates to:
  /// **'ميزة إنشاء عروض الأسعار وحسابها محلياً قيد التطوير للمرحلة القادمة.'**
  String get quotationsUnavailableMessage;

  /// No description provided for @invoicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get invoicesTitle;

  /// No description provided for @invoicesUnavailableTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير غير مفعلة'**
  String get invoicesUnavailableTitle;

  /// No description provided for @invoicesUnavailableMessage.
  ///
  /// In ar, this message translates to:
  /// **'ميزة إدارة الفواتير المحلية ستكون متاحة في مرحلة لاحقة.'**
  String get invoicesUnavailableMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @settingsThemeSection.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsThemeSection;

  /// No description provided for @themeModeSystem.
  ///
  /// In ar, this message translates to:
  /// **'تلقائي (حسب النظام)'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeModeDark;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguageSection;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @settingsAboutSection.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get settingsAboutSection;

  /// No description provided for @appVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار 0.1.0'**
  String get appVersion;

  /// No description provided for @offlineStatus.
  ///
  /// In ar, this message translates to:
  /// **'العمل بدون إنترنت (100% محلي)'**
  String get offlineStatus;

  /// No description provided for @saveSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الإعدادات بنجاح'**
  String get saveSuccess;

  /// No description provided for @saveFailure.
  ///
  /// In ar, this message translates to:
  /// **'تعذر حفظ الإعدادات، يرجى المحاولة مرة أخرى'**
  String get saveFailure;

  /// No description provided for @bootstrapInitializing.
  ///
  /// In ar, this message translates to:
  /// **'جاري تهيئة النظام وقاعدة البيانات المحلية...'**
  String get bootstrapInitializing;

  /// No description provided for @bootstrapStageConfig.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من إعدادات البيئة...'**
  String get bootstrapStageConfig;

  /// No description provided for @bootstrapStageDiagnostics.
  ///
  /// In ar, this message translates to:
  /// **'تهيئة سجل التشخيص المحلي...'**
  String get bootstrapStageDiagnostics;

  /// No description provided for @bootstrapStageStoragePath.
  ///
  /// In ar, this message translates to:
  /// **'تأمين مسار التخزين الخاص...'**
  String get bootstrapStageStoragePath;

  /// No description provided for @bootstrapStageDatabase.
  ///
  /// In ar, this message translates to:
  /// **'فتح قاعدة البيانات المحلية...'**
  String get bootstrapStageDatabase;

  /// No description provided for @bootstrapStageMigration.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من سلامة البيانات...'**
  String get bootstrapStageMigration;

  /// No description provided for @bootstrapStageSettings.
  ///
  /// In ar, this message translates to:
  /// **'تحميل التفضيلات...'**
  String get bootstrapStageSettings;

  /// No description provided for @bootstrapStageComposition.
  ///
  /// In ar, this message translates to:
  /// **'تجهيز واجهة التطبيق...'**
  String get bootstrapStageComposition;

  /// No description provided for @bootstrapFailureTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذر بدء التطبيق'**
  String get bootstrapFailureTitle;

  /// No description provided for @bootstrapRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get bootstrapRetry;

  /// No description provided for @bootstrapDiagnosticsAction.
  ///
  /// In ar, this message translates to:
  /// **'عرض بيانات التشخيص'**
  String get bootstrapDiagnosticsAction;

  /// No description provided for @bootstrapCopyDiagnostics.
  ///
  /// In ar, this message translates to:
  /// **'نسخ رمز التشخيص'**
  String get bootstrapCopyDiagnostics;

  /// No description provided for @bootstrapDiagnosticsCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ رمز التشخيص إلى الحافظة'**
  String get bootstrapDiagnosticsCopied;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع. تم الإبقاء على ملفاتك بأمان دون أي تغيير.'**
  String get errorGeneric;

  /// No description provided for @errorDatabase.
  ///
  /// In ar, this message translates to:
  /// **'تعذر فتح قاعدة البيانات المحلية بأمان. تم الحفاظ على ملفاتك دون تعديل.'**
  String get errorDatabase;

  /// No description provided for @errorMigration.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تحديث هيكل البيانات. تم الاحتفاظ بالبيانات الحالية بأمان.'**
  String get errorMigration;

  /// No description provided for @errorStorageProtection.
  ///
  /// In ar, this message translates to:
  /// **'تعذر التحقق من حماية البيانات واستبعادها من النسخ السحابي.'**
  String get errorStorageProtection;

  /// No description provided for @errorConfig.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات البيئة غير صالحة.'**
  String get errorConfig;

  /// No description provided for @errorNewerSchema.
  ///
  /// In ar, this message translates to:
  /// **'قاعدة البيانات تتبع إصداراً أحدث من التطبيق. يرجى تحديث التطبيق للمتابعة.'**
  String get errorNewerSchema;

  /// No description provided for @notFoundTitle.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة غير موجودة'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In ar, this message translates to:
  /// **'المسار المطلوب غير متوفر حالياً.'**
  String get notFoundMessage;

  /// No description provided for @backToHome.
  ///
  /// In ar, this message translates to:
  /// **'العودة للرئيسية'**
  String get backToHome;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @emptyStateDefault.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناصر لعرضها'**
  String get emptyStateDefault;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @codeDiagnosticRef.
  ///
  /// In ar, this message translates to:
  /// **'رمز التشخيص: {ref}'**
  String codeDiagnosticRef(String ref);

  /// No description provided for @catalogTitle.
  ///
  /// In ar, this message translates to:
  /// **'دليل الأصناف والمنتجات'**
  String get catalogTitle;

  /// No description provided for @catalogSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث بالاسم، الكود، أو المقاس...'**
  String get catalogSearchHint;

  /// No description provided for @catalogEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أصناف مسجلة'**
  String get catalogEmptyTitle;

  /// No description provided for @catalogEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بإضافة صنف جديد يدوياً أو استيراد ملف إكسيل'**
  String get catalogEmptyMessage;

  /// No description provided for @catalogNoSearchResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أصناف مطابقة لبحثك'**
  String get catalogNoSearchResults;

  /// No description provided for @catalogClearSearch.
  ///
  /// In ar, this message translates to:
  /// **'مسح البحث'**
  String get catalogClearSearch;

  /// No description provided for @catalogExportAction.
  ///
  /// In ar, this message translates to:
  /// **'تصدير كإكسيل'**
  String get catalogExportAction;

  /// No description provided for @catalogImportAction.
  ///
  /// In ar, this message translates to:
  /// **'استيراد من إكسيل'**
  String get catalogImportAction;

  /// No description provided for @catalogAddProduct.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صنف جديد'**
  String get catalogAddProduct;

  /// No description provided for @catalogEditProduct.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات الصنف'**
  String get catalogEditProduct;

  /// No description provided for @catalogDeleteProduct.
  ///
  /// In ar, this message translates to:
  /// **'حذف الصنف'**
  String get catalogDeleteProduct;

  /// No description provided for @catalogDeleteConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف الصنف؟'**
  String get catalogDeleteConfirmation;

  /// No description provided for @catalogExportSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تصدير ملف الأصناف بنجاح'**
  String get catalogExportSuccess;

  /// No description provided for @catalogImportSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم استيراد الأصناف بنجاح'**
  String get catalogImportSuccess;

  /// No description provided for @currencyEgp.
  ///
  /// In ar, this message translates to:
  /// **'ج.م'**
  String get currencyEgp;

  /// No description provided for @unitPiece.
  ///
  /// In ar, this message translates to:
  /// **'قطعة'**
  String get unitPiece;

  /// No description provided for @unitMeter.
  ///
  /// In ar, this message translates to:
  /// **'متر'**
  String get unitMeter;

  /// No description provided for @quotationNew.
  ///
  /// In ar, this message translates to:
  /// **'عرض سعر جديد'**
  String get quotationNew;

  /// No description provided for @quotationEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل عرض السعر'**
  String get quotationEdit;

  /// No description provided for @quotationCustomerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل أو المؤسسة'**
  String get quotationCustomerName;

  /// No description provided for @quotationCustomerPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get quotationCustomerPhone;

  /// No description provided for @quotationNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات العرض'**
  String get quotationNotes;

  /// No description provided for @quotationSubtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع الفرعي'**
  String get quotationSubtotal;

  /// No description provided for @quotationDiscount.
  ///
  /// In ar, this message translates to:
  /// **'خصم إضافي'**
  String get quotationDiscount;

  /// No description provided for @quotationGrandTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي النهائي المطلوب'**
  String get quotationGrandTotal;

  /// No description provided for @quotationSaveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كمسودة'**
  String get quotationSaveDraft;

  /// No description provided for @quotationSaveEdit.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get quotationSaveEdit;

  /// No description provided for @quotationDuplicate.
  ///
  /// In ar, this message translates to:
  /// **'نسخ كمسودة'**
  String get quotationDuplicate;

  /// No description provided for @quotationDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف عرض السعر'**
  String get quotationDelete;

  /// No description provided for @quotationDeleteConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد حذف عرض السعر'**
  String get quotationDeleteConfirmTitle;

  /// No description provided for @quotationDeleteConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في حذف عرض السعر؟'**
  String get quotationDeleteConfirmMessage;

  /// No description provided for @quotationDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get quotationDraft;

  /// No description provided for @quotationSent.
  ///
  /// In ar, this message translates to:
  /// **'تم الإرسال'**
  String get quotationSent;

  /// No description provided for @quotationAccepted.
  ///
  /// In ar, this message translates to:
  /// **'مقبول'**
  String get quotationAccepted;

  /// No description provided for @quotationRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get quotationRejected;

  /// No description provided for @quotationConverted.
  ///
  /// In ar, this message translates to:
  /// **'تم التحويل لفاتورة'**
  String get quotationConverted;

  /// No description provided for @quotationEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أي عروض أسعار حتى الآن'**
  String get quotationEmptyTitle;

  /// No description provided for @quotationEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بإنشاء عرض سعر جديد للعميل مع حساب فوري وتلقائي'**
  String get quotationEmptyMessage;

  /// No description provided for @quotationFromCatalog.
  ///
  /// In ar, this message translates to:
  /// **'من الدليل'**
  String get quotationFromCatalog;

  /// No description provided for @quotationCustomItem.
  ///
  /// In ar, this message translates to:
  /// **'صنف مخصص'**
  String get quotationCustomItem;

  /// No description provided for @quotationItemsTitle.
  ///
  /// In ar, this message translates to:
  /// **'بنود وأصناف عرض السعر'**
  String get quotationItemsTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
