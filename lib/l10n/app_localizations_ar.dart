// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'عروض الأسعار والفواتير';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get homeDescription =>
      'الواجهة الأساسية للتطبيق التي تعمل بدون اتصال بالإنترنت بنسبة 100%.';

  @override
  String get scanTitle => 'المسح الضوئي';

  @override
  String get scanUnavailableTitle => 'المسح الضوئي غير متوفر حالياً';

  @override
  String get scanUnavailableMessage =>
      'سيتم تفعيل ميزة التعرف الضوئي على خط اليد محلياً في مرحلة تالية.';

  @override
  String get productsTitle => 'المنتجات';

  @override
  String get productsUnavailableTitle => 'سجل المنتجات غير مفعل';

  @override
  String get productsUnavailableMessage =>
      'ستتاح إدارة المنتجات وقوائم الأسعار المحلية في مرحلة قادمة.';

  @override
  String get quotationsTitle => 'عروض الأسعار';

  @override
  String get quotationsUnavailableTitle => 'عروض الأسعار غير مفعلة';

  @override
  String get quotationsUnavailableMessage =>
      'ميزة إنشاء عروض الأسعار وحسابها محلياً قيد التطوير للمرحلة القادمة.';

  @override
  String get invoicesTitle => 'الفواتير';

  @override
  String get invoicesUnavailableTitle => 'الفواتير غير مفعلة';

  @override
  String get invoicesUnavailableMessage =>
      'ميزة إدارة الفواتير المحلية ستكون متاحة في مرحلة لاحقة.';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsThemeSection => 'المظهر';

  @override
  String get themeModeSystem => 'تلقائي (حسب النظام)';

  @override
  String get themeModeLight => 'فاتح';

  @override
  String get themeModeDark => 'داكن';

  @override
  String get settingsLanguageSection => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get settingsAboutSection => 'حول التطبيق';

  @override
  String get appVersion => 'الإصدار 0.1.0';

  @override
  String get offlineStatus => 'العمل بدون إنترنت (100% محلي)';

  @override
  String get saveSuccess => 'تم حفظ الإعدادات بنجاح';

  @override
  String get saveFailure => 'تعذر حفظ الإعدادات، يرجى المحاولة مرة أخرى';

  @override
  String get bootstrapInitializing =>
      'جاري تهيئة النظام وقاعدة البيانات المحلية...';

  @override
  String get bootstrapStageConfig => 'التحقق من إعدادات البيئة...';

  @override
  String get bootstrapStageDiagnostics => 'تهيئة سجل التشخيص المحلي...';

  @override
  String get bootstrapStageStoragePath => 'تأمين مسار التخزين الخاص...';

  @override
  String get bootstrapStageDatabase => 'فتح قاعدة البيانات المحلية...';

  @override
  String get bootstrapStageMigration => 'التحقق من سلامة البيانات...';

  @override
  String get bootstrapStageSettings => 'تحميل التفضيلات...';

  @override
  String get bootstrapStageComposition => 'تجهيز واجهة التطبيق...';

  @override
  String get bootstrapFailureTitle => 'تعذر بدء التطبيق';

  @override
  String get bootstrapRetry => 'إعادة المحاولة';

  @override
  String get bootstrapDiagnosticsAction => 'عرض بيانات التشخيص';

  @override
  String get bootstrapCopyDiagnostics => 'نسخ رمز التشخيص';

  @override
  String get bootstrapDiagnosticsCopied => 'تم نسخ رمز التشخيص إلى الحافظة';

  @override
  String get errorGeneric =>
      'حدث خطأ غير متوقع. تم الإبقاء على ملفاتك بأمان دون أي تغيير.';

  @override
  String get errorDatabase =>
      'تعذر فتح قاعدة البيانات المحلية بأمان. تم الحفاظ على ملفاتك دون تعديل.';

  @override
  String get errorMigration =>
      'تعذر تحديث هيكل البيانات. تم الاحتفاظ بالبيانات الحالية بأمان.';

  @override
  String get errorStorageProtection =>
      'تعذر التحقق من حماية البيانات واستبعادها من النسخ السحابي.';

  @override
  String get errorConfig => 'إعدادات البيئة غير صالحة.';

  @override
  String get errorNewerSchema =>
      'قاعدة البيانات تتبع إصداراً أحدث من التطبيق. يرجى تحديث التطبيق للمتابعة.';

  @override
  String get notFoundTitle => 'الصفحة غير موجودة';

  @override
  String get notFoundMessage => 'المسار المطلوب غير متوفر حالياً.';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get emptyStateDefault => 'لا توجد عناصر لعرضها';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String codeDiagnosticRef(String ref) {
    return 'رمز التشخيص: $ref';
  }

  @override
  String get catalogTitle => 'دليل الأصناف والمنتجات';

  @override
  String get catalogSearchHint => 'ابحث بالاسم، الكود، أو المقاس...';

  @override
  String get catalogEmptyTitle => 'لا توجد أصناف مسجلة';

  @override
  String get catalogEmptyMessage =>
      'ابدأ بإضافة صنف جديد يدوياً أو استيراد ملف إكسيل';

  @override
  String get catalogNoSearchResults => 'لا توجد أصناف مطابقة لبحثك';

  @override
  String get catalogClearSearch => 'مسح البحث';

  @override
  String get catalogExportAction => 'تصدير كإكسيل';

  @override
  String get catalogImportAction => 'استيراد من إكسيل';

  @override
  String get catalogAddProduct => 'إضافة صنف جديد';

  @override
  String get catalogEditProduct => 'تعديل بيانات الصنف';

  @override
  String get catalogDeleteProduct => 'حذف الصنف';

  @override
  String get catalogDeleteConfirmation => 'هل أنت متأكد من حذف الصنف؟';

  @override
  String get catalogExportSuccess => 'تم تصدير ملف الأصناف بنجاح';

  @override
  String get catalogImportSuccess => 'تم استيراد الأصناف بنجاح';

  @override
  String get currencyEgp => 'ج.م';

  @override
  String get unitPiece => 'قطعة';

  @override
  String get unitMeter => 'متر';

  @override
  String get quotationNew => 'عرض سعر جديد';

  @override
  String get quotationEdit => 'تعديل عرض السعر';

  @override
  String get quotationCustomerName => 'اسم العميل أو المؤسسة';

  @override
  String get quotationCustomerPhone => 'رقم الهاتف';

  @override
  String get quotationNotes => 'ملاحظات العرض';

  @override
  String get quotationSubtotal => 'المجموع الفرعي';

  @override
  String get quotationDiscount => 'خصم إضافي';

  @override
  String get quotationGrandTotal => 'الإجمالي النهائي المطلوب';

  @override
  String get quotationSaveDraft => 'حفظ كمسودة';

  @override
  String get quotationSaveEdit => 'حفظ التعديلات';

  @override
  String get quotationDuplicate => 'نسخ كمسودة';

  @override
  String get quotationDelete => 'حذف عرض السعر';

  @override
  String get quotationDeleteConfirmTitle => 'تأكيد حذف عرض السعر';

  @override
  String get quotationDeleteConfirmMessage =>
      'هل أنت متأكد من رغبتك في حذف عرض السعر؟';

  @override
  String get quotationDraft => 'مسودة';

  @override
  String get quotationSent => 'تم الإرسال';

  @override
  String get quotationAccepted => 'مقبول';

  @override
  String get quotationRejected => 'مرفوض';

  @override
  String get quotationConverted => 'تم التحويل لفاتورة';

  @override
  String get quotationEmptyTitle => 'لا توجد أي عروض أسعار حتى الآن';

  @override
  String get quotationEmptyMessage =>
      'ابدأ بإنشاء عرض سعر جديد للعميل مع حساب فوري وتلقائي';

  @override
  String get quotationFromCatalog => 'من الدليل';

  @override
  String get quotationCustomItem => 'صنف مخصص';

  @override
  String get quotationItemsTitle => 'بنود وأصناف عرض السعر';

  @override
  String get invoiceNew => 'فاتورة جديدة';

  @override
  String get invoiceCustomerName => 'اسم العميل أو المؤسسة';

  @override
  String get invoiceCustomerPhone => 'رقم الهاتف';

  @override
  String get invoiceNotes => 'ملاحظات الفاتورة';

  @override
  String get invoiceSubtotal => 'المجموع الفرعي';

  @override
  String get invoiceDiscount => 'خصم إضافي';

  @override
  String get invoiceTax => 'ضريبة القيمة المضافة';

  @override
  String get invoiceGrandTotal => 'الإجمالي النهائي المطلوب';

  @override
  String get invoicePaidAmount => 'المبلغ المسدد';

  @override
  String get invoiceRemainingBalance => 'المبلغ المتبقي';

  @override
  String get invoiceRecordPayment => 'تسجيل دفعة';

  @override
  String get invoiceSave => 'حفظ الفاتورة';

  @override
  String get invoiceDelete => 'حذف الفاتورة';

  @override
  String get invoiceCancel => 'إلغاء الفاتورة';

  @override
  String get invoicePrintA4 => 'طباعة فاتورة A4';

  @override
  String get invoicePrintReceipt => 'إيصال حراري (80 مم)';

  @override
  String get invoiceStatusUnpaid => 'غير مسدد';

  @override
  String get invoiceStatusPartiallyPaid => 'مسدد جزئياً';

  @override
  String get invoiceStatusPaid => 'مسدد بالكامل';

  @override
  String get invoiceStatusCancelled => 'ملغي';

  @override
  String get invoiceEmptyTitle => 'لا توجد فواتير مبيعات مسجلة';

  @override
  String get invoiceEmptyMessage =>
      'ابدأ بإنشاء فاتورة جديدة أو تحويل أحد عروض الأسعار المقبولة';

  @override
  String get invoiceItemsTitle => 'بنود وأصناف الفاتورة';

  @override
  String get invoiceMetricsTotal => 'الفواتير';

  @override
  String get invoiceMetricsReceivables => 'المستحقات';

  @override
  String get invoiceMetricsPaid => 'المحصل';

  @override
  String get scanCameraCapture => 'التقاط بالكاميرا';

  @override
  String get scanGalleryPick => 'اختيار من المعرض';

  @override
  String get scanProcessing => 'جاري التعرف على النص ومطابقة الأصناف محلياً...';

  @override
  String get scanReviewTitle => 'مراجعة الأصناف المستخرجة';

  @override
  String get scanEmptyNoText => 'لم يتم العثور على أي نصوص في الصورة المحددة';

  @override
  String get scanStatusVerified => 'مطابق ومؤكد';

  @override
  String get scanStatusNeedsReview => 'بحاجة لمراجعة';

  @override
  String get scanStatusUnmatched => 'صنف مخصص';

  @override
  String get scanSelectCandidate => 'اختيار الصنف المطابق';

  @override
  String get scanConfidence => 'نسبة الدقة';

  @override
  String get scanCreateQuotation => 'إنشاء عرض سعر';

  @override
  String get scanCreateInvoice => 'إنشاء فاتورة';

  @override
  String get scanAddManualItem => 'إضافة صنف جديد';

  @override
  String get scanDeleteItem => 'حذف البند';

  @override
  String get scanConfidenceWarning =>
      'تنبيه: دقة المطابقة أقل من 85% أو توجد عدة أصناف مشابهة، يرجى التأكيد.';

  @override
  String get scanKeepCustomItem => 'الإبقاء كصنف مخصص';

  @override
  String get scanOriginalImage => 'معاينة المستند الممسوح';

  @override
  String get scanExtractButton => 'بدء المعالجة والاستخراج';

  @override
  String get scanTakeAnother => 'مسح ورقة أخرى';
}
