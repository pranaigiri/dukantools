import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @k000.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get k000;

  /// No description provided for @k10lCanSize.
  ///
  /// In en, this message translates to:
  /// **'10L Can Size'**
  String get k10lCanSize;

  /// No description provided for @k1lCanSize.
  ///
  /// In en, this message translates to:
  /// **'1L Can Size'**
  String get k1lCanSize;

  /// No description provided for @k4lCanSize.
  ///
  /// In en, this message translates to:
  /// **'4L Can Size'**
  String get k4lCanSize;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @accessory1Cost.
  ///
  /// In en, this message translates to:
  /// **'Accessory 1 Cost (₹)'**
  String get accessory1Cost;

  /// No description provided for @accessory2Cost.
  ///
  /// In en, this message translates to:
  /// **'Accessory 2 Cost (₹)'**
  String get accessory2Cost;

  /// No description provided for @accessory3Cost.
  ///
  /// In en, this message translates to:
  /// **'Accessory 3 Cost (₹)'**
  String get accessory3Cost;

  /// No description provided for @accessoryType.
  ///
  /// In en, this message translates to:
  /// **'Accessory Type'**
  String get accessoryType;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @accountIsSettledNoReminderNeeded.
  ///
  /// In en, this message translates to:
  /// **'Account is settled. No reminder needed.'**
  String get accountIsSettledNoReminderNeeded;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get accountNotFound;

  /// No description provided for @activePurchaseDays.
  ///
  /// In en, this message translates to:
  /// **'Active Purchase Days'**
  String get activePurchaseDays;

  /// No description provided for @activeShop.
  ///
  /// In en, this message translates to:
  /// **'Active Shop'**
  String get activeShop;

  /// No description provided for @actualMargin.
  ///
  /// In en, this message translates to:
  /// **'Actual Margin %'**
  String get actualMargin;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add (+)'**
  String get add;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @addNewCustomerAccount.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer Account'**
  String get addNewCustomerAccount;

  /// No description provided for @addShop.
  ///
  /// In en, this message translates to:
  /// **'Add Shop'**
  String get addShop;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @ageOfPhoneYears.
  ///
  /// In en, this message translates to:
  /// **'Age of Phone (Years)'**
  String get ageOfPhoneYears;

  /// No description provided for @aggregateQuantity.
  ///
  /// In en, this message translates to:
  /// **'Aggregate Quantity'**
  String get aggregateQuantity;

  /// No description provided for @allInOneGoodsFinanceCalculator.
  ///
  /// In en, this message translates to:
  /// **'All in One - Goods & Finance Calculator'**
  String get allInOneGoodsFinanceCalculator;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get amount;

  /// No description provided for @approxGravelBrass.
  ///
  /// In en, this message translates to:
  /// **'Approx Gravel Brass'**
  String get approxGravelBrass;

  /// No description provided for @approxSandBrass1Brass100CuFt.
  ///
  /// In en, this message translates to:
  /// **'Approx Sand Brass (1 Brass = 100 cu ft)'**
  String get approxSandBrass1Brass100CuFt;

  /// No description provided for @areaLengthFt.
  ///
  /// In en, this message translates to:
  /// **'Area Length (ft)'**
  String get areaLengthFt;

  /// No description provided for @areaToCoverSqFt.
  ///
  /// In en, this message translates to:
  /// **'Area to Cover (sq ft)'**
  String get areaToCoverSqFt;

  /// No description provided for @areaWidthFt.
  ///
  /// In en, this message translates to:
  /// **'Area Width (ft)'**
  String get areaWidthFt;

  /// No description provided for @averageCupsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Average Cups per Day'**
  String get averageCupsPerDay;

  /// No description provided for @averageDailyPurchaseSpend.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Purchase Spend (₹)'**
  String get averageDailyPurchaseSpend;

  /// No description provided for @averageDistancePerPointFt.
  ///
  /// In en, this message translates to:
  /// **'Average Distance per Point (ft)'**
  String get averageDistancePerPointFt;

  /// No description provided for @averageValueEstimate.
  ///
  /// In en, this message translates to:
  /// **'Average Value estimate'**
  String get averageValueEstimate;

  /// No description provided for @baseFabricCost.
  ///
  /// In en, this message translates to:
  /// **'Base Fabric Cost (₹)'**
  String get baseFabricCost;

  /// No description provided for @baseItemPrice.
  ///
  /// In en, this message translates to:
  /// **'Base Item Price (₹)'**
  String get baseItemPrice;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// No description provided for @baseSareePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Saree Price'**
  String get baseSareePrice;

  /// No description provided for @baseTeaCost.
  ///
  /// In en, this message translates to:
  /// **'Base Tea Cost (₹)'**
  String get baseTeaCost;

  /// No description provided for @batchNumber.
  ///
  /// In en, this message translates to:
  /// **'Batch Number'**
  String get batchNumber;

  /// No description provided for @billDate.
  ///
  /// In en, this message translates to:
  /// **'Bill Date'**
  String get billDate;

  /// No description provided for @billingHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Billing Hourly Rate'**
  String get billingHourlyRate;

  /// No description provided for @blouseCutRequirementM.
  ///
  /// In en, this message translates to:
  /// **'Blouse Cut Requirement (m)'**
  String get blouseCutRequirementM;

  /// No description provided for @blouseFabricCost.
  ///
  /// In en, this message translates to:
  /// **'Blouse Fabric Cost (₹)'**
  String get blouseFabricCost;

  /// No description provided for @blouseLengthCut.
  ///
  /// In en, this message translates to:
  /// **'Blouse Length Cut'**
  String get blouseLengthCut;

  /// No description provided for @boxPriceAtPtr.
  ///
  /// In en, this message translates to:
  /// **'Box Price at PTR (₹)'**
  String get boxPriceAtPtr;

  /// No description provided for @boxesToPurchase.
  ///
  /// In en, this message translates to:
  /// **'Boxes to Purchase'**
  String get boxesToPurchase;

  /// No description provided for @brandACostPrice.
  ///
  /// In en, this message translates to:
  /// **'Brand A Cost Price (₹)'**
  String get brandACostPrice;

  /// No description provided for @brandAName.
  ///
  /// In en, this message translates to:
  /// **'Brand A Name'**
  String get brandAName;

  /// No description provided for @brandASellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Brand A Selling Price (₹)'**
  String get brandASellingPrice;

  /// No description provided for @brandBCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Brand B Cost Price (₹)'**
  String get brandBCostPrice;

  /// No description provided for @brandBName.
  ///
  /// In en, this message translates to:
  /// **'Brand B Name'**
  String get brandBName;

  /// No description provided for @brandBSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Brand B Selling Price (₹)'**
  String get brandBSellingPrice;

  /// No description provided for @bulkPackPrice.
  ///
  /// In en, this message translates to:
  /// **'Bulk Pack Price (₹)'**
  String get bulkPackPrice;

  /// No description provided for @bulkSavingsCalculator.
  ///
  /// In en, this message translates to:
  /// **'Bulk Savings Calculator'**
  String get bulkSavingsCalculator;

  /// No description provided for @buyPrice.
  ///
  /// In en, this message translates to:
  /// **'Buy Price (₹)'**
  String get buyPrice;

  /// No description provided for @calculateDiscount.
  ///
  /// In en, this message translates to:
  /// **'Calculate Discount'**
  String get calculateDiscount;

  /// No description provided for @calculatedWeightG.
  ///
  /// In en, this message translates to:
  /// **'Calculated Weight (g)'**
  String get calculatedWeightG;

  /// No description provided for @calculationType.
  ///
  /// In en, this message translates to:
  /// **'Calculation Type'**
  String get calculationType;

  /// No description provided for @calculators.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get calculators;

  /// No description provided for @callDial.
  ///
  /// In en, this message translates to:
  /// **'Call Dial'**
  String get callDial;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cashFlowLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow (Last 7 Days)'**
  String get cashFlowLast7Days;

  /// No description provided for @cashNetMargin.
  ///
  /// In en, this message translates to:
  /// **'Cash Net Margin'**
  String get cashNetMargin;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @cgstHalf.
  ///
  /// In en, this message translates to:
  /// **'CGST (half)'**
  String get cgstHalf;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @compact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get compact;

  /// No description provided for @concreteMixRatio.
  ///
  /// In en, this message translates to:
  /// **'Concrete Mix Ratio'**
  String get concreteMixRatio;

  /// No description provided for @concreteVolume.
  ///
  /// In en, this message translates to:
  /// **'Concrete Volume'**
  String get concreteVolume;

  /// No description provided for @conditionOfPhone.
  ///
  /// In en, this message translates to:
  /// **'Condition of Phone'**
  String get conditionOfPhone;

  /// No description provided for @contractedArea.
  ///
  /// In en, this message translates to:
  /// **'Contracted Area'**
  String get contractedArea;

  /// No description provided for @conversionFactor.
  ///
  /// In en, this message translates to:
  /// **'Conversion Factor'**
  String get conversionFactor;

  /// No description provided for @convertedValue.
  ///
  /// In en, this message translates to:
  /// **'Converted value'**
  String get convertedValue;

  /// No description provided for @copyAndSendThisMessageToTheCustomer.
  ///
  /// In en, this message translates to:
  /// **'Copy and send this message to the customer:'**
  String get copyAndSendThisMessageToTheCustomer;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get copyText;

  /// No description provided for @costFor5Meters.
  ///
  /// In en, this message translates to:
  /// **'Cost for 5 meters'**
  String get costFor5Meters;

  /// No description provided for @costFor6MetersStandardSaree.
  ///
  /// In en, this message translates to:
  /// **'Cost for 6 meters (Standard Saree)'**
  String get costFor6MetersStandardSaree;

  /// No description provided for @costPerStrip.
  ///
  /// In en, this message translates to:
  /// **'Cost per Strip'**
  String get costPerStrip;

  /// No description provided for @costPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price (₹)'**
  String get costPrice;

  /// No description provided for @coverageSqFtPerKg.
  ///
  /// In en, this message translates to:
  /// **'Coverage (sq ft per kg)'**
  String get coverageSqFtPerKg;

  /// No description provided for @coverageRate.
  ///
  /// In en, this message translates to:
  /// **'Coverage Rate'**
  String get coverageRate;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createNewShop.
  ///
  /// In en, this message translates to:
  /// **'Create New Shop'**
  String get createNewShop;

  /// No description provided for @creditDaysAllowed.
  ///
  /// In en, this message translates to:
  /// **'Credit Days Allowed'**
  String get creditDaysAllowed;

  /// No description provided for @criticalExpiryWarning.
  ///
  /// In en, this message translates to:
  /// **'Critical Expiry Warning'**
  String get criticalExpiryWarning;

  /// No description provided for @cupsSoldPerDay.
  ///
  /// In en, this message translates to:
  /// **'Cups Sold per Day'**
  String get cupsSoldPerDay;

  /// No description provided for @cupsToHitTargetProfit.
  ///
  /// In en, this message translates to:
  /// **'Cups to Hit Target Profit'**
  String get cupsToHitTargetProfit;

  /// No description provided for @currentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get currentLevel;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// No description provided for @customTaxRate.
  ///
  /// In en, this message translates to:
  /// **'Custom Tax Rate (%)'**
  String get customTaxRate;

  /// No description provided for @customerComboSavings.
  ///
  /// In en, this message translates to:
  /// **'Customer Combo Savings'**
  String get customerComboSavings;

  /// No description provided for @customerQuotedPrice.
  ///
  /// In en, this message translates to:
  /// **'Customer Quoted Price (₹)'**
  String get customerQuotedPrice;

  /// No description provided for @cylinderCost.
  ///
  /// In en, this message translates to:
  /// **'Cylinder Cost (₹)'**
  String get cylinderCost;

  /// No description provided for @dailyBook.
  ///
  /// In en, this message translates to:
  /// **'Daily Book'**
  String get dailyBook;

  /// No description provided for @dailyBurnRate.
  ///
  /// In en, this message translates to:
  /// **'Daily Burn Rate'**
  String get dailyBurnRate;

  /// No description provided for @dailyFuelCost.
  ///
  /// In en, this message translates to:
  /// **'Daily Fuel Cost'**
  String get dailyFuelCost;

  /// No description provided for @dailyPurchaseRate.
  ///
  /// In en, this message translates to:
  /// **'Daily Purchase Rate'**
  String get dailyPurchaseRate;

  /// No description provided for @dailyRevenueAtBreakeven.
  ///
  /// In en, this message translates to:
  /// **'Daily Revenue at Break-even'**
  String get dailyRevenueAtBreakeven;

  /// No description provided for @dayBook.
  ///
  /// In en, this message translates to:
  /// **'Day Book'**
  String get dayBook;

  /// No description provided for @daysCylinderLasts.
  ///
  /// In en, this message translates to:
  /// **'Days Cylinder Lasts'**
  String get daysCylinderLasts;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccount;

  /// No description provided for @deleteShop.
  ///
  /// In en, this message translates to:
  /// **'Delete Shop?'**
  String get deleteShop;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @desiredPrice.
  ///
  /// In en, this message translates to:
  /// **'Desired Price (₹)'**
  String get desiredPrice;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed By:'**
  String get developedBy;

  /// No description provided for @digitalCashDrawer.
  ///
  /// In en, this message translates to:
  /// **'Digital Cash Drawer'**
  String get digitalCashDrawer;

  /// No description provided for @dineinMargin.
  ///
  /// In en, this message translates to:
  /// **'Dine-in Margin %'**
  String get dineinMargin;

  /// No description provided for @dineinPrice.
  ///
  /// In en, this message translates to:
  /// **'Dine-in Price (₹)'**
  String get dineinPrice;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discount;

  /// No description provided for @discountPerItem.
  ///
  /// In en, this message translates to:
  /// **'Discount per Item'**
  String get discountPerItem;

  /// No description provided for @discountRate.
  ///
  /// In en, this message translates to:
  /// **'Discount Rate (%)'**
  String get discountRate;

  /// No description provided for @displayFolderCost.
  ///
  /// In en, this message translates to:
  /// **'Display Folder Cost (₹)'**
  String get displayFolderCost;

  /// No description provided for @displayQualityType.
  ///
  /// In en, this message translates to:
  /// **'Display Quality Type'**
  String get displayQualityType;

  /// No description provided for @downPayment.
  ///
  /// In en, this message translates to:
  /// **'Down Payment (₹)'**
  String get downPayment;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @dukanTools.
  ///
  /// In en, this message translates to:
  /// **'Dukan Tools'**
  String get dukanTools;

  /// No description provided for @dynamicCalculationConverter.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Calculation Converter'**
  String get dynamicCalculationConverter;

  /// No description provided for @earnedProfit.
  ///
  /// In en, this message translates to:
  /// **'Earned Profit'**
  String get earnedProfit;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editCustomerProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer Profile'**
  String get editCustomerProfile;

  /// No description provided for @embroideryCharges.
  ///
  /// In en, this message translates to:
  /// **'Embroidery Charges (₹)'**
  String get embroideryCharges;

  /// No description provided for @emiCalculator.
  ///
  /// In en, this message translates to:
  /// **'EMI Calculator'**
  String get emiCalculator;

  /// No description provided for @emiNetMargin.
  ///
  /// In en, this message translates to:
  /// **'EMI Net Margin'**
  String get emiNetMargin;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @enterLoanAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Loan Amount'**
  String get enterLoanAmount;

  /// No description provided for @enterOriginalPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter Original Price'**
  String get enterOriginalPrice;

  /// No description provided for @enterPrincipalAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Principal Amount'**
  String get enterPrincipalAmount;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValue;

  /// No description provided for @entryRemoved.
  ///
  /// In en, this message translates to:
  /// **'Entry removed'**
  String get entryRemoved;

  /// No description provided for @errorLoadingVersion.
  ///
  /// In en, this message translates to:
  /// **'Error loading version'**
  String get errorLoadingVersion;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRate;

  /// No description provided for @exclusiveAddGst.
  ///
  /// In en, this message translates to:
  /// **'Exclusive (Add GST)'**
  String get exclusiveAddGst;

  /// No description provided for @expectedCupsToSell.
  ///
  /// In en, this message translates to:
  /// **'Expected Cups to Sell'**
  String get expectedCupsToSell;

  /// No description provided for @expectedRevenuePace.
  ///
  /// In en, this message translates to:
  /// **'Expected Revenue Pace'**
  String get expectedRevenuePace;

  /// No description provided for @expectedRunoutDate.
  ///
  /// In en, this message translates to:
  /// **'Expected Run-out Date'**
  String get expectedRunoutDate;

  /// No description provided for @expectedWastage.
  ///
  /// In en, this message translates to:
  /// **'Expected Wastage'**
  String get expectedWastage;

  /// No description provided for @expensePaid.
  ///
  /// In en, this message translates to:
  /// **'Expense (Paid)'**
  String get expensePaid;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @expiryEntrySavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Expiry entry saved successfully!'**
  String get expiryEntrySavedSuccessfully;

  /// No description provided for @fabricCostShare.
  ///
  /// In en, this message translates to:
  /// **'Fabric Cost Share'**
  String get fabricCostShare;

  /// No description provided for @fabricRatePerMeter.
  ///
  /// In en, this message translates to:
  /// **'Fabric Rate per Meter (₹)'**
  String get fabricRatePerMeter;

  /// No description provided for @fabricValue.
  ///
  /// In en, this message translates to:
  /// **'Fabric Value'**
  String get fabricValue;

  /// No description provided for @fallCost.
  ///
  /// In en, this message translates to:
  /// **'Fall Cost (₹)'**
  String get fallCost;

  /// No description provided for @finalCustomQuote.
  ///
  /// In en, this message translates to:
  /// **'Final Custom Quote (₹)'**
  String get finalCustomQuote;

  /// No description provided for @finalPriceAfterDiscount.
  ///
  /// In en, this message translates to:
  /// **'Final Price (After Discount)'**
  String get finalPriceAfterDiscount;

  /// No description provided for @fittingLaborCost.
  ///
  /// In en, this message translates to:
  /// **'Fitting Labor Cost (₹)'**
  String get fittingLaborCost;

  /// No description provided for @fixedCostsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Fixed Costs per Day (₹)'**
  String get fixedCostsPerDay;

  /// No description provided for @flatAmount.
  ///
  /// In en, this message translates to:
  /// **'Flat Amount (₹)'**
  String get flatAmount;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @gasCostPerDay.
  ///
  /// In en, this message translates to:
  /// **'Gas Cost per Day (₹)'**
  String get gasCostPerDay;

  /// No description provided for @gstSlab.
  ///
  /// In en, this message translates to:
  /// **'GST Slab'**
  String get gstSlab;

  /// No description provided for @gstTaxCalculator.
  ///
  /// In en, this message translates to:
  /// **'GST Tax Calculator'**
  String get gstTaxCalculator;

  /// No description provided for @inclusiveSplitGst.
  ///
  /// In en, this message translates to:
  /// **'Inclusive (Split GST)'**
  String get inclusiveSplitGst;

  /// No description provided for @incomeGot.
  ///
  /// In en, this message translates to:
  /// **'Income (Got)'**
  String get incomeGot;

  /// No description provided for @initialConditionFactor.
  ///
  /// In en, this message translates to:
  /// **'Initial Condition Factor'**
  String get initialConditionFactor;

  /// No description provided for @interestCalculator.
  ///
  /// In en, this message translates to:
  /// **'Interest Calculator'**
  String get interestCalculator;

  /// No description provided for @interestEarnedSi.
  ///
  /// In en, this message translates to:
  /// **'Interest Earned (SI)'**
  String get interestEarnedSi;

  /// No description provided for @interestRatePa.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate (% P.A.)'**
  String get interestRatePa;

  /// No description provided for @interestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate (%)'**
  String get interestRate;

  /// No description provided for @interestType.
  ///
  /// In en, this message translates to:
  /// **'Interest Type'**
  String get interestType;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @itemPrice.
  ///
  /// In en, this message translates to:
  /// **'Item Price (₹)'**
  String get itemPrice;

  /// No description provided for @laborCost.
  ///
  /// In en, this message translates to:
  /// **'Labor Cost (₹)'**
  String get laborCost;

  /// No description provided for @laborCostPerDay.
  ///
  /// In en, this message translates to:
  /// **'Labor Cost per Day (₹)'**
  String get laborCostPerDay;

  /// No description provided for @laborDuration.
  ///
  /// In en, this message translates to:
  /// **'Labor Duration'**
  String get laborDuration;

  /// No description provided for @labourRatePerSqFt.
  ///
  /// In en, this message translates to:
  /// **'Labour Rate per sq ft (₹)'**
  String get labourRatePerSqFt;

  /// No description provided for @laceLengthUsedM.
  ///
  /// In en, this message translates to:
  /// **'Lace Length Used (m)'**
  String get laceLengthUsedM;

  /// No description provided for @laceMaterialCost.
  ///
  /// In en, this message translates to:
  /// **'Lace Material Cost'**
  String get laceMaterialCost;

  /// No description provided for @laceRatePerMeter.
  ///
  /// In en, this message translates to:
  /// **'Lace Rate per Meter (₹)'**
  String get laceRatePerMeter;

  /// No description provided for @lastUpdatedRates.
  ///
  /// In en, this message translates to:
  /// **'Last Updated (Rates)'**
  String get lastUpdatedRates;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @ledgerBalanceRatio.
  ///
  /// In en, this message translates to:
  /// **'Ledger Balance Ratio'**
  String get ledgerBalanceRatio;

  /// No description provided for @lengthPerRodMeters.
  ///
  /// In en, this message translates to:
  /// **'Length per Rod (meters)'**
  String get lengthPerRodMeters;

  /// No description provided for @loadedProductionCost.
  ///
  /// In en, this message translates to:
  /// **'Loaded Production Cost'**
  String get loadedProductionCost;

  /// No description provided for @loadingSponsoredSpace.
  ///
  /// In en, this message translates to:
  /// **'Loading Sponsored Space...'**
  String get loadingSponsoredSpace;

  /// No description provided for @loanAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan Amount (₹)'**
  String get loanAmount;

  /// No description provided for @lotTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Lot Total Cost (₹)'**
  String get lotTotalCost;

  /// No description provided for @manageShops.
  ///
  /// In en, this message translates to:
  /// **'Manage Shops'**
  String get manageShops;

  /// No description provided for @margin.
  ///
  /// In en, this message translates to:
  /// **'Margin %'**
  String get margin;

  /// No description provided for @marginCalculator.
  ///
  /// In en, this message translates to:
  /// **'Margin Calculator'**
  String get marginCalculator;

  /// No description provided for @marginDiff.
  ///
  /// In en, this message translates to:
  /// **'Margin Diff'**
  String get marginDiff;

  /// No description provided for @marginMode.
  ///
  /// In en, this message translates to:
  /// **'Margin Mode'**
  String get marginMode;

  /// No description provided for @marginPerItem.
  ///
  /// In en, this message translates to:
  /// **'Margin per Item (₹)'**
  String get marginPerItem;

  /// No description provided for @marginPercentage.
  ///
  /// In en, this message translates to:
  /// **'Margin Percentage'**
  String get marginPercentage;

  /// No description provided for @marginSet.
  ///
  /// In en, this message translates to:
  /// **'Margin set'**
  String get marginSet;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @metersNeeded.
  ///
  /// In en, this message translates to:
  /// **'Meters Needed'**
  String get metersNeeded;

  /// No description provided for @milkCostPerLiter.
  ///
  /// In en, this message translates to:
  /// **'Milk Cost (₹ per Liter)'**
  String get milkCostPerLiter;

  /// No description provided for @milkNeeded.
  ///
  /// In en, this message translates to:
  /// **'Milk Needed'**
  String get milkNeeded;

  /// No description provided for @milkPerCupMl.
  ///
  /// In en, this message translates to:
  /// **'Milk per Cup (ml)'**
  String get milkPerCupMl;

  /// No description provided for @minSellingPriceBreakeven.
  ///
  /// In en, this message translates to:
  /// **'Min Selling Price (Break-even)'**
  String get minSellingPriceBreakeven;

  /// No description provided for @minimumThreshold.
  ///
  /// In en, this message translates to:
  /// **'Minimum Threshold'**
  String get minimumThreshold;

  /// No description provided for @monthlyEmiAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly EMI Amount'**
  String get monthlyEmiAmount;

  /// No description provided for @monthlyOverview.
  ///
  /// In en, this message translates to:
  /// **'Monthly Overview'**
  String get monthlyOverview;

  /// No description provided for @monthlyRevenueTarget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue Target (₹)'**
  String get monthlyRevenueTarget;

  /// No description provided for @mrp.
  ///
  /// In en, this message translates to:
  /// **'MRP (₹)'**
  String get mrp;

  /// No description provided for @mrpPerItem.
  ///
  /// In en, this message translates to:
  /// **'MRP per Item (₹)'**
  String get mrpPerItem;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get name;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @netDayBookBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Day Book Balance'**
  String get netDayBookBalance;

  /// No description provided for @netDistanceNeeded.
  ///
  /// In en, this message translates to:
  /// **'Net Distance needed'**
  String get netDistanceNeeded;

  /// No description provided for @netMilkNeeded.
  ///
  /// In en, this message translates to:
  /// **'Net Milk Needed'**
  String get netMilkNeeded;

  /// No description provided for @netPrincipalLoaned.
  ///
  /// In en, this message translates to:
  /// **'Net Principal Loaned'**
  String get netPrincipalLoaned;

  /// No description provided for @netProfitMargin.
  ///
  /// In en, this message translates to:
  /// **'Net Profit Margin'**
  String get netProfitMargin;

  /// No description provided for @newShop.
  ///
  /// In en, this message translates to:
  /// **'New Shop'**
  String get newShop;

  /// No description provided for @newShopName.
  ///
  /// In en, this message translates to:
  /// **'New Shop Name *'**
  String get newShopName;

  /// No description provided for @nextRefreshSchedule.
  ///
  /// In en, this message translates to:
  /// **'Next Refresh Schedule'**
  String get nextRefreshSchedule;

  /// No description provided for @noEntriesForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No entries for this day'**
  String get noEntriesForThisDay;

  /// No description provided for @noEntriesRecordedYet.
  ///
  /// In en, this message translates to:
  /// **'No entries recorded yet.'**
  String get noEntriesRecordedYet;

  /// No description provided for @noPhoneNumberRegistered.
  ///
  /// In en, this message translates to:
  /// **'No phone number registered'**
  String get noPhoneNumberRegistered;

  /// No description provided for @noTransactionsLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions logged yet'**
  String get noTransactionsLoggedYet;

  /// No description provided for @noTransactionsRecordedYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions recorded yet'**
  String get noTransactionsRecordedYet;

  /// No description provided for @numberOfCoats.
  ///
  /// In en, this message translates to:
  /// **'Number of Coats'**
  String get numberOfCoats;

  /// No description provided for @numberOfConnectionPoints.
  ///
  /// In en, this message translates to:
  /// **'Number of Connection Points'**
  String get numberOfConnectionPoints;

  /// No description provided for @numberOfCups.
  ///
  /// In en, this message translates to:
  /// **'Number of Cups'**
  String get numberOfCups;

  /// No description provided for @numberOfPiecesInLot.
  ///
  /// In en, this message translates to:
  /// **'Number of Pieces in Lot'**
  String get numberOfPiecesInLot;

  /// No description provided for @numberOfRods.
  ///
  /// In en, this message translates to:
  /// **'Number of Rods'**
  String get numberOfRods;

  /// No description provided for @offlineManualConversion.
  ///
  /// In en, this message translates to:
  /// **'Offline Manual Conversion'**
  String get offlineManualConversion;

  /// No description provided for @originalLength.
  ///
  /// In en, this message translates to:
  /// **'Original Length'**
  String get originalLength;

  /// No description provided for @originalMrpOfOldPhone.
  ///
  /// In en, this message translates to:
  /// **'Original MRP of Old Phone (₹)'**
  String get originalMrpOfOldPhone;

  /// No description provided for @originalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original Price (₹)'**
  String get originalPrice;

  /// No description provided for @otherWorkStonesBeads.
  ///
  /// In en, this message translates to:
  /// **'Other Work (Stones, Beads) (₹)'**
  String get otherWorkStonesBeads;

  /// No description provided for @overheadCostPerCup.
  ///
  /// In en, this message translates to:
  /// **'Overhead Cost per Cup'**
  String get overheadCostPerCup;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @overviewDashboard.
  ///
  /// In en, this message translates to:
  /// **'Overview Dashboard'**
  String get overviewDashboard;

  /// No description provided for @packQuantityItems.
  ///
  /// In en, this message translates to:
  /// **'Pack Quantity (Items)'**
  String get packQuantityItems;

  /// No description provided for @packagingCost.
  ///
  /// In en, this message translates to:
  /// **'Packaging Cost (₹)'**
  String get packagingCost;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'Percent (%)'**
  String get percent;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (Optional)'**
  String get phoneOptional;

  /// No description provided for @phoneCost.
  ///
  /// In en, this message translates to:
  /// **'Phone Cost (₹)'**
  String get phoneCost;

  /// No description provided for @phoneCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Phone Cost Price (₹)'**
  String get phoneCostPrice;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phonePrice.
  ///
  /// In en, this message translates to:
  /// **'Phone Price (₹)'**
  String get phonePrice;

  /// No description provided for @phoneSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Phone Selling Price (₹)'**
  String get phoneSellingPrice;

  /// No description provided for @pleaseSelectAnExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Please select an expiry date'**
  String get pleaseSelectAnExpiryDate;

  /// No description provided for @popularPairs.
  ///
  /// In en, this message translates to:
  /// **'Popular Pairs'**
  String get popularPairs;

  /// No description provided for @pranaiGiriTheDesignerSikkim.
  ///
  /// In en, this message translates to:
  /// **'Pranai Giri (The Designer Sikkim)'**
  String get pranaiGiriTheDesignerSikkim;

  /// No description provided for @prevMonth.
  ///
  /// In en, this message translates to:
  /// **'Prev Month'**
  String get prevMonth;

  /// No description provided for @principalAmount.
  ///
  /// In en, this message translates to:
  /// **'Principal Amount (₹)'**
  String get principalAmount;

  /// No description provided for @principalLoanAmount.
  ///
  /// In en, this message translates to:
  /// **'Principal Loan Amount'**
  String get principalLoanAmount;

  /// No description provided for @processingFeeCommission.
  ///
  /// In en, this message translates to:
  /// **'Processing Fee Commission (₹)'**
  String get processingFeeCommission;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @profitAmount.
  ///
  /// In en, this message translates to:
  /// **'Profit Amount'**
  String get profitAmount;

  /// No description provided for @profitCalculator.
  ///
  /// In en, this message translates to:
  /// **'Profit Calculator'**
  String get profitCalculator;

  /// No description provided for @profitDifference.
  ///
  /// In en, this message translates to:
  /// **'Profit Difference'**
  String get profitDifference;

  /// No description provided for @profitEarned.
  ///
  /// In en, this message translates to:
  /// **'Profit Earned'**
  String get profitEarned;

  /// No description provided for @profitMarginAmount.
  ///
  /// In en, this message translates to:
  /// **'Profit Margin Amount'**
  String get profitMarginAmount;

  /// No description provided for @profitMarginPerCup.
  ///
  /// In en, this message translates to:
  /// **'Profit Margin per Cup'**
  String get profitMarginPerCup;

  /// No description provided for @profitMarginPercentage.
  ///
  /// In en, this message translates to:
  /// **'Profit Margin Percentage'**
  String get profitMarginPercentage;

  /// No description provided for @profitPerPiece.
  ///
  /// In en, this message translates to:
  /// **'Profit per Piece'**
  String get profitPerPiece;

  /// No description provided for @profitPercentage.
  ///
  /// In en, this message translates to:
  /// **'Profit Percentage'**
  String get profitPercentage;

  /// No description provided for @ptrDiscountFromMrp.
  ///
  /// In en, this message translates to:
  /// **'PTR Discount % from MRP'**
  String get ptrDiscountFromMrp;

  /// No description provided for @ptrPerUnit.
  ///
  /// In en, this message translates to:
  /// **'PTR per Unit (₹)'**
  String get ptrPerUnit;

  /// No description provided for @ptrPricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'PTR Price per Unit'**
  String get ptrPricePerUnit;

  /// No description provided for @ptsDiscountFromPtr.
  ///
  /// In en, this message translates to:
  /// **'PTS Discount % from PTR'**
  String get ptsDiscountFromPtr;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantityOptional.
  ///
  /// In en, this message translates to:
  /// **'Quantity (Optional)'**
  String get quantityOptional;

  /// No description provided for @quantityPurchased.
  ///
  /// In en, this message translates to:
  /// **'Quantity Purchased'**
  String get quantityPurchased;

  /// No description provided for @quantityReceived.
  ///
  /// In en, this message translates to:
  /// **'Quantity Received'**
  String get quantityReceived;

  /// No description provided for @quantitySold.
  ///
  /// In en, this message translates to:
  /// **'Quantity Sold'**
  String get quantitySold;

  /// No description provided for @quantityToReturn.
  ///
  /// In en, this message translates to:
  /// **'Quantity to Return'**
  String get quantityToReturn;

  /// No description provided for @rateContract.
  ///
  /// In en, this message translates to:
  /// **'Rate Contract'**
  String get rateContract;

  /// No description provided for @rateOfInterestPa.
  ///
  /// In en, this message translates to:
  /// **'Rate of Interest (% P.A.)'**
  String get rateOfInterestPa;

  /// No description provided for @ratePer100g.
  ///
  /// In en, this message translates to:
  /// **'Rate per 100g'**
  String get ratePer100g;

  /// No description provided for @ratePerGram.
  ///
  /// In en, this message translates to:
  /// **'Rate per Gram'**
  String get ratePerGram;

  /// No description provided for @ratePerKg.
  ///
  /// In en, this message translates to:
  /// **'Rate per kg (₹)'**
  String get ratePerKg;

  /// No description provided for @ratePerSheet.
  ///
  /// In en, this message translates to:
  /// **'Rate per Sheet (₹)'**
  String get ratePerSheet;

  /// No description provided for @rawCostTotal.
  ///
  /// In en, this message translates to:
  /// **'Raw Cost Total'**
  String get rawCostTotal;

  /// No description provided for @receivedCount.
  ///
  /// In en, this message translates to:
  /// **'Received Count'**
  String get receivedCount;

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'Remaining Days'**
  String get remainingDays;

  /// No description provided for @remainingTarget.
  ///
  /// In en, this message translates to:
  /// **'Remaining Target'**
  String get remainingTarget;

  /// No description provided for @reminderCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Reminder copied to clipboard!'**
  String get reminderCopiedToClipboard;

  /// No description provided for @renameShop.
  ///
  /// In en, this message translates to:
  /// **'Rename Shop'**
  String get renameShop;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @retailPrice.
  ///
  /// In en, this message translates to:
  /// **'Retail Price (₹)'**
  String get retailPrice;

  /// No description provided for @retailProfit.
  ///
  /// In en, this message translates to:
  /// **'Retail Profit'**
  String get retailProfit;

  /// No description provided for @retailerMargin.
  ///
  /// In en, this message translates to:
  /// **'Retailer Margin'**
  String get retailerMargin;

  /// No description provided for @revenueEarnedSoFar.
  ///
  /// In en, this message translates to:
  /// **'Revenue Earned So Far (₹)'**
  String get revenueEarnedSoFar;

  /// No description provided for @rodDiameterMm.
  ///
  /// In en, this message translates to:
  /// **'Rod Diameter (mm)'**
  String get rodDiameterMm;

  /// No description provided for @roomHeightFt.
  ///
  /// In en, this message translates to:
  /// **'Room Height (ft)'**
  String get roomHeightFt;

  /// No description provided for @roomLengthFt.
  ///
  /// In en, this message translates to:
  /// **'Room Length (ft)'**
  String get roomLengthFt;

  /// No description provided for @roomWidthFt.
  ///
  /// In en, this message translates to:
  /// **'Room Width (ft)'**
  String get roomWidthFt;

  /// No description provided for @salesCategory.
  ///
  /// In en, this message translates to:
  /// **'Sales Category'**
  String get salesCategory;

  /// No description provided for @salesComparisonMonthonmonth.
  ///
  /// In en, this message translates to:
  /// **'Sales Comparison (Month-on-Month)'**
  String get salesComparisonMonthonmonth;

  /// No description provided for @sandQuantity.
  ///
  /// In en, this message translates to:
  /// **'Sand Quantity'**
  String get sandQuantity;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveToExpiryLog.
  ///
  /// In en, this message translates to:
  /// **'Save to Expiry Log'**
  String get saveToExpiryLog;

  /// No description provided for @savedExpiryLog.
  ///
  /// In en, this message translates to:
  /// **'Saved Expiry Log'**
  String get savedExpiryLog;

  /// No description provided for @savingsAmount.
  ///
  /// In en, this message translates to:
  /// **'Savings Amount'**
  String get savingsAmount;

  /// No description provided for @scrapFabric.
  ///
  /// In en, this message translates to:
  /// **'Scrap Fabric'**
  String get scrapFabric;

  /// No description provided for @searchCustomerOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search customer or phone...'**
  String get searchCustomerOrPhone;

  /// No description provided for @sellPrice.
  ///
  /// In en, this message translates to:
  /// **'Sell Price (₹)'**
  String get sellPrice;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price (₹)'**
  String get sellingPrice;

  /// No description provided for @sellingPricePerCup.
  ///
  /// In en, this message translates to:
  /// **'Selling Price per Cup (₹)'**
  String get sellingPricePerCup;

  /// No description provided for @sellingPricePerPiece.
  ///
  /// In en, this message translates to:
  /// **'Selling Price per Piece (₹)'**
  String get sellingPricePerPiece;

  /// No description provided for @setCustomExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Set Custom Exchange Rate'**
  String get setCustomExchangeRate;

  /// No description provided for @sgstHalf.
  ///
  /// In en, this message translates to:
  /// **'SGST (half)'**
  String get sgstHalf;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareBalanceReminder.
  ///
  /// In en, this message translates to:
  /// **'Share Balance Reminder'**
  String get shareBalanceReminder;

  /// No description provided for @shareReminder.
  ///
  /// In en, this message translates to:
  /// **'Share Reminder'**
  String get shareReminder;

  /// No description provided for @sheetDimensionSize.
  ///
  /// In en, this message translates to:
  /// **'Sheet Dimension size'**
  String get sheetDimensionSize;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop Name *'**
  String get shopName;

  /// No description provided for @shortageQuantity.
  ///
  /// In en, this message translates to:
  /// **'Shortage Quantity'**
  String get shortageQuantity;

  /// No description provided for @singleItemPrice.
  ///
  /// In en, this message translates to:
  /// **'Single Item Price (₹)'**
  String get singleItemPrice;

  /// No description provided for @singleSheetCover.
  ///
  /// In en, this message translates to:
  /// **'Single Sheet Cover'**
  String get singleSheetCover;

  /// No description provided for @singleTileSize.
  ///
  /// In en, this message translates to:
  /// **'Single Tile Size'**
  String get singleTileSize;

  /// No description provided for @smsShare.
  ///
  /// In en, this message translates to:
  /// **'SMS Share'**
  String get smsShare;

  /// No description provided for @snackCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Snack Cost Price (₹)'**
  String get snackCostPrice;

  /// No description provided for @snackSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Snack Selling Price (₹)'**
  String get snackSellingPrice;

  /// No description provided for @soldCount.
  ///
  /// In en, this message translates to:
  /// **'Sold Count'**
  String get soldCount;

  /// No description provided for @sourceUnit.
  ///
  /// In en, this message translates to:
  /// **'Source Unit'**
  String get sourceUnit;

  /// No description provided for @sparePartCost.
  ///
  /// In en, this message translates to:
  /// **'Spare Part Cost (₹)'**
  String get sparePartCost;

  /// No description provided for @spreadDiffRetailWholesale.
  ///
  /// In en, this message translates to:
  /// **'Spread Diff (Retail - Wholesale)'**
  String get spreadDiffRetailWholesale;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @standard10ftPipesCount.
  ///
  /// In en, this message translates to:
  /// **'Standard 10-ft Pipes Count'**
  String get standard10ftPipesCount;

  /// No description provided for @standardGstSlabs.
  ///
  /// In en, this message translates to:
  /// **'Standard GST Slabs'**
  String get standardGstSlabs;

  /// No description provided for @standardSeparateCost.
  ///
  /// In en, this message translates to:
  /// **'Standard Separate Cost'**
  String get standardSeparateCost;

  /// No description provided for @stockistMargin.
  ///
  /// In en, this message translates to:
  /// **'Stockist Margin'**
  String get stockistMargin;

  /// No description provided for @stripsPerBox.
  ///
  /// In en, this message translates to:
  /// **'Strips per Box'**
  String get stripsPerBox;

  /// No description provided for @subtract.
  ///
  /// In en, this message translates to:
  /// **'Subtract (-)'**
  String get subtract;

  /// No description provided for @sugarCostPerKg.
  ///
  /// In en, this message translates to:
  /// **'Sugar Cost (₹ per kg)'**
  String get sugarCostPerKg;

  /// No description provided for @sugarNeeded.
  ///
  /// In en, this message translates to:
  /// **'Sugar Needed'**
  String get sugarNeeded;

  /// No description provided for @suggestedQuote35Margin.
  ///
  /// In en, this message translates to:
  /// **'Suggested Quote (35% Margin)'**
  String get suggestedQuote35Margin;

  /// No description provided for @suggestedSellingPrice30Margin.
  ///
  /// In en, this message translates to:
  /// **'Suggested Selling Price (30% margin)'**
  String get suggestedSellingPrice30Margin;

  /// No description provided for @switchShop.
  ///
  /// In en, this message translates to:
  /// **'Switch Shop'**
  String get switchShop;

  /// No description provided for @tabletsPerStrip.
  ///
  /// In en, this message translates to:
  /// **'Tablets per Strip'**
  String get tabletsPerStrip;

  /// No description provided for @takeawayMargin.
  ///
  /// In en, this message translates to:
  /// **'Takeaway Margin %'**
  String get takeawayMargin;

  /// No description provided for @takeawayPrice.
  ///
  /// In en, this message translates to:
  /// **'Takeaway Price (₹)'**
  String get takeawayPrice;

  /// No description provided for @tallyReportCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Tally report copied to clipboard!'**
  String get tallyReportCopiedToClipboard;

  /// No description provided for @tapAddTransactionToLogCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Add Transaction\' to log cash flow.'**
  String get tapAddTransactionToLogCashFlow;

  /// No description provided for @targetComboMargin.
  ///
  /// In en, this message translates to:
  /// **'Target Combo Margin %'**
  String get targetComboMargin;

  /// No description provided for @targetMargin.
  ///
  /// In en, this message translates to:
  /// **'Target Margin %'**
  String get targetMargin;

  /// No description provided for @targetProfitPerDay.
  ///
  /// In en, this message translates to:
  /// **'Target Profit per Day (₹)'**
  String get targetProfitPerDay;

  /// No description provided for @targetTrackerStatus.
  ///
  /// In en, this message translates to:
  /// **'Target Tracker Status'**
  String get targetTrackerStatus;

  /// No description provided for @targetUnit.
  ///
  /// In en, this message translates to:
  /// **'Target Unit'**
  String get targetUnit;

  /// No description provided for @teaLeavesCostPer100g.
  ///
  /// In en, this message translates to:
  /// **'Tea Leaves Cost (₹ per 100g)'**
  String get teaLeavesCostPer100g;

  /// No description provided for @teaLeavesNeeded.
  ///
  /// In en, this message translates to:
  /// **'Tea Leaves Needed'**
  String get teaLeavesNeeded;

  /// No description provided for @tenureMonths.
  ///
  /// In en, this message translates to:
  /// **'Tenure (Months)'**
  String get tenureMonths;

  /// No description provided for @thicknessFt.
  ///
  /// In en, this message translates to:
  /// **'Thickness (ft)'**
  String get thicknessFt;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisToolIsDevelopedForTheShopownersToHelpThemOnTheirDailyCalculationTasks.
  ///
  /// In en, this message translates to:
  /// **'This tool is developed for the shopowners to help them on their daily calculation tasks.'**
  String
      get thisToolIsDevelopedForTheShopownersToHelpThemOnTheirDailyCalculationTasks;

  /// No description provided for @thresholdLevel.
  ///
  /// In en, this message translates to:
  /// **'Threshold Level'**
  String get thresholdLevel;

  /// No description provided for @tileLengthInches.
  ///
  /// In en, this message translates to:
  /// **'Tile Length (inches)'**
  String get tileLengthInches;

  /// No description provided for @tileWidthInches.
  ///
  /// In en, this message translates to:
  /// **'Tile Width (inches)'**
  String get tileWidthInches;

  /// No description provided for @tilesPerBox.
  ///
  /// In en, this message translates to:
  /// **'Tiles per Box'**
  String get tilesPerBox;

  /// No description provided for @timePeriod.
  ///
  /// In en, this message translates to:
  /// **'Time Period'**
  String get timePeriod;

  /// No description provided for @timePeriodEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Time Period Equivalent'**
  String get timePeriodEquivalent;

  /// No description provided for @timePeriodUnit.
  ///
  /// In en, this message translates to:
  /// **'Time Period Unit'**
  String get timePeriodUnit;

  /// No description provided for @timeTakenMinutes.
  ///
  /// In en, this message translates to:
  /// **'Time Taken (Minutes)'**
  String get timeTakenMinutes;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @topActiveAccounts.
  ///
  /// In en, this message translates to:
  /// **'Top Active Accounts'**
  String get topActiveAccounts;

  /// No description provided for @totalAreaWithWastage.
  ///
  /// In en, this message translates to:
  /// **'Total Area with Wastage'**
  String get totalAreaWithWastage;

  /// No description provided for @totalBatchCost.
  ///
  /// In en, this message translates to:
  /// **'Total Batch Cost'**
  String get totalBatchCost;

  /// No description provided for @totalChainMargin.
  ///
  /// In en, this message translates to:
  /// **'Total Chain Margin'**
  String get totalChainMargin;

  /// No description provided for @totalCoinsCount.
  ///
  /// In en, this message translates to:
  /// **'Total Coins Count'**
  String get totalCoinsCount;

  /// No description provided for @totalComboCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Combo Cost Price'**
  String get totalComboCostPrice;

  /// No description provided for @totalCostCp.
  ///
  /// In en, this message translates to:
  /// **'Total Cost (CP)'**
  String get totalCostCp;

  /// No description provided for @totalCostPriceCp.
  ///
  /// In en, this message translates to:
  /// **'Total Cost Price (CP)'**
  String get totalCostPriceCp;

  /// No description provided for @totalCupsBoiledPerCylinder.
  ///
  /// In en, this message translates to:
  /// **'Total Cups boiled per Cylinder'**
  String get totalCupsBoiledPerCylinder;

  /// No description provided for @totalDaysInMonth.
  ///
  /// In en, this message translates to:
  /// **'Total Days in Month'**
  String get totalDaysInMonth;

  /// No description provided for @totalExpectedRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Expected Revenue'**
  String get totalExpectedRevenue;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @totalFabricCost.
  ///
  /// In en, this message translates to:
  /// **'Total Fabric Cost (₹)'**
  String get totalFabricCost;

  /// No description provided for @totalFabricPurchasedM.
  ///
  /// In en, this message translates to:
  /// **'Total Fabric Purchased (m)'**
  String get totalFabricPurchasedM;

  /// No description provided for @totalFloorArea.
  ///
  /// In en, this message translates to:
  /// **'Total Floor Area'**
  String get totalFloorArea;

  /// No description provided for @totalGstAmount.
  ///
  /// In en, this message translates to:
  /// **'Total GST Amount'**
  String get totalGstAmount;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalInterestPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Interest Paid'**
  String get totalInterestPaid;

  /// No description provided for @totalLength.
  ///
  /// In en, this message translates to:
  /// **'Total Length'**
  String get totalLength;

  /// No description provided for @totalLengthNeeded.
  ///
  /// In en, this message translates to:
  /// **'Total Length Needed'**
  String get totalLengthNeeded;

  /// No description provided for @totalMaterialCost.
  ///
  /// In en, this message translates to:
  /// **'Total Material Cost'**
  String get totalMaterialCost;

  /// No description provided for @totalMetersPurchased.
  ///
  /// In en, this message translates to:
  /// **'Total Meters Purchased'**
  String get totalMetersPurchased;

  /// No description provided for @totalMrp.
  ///
  /// In en, this message translates to:
  /// **'Total MRP'**
  String get totalMrp;

  /// No description provided for @totalNotesCount.
  ///
  /// In en, this message translates to:
  /// **'Total Notes Count'**
  String get totalNotesCount;

  /// No description provided for @totalPaintableArea.
  ///
  /// In en, this message translates to:
  /// **'Total Paintable Area'**
  String get totalPaintableArea;

  /// No description provided for @totalPriceInclMargin.
  ///
  /// In en, this message translates to:
  /// **'Total Price (Incl. Margin)'**
  String get totalPriceInclMargin;

  /// No description provided for @totalPurchased.
  ///
  /// In en, this message translates to:
  /// **'Total Purchased'**
  String get totalPurchased;

  /// No description provided for @totalRepayment.
  ///
  /// In en, this message translates to:
  /// **'Total Repayment'**
  String get totalRepayment;

  /// No description provided for @totalRepaymentIncDownPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Repayment (inc. down payment)'**
  String get totalRepaymentIncDownPayment;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @totalSavings.
  ///
  /// In en, this message translates to:
  /// **'Total Savings'**
  String get totalSavings;

  /// No description provided for @totalTabletsInBox.
  ///
  /// In en, this message translates to:
  /// **'Total Tablets in Box'**
  String get totalTabletsInBox;

  /// No description provided for @totalUnitsReturning.
  ///
  /// In en, this message translates to:
  /// **'Total Units Returning'**
  String get totalUnitsReturning;

  /// No description provided for @totalWetVolume.
  ///
  /// In en, this message translates to:
  /// **'Total Wet Volume'**
  String get totalWetVolume;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transportCost.
  ///
  /// In en, this message translates to:
  /// **'Transport Cost (₹)'**
  String get transportCost;

  /// No description provided for @typeOfWork.
  ///
  /// In en, this message translates to:
  /// **'Type of Work'**
  String get typeOfWork;

  /// No description provided for @unitPriceSetup.
  ///
  /// In en, this message translates to:
  /// **'Unit Price Setup'**
  String get unitPriceSetup;

  /// No description provided for @unitRatesSummary.
  ///
  /// In en, this message translates to:
  /// **'Unit Rates Summary'**
  String get unitRatesSummary;

  /// No description provided for @unitToConvertFrom.
  ///
  /// In en, this message translates to:
  /// **'Unit to Convert From'**
  String get unitToConvertFrom;

  /// No description provided for @useButtonsBelowToLogCreditGotOrDebitGave.
  ///
  /// In en, this message translates to:
  /// **'Use buttons below to log credit (Got) or debit (Gave).'**
  String get useButtonsBelowToLogCreditGotOrDebitGave;

  /// No description provided for @variableCostPerCup.
  ///
  /// In en, this message translates to:
  /// **'Variable Cost per Cup (₹)'**
  String get variableCostPerCup;

  /// No description provided for @volumeUnitType.
  ///
  /// In en, this message translates to:
  /// **'Volume Unit Type'**
  String get volumeUnitType;

  /// No description provided for @wallSurfaceAreaSqFt.
  ///
  /// In en, this message translates to:
  /// **'Wall Surface Area (sq ft)'**
  String get wallSurfaceAreaSqFt;

  /// No description provided for @warrantyGivenDays.
  ///
  /// In en, this message translates to:
  /// **'Warranty Given (Days)'**
  String get warrantyGivenDays;

  /// No description provided for @warrantyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Warranty Period'**
  String get warrantyPeriod;

  /// No description provided for @wastage.
  ///
  /// In en, this message translates to:
  /// **'Wastage %'**
  String get wastage;

  /// No description provided for @waterNeeded.
  ///
  /// In en, this message translates to:
  /// **'Water Needed'**
  String get waterNeeded;

  /// No description provided for @weightG.
  ///
  /// In en, this message translates to:
  /// **'Weight (g)'**
  String get weightG;

  /// No description provided for @weightGrams.
  ///
  /// In en, this message translates to:
  /// **'Weight (grams)'**
  String get weightGrams;

  /// No description provided for @weightConverter.
  ///
  /// In en, this message translates to:
  /// **'Weight Converter'**
  String get weightConverter;

  /// No description provided for @weightPerMeter.
  ///
  /// In en, this message translates to:
  /// **'Weight per Meter'**
  String get weightPerMeter;

  /// No description provided for @weightPerRod.
  ///
  /// In en, this message translates to:
  /// **'Weight per Rod'**
  String get weightPerRod;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @wholesalePrice.
  ///
  /// In en, this message translates to:
  /// **'Wholesale Price (₹)'**
  String get wholesalePrice;

  /// No description provided for @wholesaleProfit.
  ///
  /// In en, this message translates to:
  /// **'Wholesale Profit'**
  String get wholesaleProfit;

  /// No description provided for @workAreaSqFt.
  ///
  /// In en, this message translates to:
  /// **'Work Area (sq ft)'**
  String get workAreaSqFt;

  /// No description provided for @workCategory.
  ///
  /// In en, this message translates to:
  /// **'Work Category'**
  String get workCategory;

  /// No description provided for @workingDaysInMonth.
  ///
  /// In en, this message translates to:
  /// **'Working Days in Month'**
  String get workingDaysInMonth;

  /// No description provided for @yearDepreciationApplied.
  ///
  /// In en, this message translates to:
  /// **'Year Depreciation applied'**
  String get yearDepreciationApplied;

  /// No description provided for @youGave.
  ///
  /// In en, this message translates to:
  /// **'YOU GAVE'**
  String get youGave;

  /// No description provided for @youGot.
  ///
  /// In en, this message translates to:
  /// **'YOU GOT'**
  String get youGot;

  /// No description provided for @youWillGet.
  ///
  /// In en, this message translates to:
  /// **'You Will Get'**
  String get youWillGet;

  /// No description provided for @youWillGive.
  ///
  /// In en, this message translates to:
  /// **'You Will Give'**
  String get youWillGive;

  /// No description provided for @k1Amount.
  ///
  /// In en, this message translates to:
  /// **'₹1 Amount'**
  String get k1Amount;

  /// No description provided for @k1Coins.
  ///
  /// In en, this message translates to:
  /// **'₹1 Coins'**
  String get k1Coins;

  /// No description provided for @k10Amount.
  ///
  /// In en, this message translates to:
  /// **'₹10 Amount'**
  String get k10Amount;

  /// No description provided for @k100Amount.
  ///
  /// In en, this message translates to:
  /// **'₹100 Amount'**
  String get k100Amount;

  /// No description provided for @k100Notes.
  ///
  /// In en, this message translates to:
  /// **'₹100 Notes'**
  String get k100Notes;

  /// No description provided for @k2Amount.
  ///
  /// In en, this message translates to:
  /// **'₹2 Amount'**
  String get k2Amount;

  /// No description provided for @k2Coins.
  ///
  /// In en, this message translates to:
  /// **'₹2 Coins'**
  String get k2Coins;

  /// No description provided for @k20Amount.
  ///
  /// In en, this message translates to:
  /// **'₹20 Amount'**
  String get k20Amount;

  /// No description provided for @k20Notes.
  ///
  /// In en, this message translates to:
  /// **'₹20 Notes'**
  String get k20Notes;

  /// No description provided for @k200Amount.
  ///
  /// In en, this message translates to:
  /// **'₹200 Amount'**
  String get k200Amount;

  /// No description provided for @k200Notes.
  ///
  /// In en, this message translates to:
  /// **'₹200 Notes'**
  String get k200Notes;

  /// No description provided for @k5Amount.
  ///
  /// In en, this message translates to:
  /// **'₹5 Amount'**
  String get k5Amount;

  /// No description provided for @k50Amount.
  ///
  /// In en, this message translates to:
  /// **'₹50 Amount'**
  String get k50Amount;

  /// No description provided for @k50Notes.
  ///
  /// In en, this message translates to:
  /// **'₹50 Notes'**
  String get k50Notes;

  /// No description provided for @k500Amount.
  ///
  /// In en, this message translates to:
  /// **'₹500 Amount'**
  String get k500Amount;

  /// No description provided for @k500Notes.
  ///
  /// In en, this message translates to:
  /// **'₹500 Notes'**
  String get k500Notes;

  /// No description provided for @receivable.
  ///
  /// In en, this message translates to:
  /// **'Receivable'**
  String get receivable;

  /// No description provided for @payable.
  ///
  /// In en, this message translates to:
  /// **'Payable'**
  String get payable;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @pleaseEnterAnAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAnAmount;

  /// No description provided for @pleaseEnterAValidPositiveAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid positive amount'**
  String get pleaseEnterAValidPositiveAmount;

  /// No description provided for @txs.
  ///
  /// In en, this message translates to:
  /// **'txs'**
  String get txs;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @rental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get rental;

  /// No description provided for @cashback.
  ///
  /// In en, this message translates to:
  /// **'Cashback'**
  String get cashback;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @billsUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills/Utilities'**
  String get billsUtilities;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketing;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @noCustomersAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No customers added yet'**
  String get noCustomersAddedYet;

  /// No description provided for @noResultsMatchYourSearch.
  ///
  /// In en, this message translates to:
  /// **'No results match your search'**
  String get noResultsMatchYourSearch;

  /// No description provided for @tapAddCustomerToStartLoggingCreditEntries.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Add Customer\' to start logging credit entries.'**
  String get tapAddCustomerToStartLoggingCreditEntries;

  /// No description provided for @tryADifferentSearchQuery.
  ///
  /// In en, this message translates to:
  /// **'Try a different search query.'**
  String get tryADifferentSearchQuery;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhoneNumber;

  /// No description provided for @pleaseEnterAName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterAName;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @pleaseEnterAShopName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a shop name'**
  String get pleaseEnterAShopName;

  /// No description provided for @deleteShopConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{shopName}\'? All customer accounts and ledger transaction history under this shop will be permanently deleted.'**
  String deleteShopConfirmation(Object shopName);

  /// No description provided for @shopAndAccountsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Shop \'{shopName}\' and its accounts deleted'**
  String shopAndAccountsDeleted(Object shopName);

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entries;

  /// No description provided for @accountBalance.
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get accountBalance;

  /// No description provided for @outstandingReceivable.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Receivable'**
  String get outstandingReceivable;

  /// No description provided for @outstandingPayable.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Payable'**
  String get outstandingPayable;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @phoneDialerNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Phone dialer not available on this device / emulator. ({error})'**
  String phoneDialerNotAvailable(Object error);

  /// No description provided for @couldNotOpenSMSApp.
  ///
  /// In en, this message translates to:
  /// **'Could not open SMS application. ({error})'**
  String couldNotOpenSMSApp(Object error);

  /// No description provided for @couldNotLaunchWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Could not launch WhatsApp. ({error})'**
  String couldNotLaunchWhatsApp(Object error);

  /// No description provided for @gaveCredit.
  ///
  /// In en, this message translates to:
  /// **'Gave credit'**
  String get gaveCredit;

  /// No description provided for @gotPayment.
  ///
  /// In en, this message translates to:
  /// **'Got payment'**
  String get gotPayment;

  /// No description provided for @gave.
  ///
  /// In en, this message translates to:
  /// **'Gave'**
  String get gave;

  /// No description provided for @got.
  ///
  /// In en, this message translates to:
  /// **'Got'**
  String get got;

  /// No description provided for @recordYouGave.
  ///
  /// In en, this message translates to:
  /// **'Record You Gave (Debit)'**
  String get recordYouGave;

  /// No description provided for @recordYouGot.
  ///
  /// In en, this message translates to:
  /// **'Record You Got (Credit)'**
  String get recordYouGot;

  /// No description provided for @descHintGave.
  ///
  /// In en, this message translates to:
  /// **'e.g., Materials, Rice packet'**
  String get descHintGave;

  /// No description provided for @descHintGot.
  ///
  /// In en, this message translates to:
  /// **'e.g., Cash, Online Transfer'**
  String get descHintGot;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {accountName}? All of their ledger transaction history will be lost permanently.'**
  String deleteAccountConfirmation(Object accountName);

  /// No description provided for @reminderReceivableTemplate.
  ///
  /// In en, this message translates to:
  /// **'Dear {name},\n\nYour outstanding balance on {shopName} is ₹{amount}. Please settle this receivable soon.\n\nThank you!'**
  String reminderReceivableTemplate(
      Object amount, Object name, Object shopName);

  /// No description provided for @reminderPayableTemplate.
  ///
  /// In en, this message translates to:
  /// **'Dear {name},\n\nWe have a pending payable amount of ₹{amount} to you. We will settle it soon.\n\nThank you!'**
  String reminderPayableTemplate(Object amount, Object name);

  /// No description provided for @reminderSettledTemplate.
  ///
  /// In en, this message translates to:
  /// **'Dear {name},\n\nYour account is settled with {shopName}.\n\nThank you!'**
  String reminderSettledTemplate(Object name, Object shopName);

  /// No description provided for @redExpiryWarningCount.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) expiring in <60 days. '**
  String redExpiryWarningCount(Object count);

  /// No description provided for @yellowExpiryWarningCount.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) expiring in <90 days.'**
  String yellowExpiryWarningCount(Object count);

  /// No description provided for @pleaseEnterAValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid product/medicine name'**
  String get pleaseEnterAValidName;

  /// No description provided for @batchLabel.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get batchLabel;

  /// No description provided for @expiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get expiryLabel;

  /// No description provided for @daysLeftText.
  ///
  /// In en, this message translates to:
  /// **'{count} d left'**
  String daysLeftText(Object count);

  /// No description provided for @expiredText.
  ///
  /// In en, this message translates to:
  /// **'EXPIRED'**
  String get expiredText;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @overviewInsights.
  ///
  /// In en, this message translates to:
  /// **'Overview Insights'**
  String get overviewInsights;

  /// No description provided for @dayBookDailyPL.
  ///
  /// In en, this message translates to:
  /// **'Day Book / Daily P&L'**
  String get dayBookDailyPL;

  /// No description provided for @digitalLedgerKhata.
  ///
  /// In en, this message translates to:
  /// **'Digital Ledger / Khata'**
  String get digitalLedgerKhata;

  /// No description provided for @financialToolset.
  ///
  /// In en, this message translates to:
  /// **'Financial Toolset'**
  String get financialToolset;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @dailyPLAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Daily P&L Analytics'**
  String get dailyPLAnalytics;

  /// No description provided for @noPLDataYet.
  ///
  /// In en, this message translates to:
  /// **'No P&L data yet'**
  String get noPLDataYet;

  /// No description provided for @logYourDailyIncomeAndExpensesInTheDayBookTabToViewCharts.
  ///
  /// In en, this message translates to:
  /// **'Log your daily income and expenses in the Day Book tab to view charts.'**
  String get logYourDailyIncomeAndExpensesInTheDayBookTabToViewCharts;

  /// No description provided for @ledgerInsights.
  ///
  /// In en, this message translates to:
  /// **'Ledger Insights'**
  String get ledgerInsights;

  /// No description provided for @noLedgerAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No Ledger accounts yet'**
  String get noLedgerAccountsYet;

  /// No description provided for @addCustomersOrVendorsInTheLedgerTabToTrackCreditsAndOutstandingBalances.
  ///
  /// In en, this message translates to:
  /// **'Add customers or vendors in the Ledger tab to track credits and outstanding balances.'**
  String
      get addCustomersOrVendorsInTheLedgerTabToTrackCreditsAndOutstandingBalances;

  /// No description provided for @receivablesGet.
  ///
  /// In en, this message translates to:
  /// **'Receivables (Get)'**
  String get receivablesGet;

  /// No description provided for @payablesGive.
  ///
  /// In en, this message translates to:
  /// **'Payables (Give)'**
  String get payablesGive;

  /// No description provided for @outstandingReceivables.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Receivables'**
  String get outstandingReceivables;

  /// No description provided for @outstandingPayables.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Payables'**
  String get outstandingPayables;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
