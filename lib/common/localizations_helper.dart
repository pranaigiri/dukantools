import 'package:flutter/material.dart';
import 'package:dukan_tools/l10n/app_localizations.dart';

class LocalizationsHelper {
  static String translate(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return value;

    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'hi') {
      final hindiVal = _hindiMap[value.trim()];
      if (hindiVal != null) return hindiVal;
    }


    // Normalize the string to find its camelCase key
    final clean = value.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').trim();
    final words = clean.split(RegExp(r'\s+'));
    if (words.isEmpty) return value;

    final first = words[0].toLowerCase();
    final rest = words.skip(1).map((w) {
      if (w.isEmpty) return '';
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join('');

    var key = '$first$rest';
    if (RegExp(r'^\d').hasMatch(key)) {
      key = 'k$key';
    }

    switch (key) {
      case 'k000': return l10n.k000;
      case 'k10lCanSize': return l10n.k10lCanSize;
      case 'k1lCanSize': return l10n.k1lCanSize;
      case 'k4lCanSize': return l10n.k4lCanSize;
      case 'about': return l10n.about;
      case 'aboutUs': return l10n.aboutUs;
      case 'accessory1Cost': return l10n.accessory1Cost;
      case 'accessory2Cost': return l10n.accessory2Cost;
      case 'accessory3Cost': return l10n.accessory3Cost;
      case 'accessoryType': return l10n.accessoryType;
      case 'accountDeletedSuccessfully': return l10n.accountDeletedSuccessfully;
      case 'accountDetails': return l10n.accountDetails;
      case 'accountIsSettledNoReminderNeeded': return l10n.accountIsSettledNoReminderNeeded;
      case 'accountNotFound': return l10n.accountNotFound;
      case 'activePurchaseDays': return l10n.activePurchaseDays;
      case 'activeShop': return l10n.activeShop;
      case 'actualMargin': return l10n.actualMargin;
      case 'add': return l10n.add;
      case 'addCustomer': return l10n.addCustomer;
      case 'addNewCustomerAccount': return l10n.addNewCustomerAccount;
      case 'addShop': return l10n.addShop;
      case 'addTransaction': return l10n.addTransaction;
      case 'ageOfPhoneYears': return l10n.ageOfPhoneYears;
      case 'aggregateQuantity': return l10n.aggregateQuantity;
      case 'allInOneGoodsFinanceCalculator': return l10n.allInOneGoodsFinanceCalculator;
      case 'amount': return l10n.amount;
      case 'approxGravelBrass': return l10n.approxGravelBrass;
      case 'approxSandBrass1Brass100CuFt': return l10n.approxSandBrass1Brass100CuFt;
      case 'areaLengthFt': return l10n.areaLengthFt;
      case 'areaToCoverSqFt': return l10n.areaToCoverSqFt;
      case 'areaWidthFt': return l10n.areaWidthFt;
      case 'averageCupsPerDay': return l10n.averageCupsPerDay;
      case 'averageDailyPurchaseSpend': return l10n.averageDailyPurchaseSpend;
      case 'averageDistancePerPointFt': return l10n.averageDistancePerPointFt;
      case 'averageValueEstimate': return l10n.averageValueEstimate;
      case 'baseFabricCost': return l10n.baseFabricCost;
      case 'baseItemPrice': return l10n.baseItemPrice;
      case 'basePrice': return l10n.basePrice;
      case 'baseSareePrice': return l10n.baseSareePrice;
      case 'baseTeaCost': return l10n.baseTeaCost;
      case 'batchNumber': return l10n.batchNumber;
      case 'billDate': return l10n.billDate;
      case 'billingHourlyRate': return l10n.billingHourlyRate;
      case 'blouseCutRequirementM': return l10n.blouseCutRequirementM;
      case 'blouseFabricCost': return l10n.blouseFabricCost;
      case 'blouseLengthCut': return l10n.blouseLengthCut;
      case 'boxPriceAtPtr': return l10n.boxPriceAtPtr;
      case 'boxesToPurchase': return l10n.boxesToPurchase;
      case 'brandACostPrice': return l10n.brandACostPrice;
      case 'brandAName': return l10n.brandAName;
      case 'brandASellingPrice': return l10n.brandASellingPrice;
      case 'brandBCostPrice': return l10n.brandBCostPrice;
      case 'brandBName': return l10n.brandBName;
      case 'brandBSellingPrice': return l10n.brandBSellingPrice;
      case 'bulkPackPrice': return l10n.bulkPackPrice;
      case 'bulkSavingsCalculator': return l10n.bulkSavingsCalculator;
      case 'buyPrice': return l10n.buyPrice;
      case 'calculateDiscount': return l10n.calculateDiscount;
      case 'calculatedWeightG': return l10n.calculatedWeightG;
      case 'calculationType': return l10n.calculationType;
      case 'calculators': return l10n.calculators;
      case 'callDial': return l10n.callDial;
      case 'cancel': return l10n.cancel;
      case 'cashFlowLast7Days': return l10n.cashFlowLast7Days;
      case 'cashNetMargin': return l10n.cashNetMargin;
      case 'category': return l10n.category;
      case 'cgstHalf': return l10n.cgstHalf;
      case 'close': return l10n.close;
      case 'compact': return l10n.compact;
      case 'concreteMixRatio': return l10n.concreteMixRatio;
      case 'concreteVolume': return l10n.concreteVolume;
      case 'conditionOfPhone': return l10n.conditionOfPhone;
      case 'contractedArea': return l10n.contractedArea;
      case 'conversionFactor': return l10n.conversionFactor;
      case 'convertedValue': return l10n.convertedValue;
      case 'copyAndSendThisMessageToTheCustomer': return l10n.copyAndSendThisMessageToTheCustomer;
      case 'copyText': return l10n.copyText;
      case 'costFor5Meters': return l10n.costFor5Meters;
      case 'costFor6MetersStandardSaree': return l10n.costFor6MetersStandardSaree;
      case 'costPerStrip': return l10n.costPerStrip;
      case 'costPrice': return l10n.costPrice;
      case 'coverageSqFtPerKg': return l10n.coverageSqFtPerKg;
      case 'coverageRate': return l10n.coverageRate;
      case 'create': return l10n.create;
      case 'createNewShop': return l10n.createNewShop;
      case 'creditDaysAllowed': return l10n.creditDaysAllowed;
      case 'criticalExpiryWarning': return l10n.criticalExpiryWarning;
      case 'cupsSoldPerDay': return l10n.cupsSoldPerDay;
      case 'cupsToHitTargetProfit': return l10n.cupsToHitTargetProfit;
      case 'currentLevel': return l10n.currentLevel;
      case 'currentStock': return l10n.currentStock;
      case 'customTaxRate': return l10n.customTaxRate;
      case 'customerComboSavings': return l10n.customerComboSavings;
      case 'customerQuotedPrice': return l10n.customerQuotedPrice;
      case 'cylinderCost': return l10n.cylinderCost;
      case 'dailyBook': return l10n.dailyBook;
      case 'dailyBurnRate': return l10n.dailyBurnRate;
      case 'dailyFuelCost': return l10n.dailyFuelCost;
      case 'dailyPurchaseRate': return l10n.dailyPurchaseRate;
      case 'dailyRevenueAtBreakeven': return l10n.dailyRevenueAtBreakeven;
      case 'dayBook': return l10n.dayBook;
      case 'daysCylinderLasts': return l10n.daysCylinderLasts;
      case 'delete': return l10n.delete;
      case 'deleteAccount': return l10n.deleteAccount;
      case 'deleteShop': return l10n.deleteShop;
      case 'description': return l10n.description;
      case 'desiredPrice': return l10n.desiredPrice;
      case 'developedBy': return l10n.developedBy;
      case 'digitalCashDrawer': return l10n.digitalCashDrawer;
      case 'dineinMargin': return l10n.dineinMargin;
      case 'dineinPrice': return l10n.dineinPrice;
      case 'discount': return l10n.discount;
      case 'discountPerItem': return l10n.discountPerItem;
      case 'discountRate': return l10n.discountRate;
      case 'displayFolderCost': return l10n.displayFolderCost;
      case 'displayQualityType': return l10n.displayQualityType;
      case 'downPayment': return l10n.downPayment;
      case 'dueDate': return l10n.dueDate;
      case 'dukanTools': return l10n.dukanTools;
      case 'dynamicCalculationConverter': return l10n.dynamicCalculationConverter;
      case 'earnedProfit': return l10n.earnedProfit;
      case 'edit': return l10n.edit;
      case 'editCustomerProfile': return l10n.editCustomerProfile;
      case 'embroideryCharges': return l10n.embroideryCharges;
      case 'emiCalculator': return l10n.emiCalculator;
      case 'emiNetMargin': return l10n.emiNetMargin;
      case 'enterAmount': return l10n.enterAmount;
      case 'enterLoanAmount': return l10n.enterLoanAmount;
      case 'enterOriginalPrice': return l10n.enterOriginalPrice;
      case 'enterPrincipalAmount': return l10n.enterPrincipalAmount;
      case 'enterValue': return l10n.enterValue;
      case 'entryRemoved': return l10n.entryRemoved;
      case 'errorLoadingVersion': return l10n.errorLoadingVersion;
      case 'exchangeRate': return l10n.exchangeRate;
      case 'exclusiveAddGst': return l10n.exclusiveAddGst;
      case 'expectedCupsToSell': return l10n.expectedCupsToSell;
      case 'expectedRevenuePace': return l10n.expectedRevenuePace;
      case 'expectedRunoutDate': return l10n.expectedRunoutDate;
      case 'expectedWastage': return l10n.expectedWastage;
      case 'expensePaid': return l10n.expensePaid;
      case 'expiryDate': return l10n.expiryDate;
      case 'expiryEntrySavedSuccessfully': return l10n.expiryEntrySavedSuccessfully;
      case 'fabricCostShare': return l10n.fabricCostShare;
      case 'fabricRatePerMeter': return l10n.fabricRatePerMeter;
      case 'fabricValue': return l10n.fabricValue;
      case 'fallCost': return l10n.fallCost;
      case 'finalCustomQuote': return l10n.finalCustomQuote;
      case 'finalPriceAfterDiscount': return l10n.finalPriceAfterDiscount;
      case 'fittingLaborCost': return l10n.fittingLaborCost;
      case 'fixedCostsPerDay': return l10n.fixedCostsPerDay;
      case 'flatAmount': return l10n.flatAmount;
      case 'from': return l10n.from;
      case 'gasCostPerDay': return l10n.gasCostPerDay;
      case 'gstSlab': return l10n.gstSlab;
      case 'gstTaxCalculator': return l10n.gstTaxCalculator;
      case 'inclusiveSplitGst': return l10n.inclusiveSplitGst;
      case 'incomeGot': return l10n.incomeGot;
      case 'initialConditionFactor': return l10n.initialConditionFactor;
      case 'interestCalculator': return l10n.interestCalculator;
      case 'interestEarnedSi': return l10n.interestEarnedSi;
      case 'interestRatePa': return l10n.interestRatePa;
      case 'interestRate': return l10n.interestRate;
      case 'interestType': return l10n.interestType;
      case 'itemName': return l10n.itemName;
      case 'itemPrice': return l10n.itemPrice;
      case 'laborCost': return l10n.laborCost;
      case 'laborCostPerDay': return l10n.laborCostPerDay;
      case 'laborDuration': return l10n.laborDuration;
      case 'labourRatePerSqFt': return l10n.labourRatePerSqFt;
      case 'laceLengthUsedM': return l10n.laceLengthUsedM;
      case 'laceMaterialCost': return l10n.laceMaterialCost;
      case 'laceRatePerMeter': return l10n.laceRatePerMeter;
      case 'lastUpdatedRates': return l10n.lastUpdatedRates;
      case 'ledger': return l10n.ledger;
      case 'ledgerBalanceRatio': return l10n.ledgerBalanceRatio;
      case 'lengthPerRodMeters': return l10n.lengthPerRodMeters;
      case 'loadedProductionCost': return l10n.loadedProductionCost;
      case 'loadingSponsoredSpace': return l10n.loadingSponsoredSpace;
      case 'loanAmount': return l10n.loanAmount;
      case 'lotTotalCost': return l10n.lotTotalCost;
      case 'manageShops': return l10n.manageShops;
      case 'margin': return l10n.margin;
      case 'marginCalculator': return l10n.marginCalculator;
      case 'marginDiff': return l10n.marginDiff;
      case 'marginMode': return l10n.marginMode;
      case 'marginPerItem': return l10n.marginPerItem;
      case 'marginPercentage': return l10n.marginPercentage;
      case 'marginSet': return l10n.marginSet;
      case 'medicineName': return l10n.medicineName;
      case 'metersNeeded': return l10n.metersNeeded;
      case 'milkCostPerLiter': return l10n.milkCostPerLiter;
      case 'milkNeeded': return l10n.milkNeeded;
      case 'milkPerCupMl': return l10n.milkPerCupMl;
      case 'minSellingPriceBreakeven': return l10n.minSellingPriceBreakeven;
      case 'minimumThreshold': return l10n.minimumThreshold;
      case 'monthlyEmiAmount': return l10n.monthlyEmiAmount;
      case 'monthlyOverview': return l10n.monthlyOverview;
      case 'monthlyRevenueTarget': return l10n.monthlyRevenueTarget;
      case 'mrp': return l10n.mrp;
      case 'mrpPerItem': return l10n.mrpPerItem;
      case 'name': return l10n.name;
      case 'netBalance': return l10n.netBalance;
      case 'netDayBookBalance': return l10n.netDayBookBalance;
      case 'netDistanceNeeded': return l10n.netDistanceNeeded;
      case 'netMilkNeeded': return l10n.netMilkNeeded;
      case 'netPrincipalLoaned': return l10n.netPrincipalLoaned;
      case 'netProfitMargin': return l10n.netProfitMargin;
      case 'newShop': return l10n.newShop;
      case 'newShopName': return l10n.newShopName;
      case 'nextRefreshSchedule': return l10n.nextRefreshSchedule;
      case 'noEntriesForThisDay': return l10n.noEntriesForThisDay;
      case 'noEntriesRecordedYet': return l10n.noEntriesRecordedYet;
      case 'noPhoneNumberRegistered': return l10n.noPhoneNumberRegistered;
      case 'noTransactionsLoggedYet': return l10n.noTransactionsLoggedYet;
      case 'noTransactionsRecordedYet': return l10n.noTransactionsRecordedYet;
      case 'numberOfCoats': return l10n.numberOfCoats;
      case 'numberOfConnectionPoints': return l10n.numberOfConnectionPoints;
      case 'numberOfCups': return l10n.numberOfCups;
      case 'numberOfPiecesInLot': return l10n.numberOfPiecesInLot;
      case 'numberOfRods': return l10n.numberOfRods;
      case 'offlineManualConversion': return l10n.offlineManualConversion;
      case 'originalLength': return l10n.originalLength;
      case 'originalMrpOfOldPhone': return l10n.originalMrpOfOldPhone;
      case 'originalPrice': return l10n.originalPrice;
      case 'otherWorkStonesBeads': return l10n.otherWorkStonesBeads;
      case 'overheadCostPerCup': return l10n.overheadCostPerCup;
      case 'overview': return l10n.overview;
      case 'overviewDashboard': return l10n.overviewDashboard;
      case 'packQuantityItems': return l10n.packQuantityItems;
      case 'packagingCost': return l10n.packagingCost;
      case 'perMonth': return l10n.perMonth;
      case 'percent': return l10n.percent;
      case 'phoneOptional': return l10n.phoneOptional;
      case 'phoneCost': return l10n.phoneCost;
      case 'phoneCostPrice': return l10n.phoneCostPrice;
      case 'phoneNumber': return l10n.phoneNumber;
      case 'phonePrice': return l10n.phonePrice;
      case 'phoneSellingPrice': return l10n.phoneSellingPrice;
      case 'pleaseSelectAnExpiryDate': return l10n.pleaseSelectAnExpiryDate;
      case 'popularPairs': return l10n.popularPairs;
      case 'pranaiGiriTheDesignerSikkim': return l10n.pranaiGiriTheDesignerSikkim;
      case 'prevMonth': return l10n.prevMonth;
      case 'principalAmount': return l10n.principalAmount;
      case 'principalLoanAmount': return l10n.principalLoanAmount;
      case 'processingFeeCommission': return l10n.processingFeeCommission;
      case 'productName': return l10n.productName;
      case 'profitAmount': return l10n.profitAmount;
      case 'profitCalculator': return l10n.profitCalculator;
      case 'profitDifference': return l10n.profitDifference;
      case 'profitEarned': return l10n.profitEarned;
      case 'profitMarginAmount': return l10n.profitMarginAmount;
      case 'profitMarginPerCup': return l10n.profitMarginPerCup;
      case 'profitMarginPercentage': return l10n.profitMarginPercentage;
      case 'profitPerPiece': return l10n.profitPerPiece;
      case 'profitPercentage': return l10n.profitPercentage;
      case 'ptrDiscountFromMrp': return l10n.ptrDiscountFromMrp;
      case 'ptrPerUnit': return l10n.ptrPerUnit;
      case 'ptrPricePerUnit': return l10n.ptrPricePerUnit;
      case 'ptsDiscountFromPtr': return l10n.ptsDiscountFromPtr;
      case 'quantity': return l10n.quantity;
      case 'quantityOptional': return l10n.quantityOptional;
      case 'quantityPurchased': return l10n.quantityPurchased;
      case 'quantityReceived': return l10n.quantityReceived;
      case 'quantitySold': return l10n.quantitySold;
      case 'quantityToReturn': return l10n.quantityToReturn;
      case 'rateContract': return l10n.rateContract;
      case 'rateOfInterestPa': return l10n.rateOfInterestPa;
      case 'ratePer100g': return l10n.ratePer100g;
      case 'ratePerGram': return l10n.ratePerGram;
      case 'ratePerKg': return l10n.ratePerKg;
      case 'ratePerSheet': return l10n.ratePerSheet;
      case 'rawCostTotal': return l10n.rawCostTotal;
      case 'receivedCount': return l10n.receivedCount;
      case 'remainingDays': return l10n.remainingDays;
      case 'remainingTarget': return l10n.remainingTarget;
      case 'reminderCopiedToClipboard': return l10n.reminderCopiedToClipboard;
      case 'renameShop': return l10n.renameShop;
      case 'reset': return l10n.reset;
      case 'retailPrice': return l10n.retailPrice;
      case 'retailProfit': return l10n.retailProfit;
      case 'retailerMargin': return l10n.retailerMargin;
      case 'revenueEarnedSoFar': return l10n.revenueEarnedSoFar;
      case 'rodDiameterMm': return l10n.rodDiameterMm;
      case 'roomHeightFt': return l10n.roomHeightFt;
      case 'roomLengthFt': return l10n.roomLengthFt;
      case 'roomWidthFt': return l10n.roomWidthFt;
      case 'salesCategory': return l10n.salesCategory;
      case 'salesComparisonMonthonmonth': return l10n.salesComparisonMonthonmonth;
      case 'sandQuantity': return l10n.sandQuantity;
      case 'save': return l10n.save;
      case 'saveToExpiryLog': return l10n.saveToExpiryLog;
      case 'savedExpiryLog': return l10n.savedExpiryLog;
      case 'savingsAmount': return l10n.savingsAmount;
      case 'scrapFabric': return l10n.scrapFabric;
      case 'searchCustomerOrPhone': return l10n.searchCustomerOrPhone;
      case 'sellPrice': return l10n.sellPrice;
      case 'sellingPrice': return l10n.sellingPrice;
      case 'sellingPricePerCup': return l10n.sellingPricePerCup;
      case 'sellingPricePerPiece': return l10n.sellingPricePerPiece;
      case 'setCustomExchangeRate': return l10n.setCustomExchangeRate;
      case 'sgstHalf': return l10n.sgstHalf;
      case 'share': return l10n.share;
      case 'shareBalanceReminder': return l10n.shareBalanceReminder;
      case 'shareReminder': return l10n.shareReminder;
      case 'sheetDimensionSize': return l10n.sheetDimensionSize;
      case 'shopName': return l10n.shopName;
      case 'shortageQuantity': return l10n.shortageQuantity;
      case 'singleItemPrice': return l10n.singleItemPrice;
      case 'singleSheetCover': return l10n.singleSheetCover;
      case 'singleTileSize': return l10n.singleTileSize;
      case 'smsShare': return l10n.smsShare;
      case 'snackCostPrice': return l10n.snackCostPrice;
      case 'snackSellingPrice': return l10n.snackSellingPrice;
      case 'soldCount': return l10n.soldCount;
      case 'sourceUnit': return l10n.sourceUnit;
      case 'sparePartCost': return l10n.sparePartCost;
      case 'spreadDiffRetailWholesale': return l10n.spreadDiffRetailWholesale;
      case 'standard': return l10n.standard;
      case 'standard10ftPipesCount': return l10n.standard10ftPipesCount;
      case 'standardGstSlabs': return l10n.standardGstSlabs;
      case 'standardSeparateCost': return l10n.standardSeparateCost;
      case 'stockistMargin': return l10n.stockistMargin;
      case 'stripsPerBox': return l10n.stripsPerBox;
      case 'subtract': return l10n.subtract;
      case 'sugarCostPerKg': return l10n.sugarCostPerKg;
      case 'sugarNeeded': return l10n.sugarNeeded;
      case 'suggestedQuote35Margin': return l10n.suggestedQuote35Margin;
      case 'suggestedSellingPrice30Margin': return l10n.suggestedSellingPrice30Margin;
      case 'switchShop': return l10n.switchShop;
      case 'tabletsPerStrip': return l10n.tabletsPerStrip;
      case 'takeawayMargin': return l10n.takeawayMargin;
      case 'takeawayPrice': return l10n.takeawayPrice;
      case 'tallyReportCopiedToClipboard': return l10n.tallyReportCopiedToClipboard;
      case 'tapAddTransactionToLogCashFlow': return l10n.tapAddTransactionToLogCashFlow;
      case 'targetComboMargin': return l10n.targetComboMargin;
      case 'targetMargin': return l10n.targetMargin;
      case 'targetProfitPerDay': return l10n.targetProfitPerDay;
      case 'targetTrackerStatus': return l10n.targetTrackerStatus;
      case 'targetUnit': return l10n.targetUnit;
      case 'teaLeavesCostPer100g': return l10n.teaLeavesCostPer100g;
      case 'teaLeavesNeeded': return l10n.teaLeavesNeeded;
      case 'tenureMonths': return l10n.tenureMonths;
      case 'thicknessFt': return l10n.thicknessFt;
      case 'thisMonth': return l10n.thisMonth;
      case 'thisToolIsDevelopedForTheShopownersToHelpThemOnTheirDailyCalculationTasks': return l10n.thisToolIsDevelopedForTheShopownersToHelpThemOnTheirDailyCalculationTasks;
      case 'thresholdLevel': return l10n.thresholdLevel;
      case 'tileLengthInches': return l10n.tileLengthInches;
      case 'tileWidthInches': return l10n.tileWidthInches;
      case 'tilesPerBox': return l10n.tilesPerBox;
      case 'timePeriod': return l10n.timePeriod;
      case 'timePeriodEquivalent': return l10n.timePeriodEquivalent;
      case 'timePeriodUnit': return l10n.timePeriodUnit;
      case 'timeTakenMinutes': return l10n.timeTakenMinutes;
      case 'to': return l10n.to;
      case 'topActiveAccounts': return l10n.topActiveAccounts;
      case 'totalAreaWithWastage': return l10n.totalAreaWithWastage;
      case 'totalBatchCost': return l10n.totalBatchCost;
      case 'totalChainMargin': return l10n.totalChainMargin;
      case 'totalCoinsCount': return l10n.totalCoinsCount;
      case 'totalComboCostPrice': return l10n.totalComboCostPrice;
      case 'totalCostCp': return l10n.totalCostCp;
      case 'totalCostPriceCp': return l10n.totalCostPriceCp;
      case 'totalCupsBoiledPerCylinder': return l10n.totalCupsBoiledPerCylinder;
      case 'totalDaysInMonth': return l10n.totalDaysInMonth;
      case 'totalExpectedRevenue': return l10n.totalExpectedRevenue;
      case 'totalExpense': return l10n.totalExpense;
      case 'totalFabricCost': return l10n.totalFabricCost;
      case 'totalFabricPurchasedM': return l10n.totalFabricPurchasedM;
      case 'totalFloorArea': return l10n.totalFloorArea;
      case 'totalGstAmount': return l10n.totalGstAmount;
      case 'totalIncome': return l10n.totalIncome;
      case 'totalInterestPaid': return l10n.totalInterestPaid;
      case 'totalLength': return l10n.totalLength;
      case 'totalLengthNeeded': return l10n.totalLengthNeeded;
      case 'totalMaterialCost': return l10n.totalMaterialCost;
      case 'totalMetersPurchased': return l10n.totalMetersPurchased;
      case 'totalMrp': return l10n.totalMrp;
      case 'totalNotesCount': return l10n.totalNotesCount;
      case 'totalPaintableArea': return l10n.totalPaintableArea;
      case 'totalPriceInclMargin': return l10n.totalPriceInclMargin;
      case 'totalPurchased': return l10n.totalPurchased;
      case 'totalRepayment': return l10n.totalRepayment;
      case 'totalRepaymentIncDownPayment': return l10n.totalRepaymentIncDownPayment;
      case 'totalRevenue': return l10n.totalRevenue;
      case 'totalSavings': return l10n.totalSavings;
      case 'totalTabletsInBox': return l10n.totalTabletsInBox;
      case 'totalUnitsReturning': return l10n.totalUnitsReturning;
      case 'totalWetVolume': return l10n.totalWetVolume;
      case 'transactionDeleted': return l10n.transactionDeleted;
      case 'transactionHistory': return l10n.transactionHistory;
      case 'transactions': return l10n.transactions;
      case 'transportCost': return l10n.transportCost;
      case 'typeOfWork': return l10n.typeOfWork;
      case 'unitPriceSetup': return l10n.unitPriceSetup;
      case 'unitRatesSummary': return l10n.unitRatesSummary;
      case 'unitToConvertFrom': return l10n.unitToConvertFrom;
      case 'useButtonsBelowToLogCreditGotOrDebitGave': return l10n.useButtonsBelowToLogCreditGotOrDebitGave;
      case 'variableCostPerCup': return l10n.variableCostPerCup;
      case 'volumeUnitType': return l10n.volumeUnitType;
      case 'wallSurfaceAreaSqFt': return l10n.wallSurfaceAreaSqFt;
      case 'warrantyGivenDays': return l10n.warrantyGivenDays;
      case 'warrantyPeriod': return l10n.warrantyPeriod;
      case 'wastage': return l10n.wastage;
      case 'waterNeeded': return l10n.waterNeeded;
      case 'weightG': return l10n.weightG;
      case 'weightGrams': return l10n.weightGrams;
      case 'weightConverter': return l10n.weightConverter;
      case 'weightPerMeter': return l10n.weightPerMeter;
      case 'weightPerRod': return l10n.weightPerRod;
      case 'whatsapp': return l10n.whatsapp;
      case 'wholesalePrice': return l10n.wholesalePrice;
      case 'wholesaleProfit': return l10n.wholesaleProfit;
      case 'workAreaSqFt': return l10n.workAreaSqFt;
      case 'workCategory': return l10n.workCategory;
      case 'workingDaysInMonth': return l10n.workingDaysInMonth;
      case 'yearDepreciationApplied': return l10n.yearDepreciationApplied;
      case 'youGave': return l10n.youGave;
      case 'youGot': return l10n.youGot;
      case 'youWillGet': return l10n.youWillGet;
      case 'youWillGive': return l10n.youWillGive;
      case 'k1Amount': return l10n.k1Amount;
      case 'k1Coins': return l10n.k1Coins;
      case 'k10Amount': return l10n.k10Amount;
      case 'k100Amount': return l10n.k100Amount;
      case 'k100Notes': return l10n.k100Notes;
      case 'k2Amount': return l10n.k2Amount;
      case 'k2Coins': return l10n.k2Coins;
      case 'k20Amount': return l10n.k20Amount;
      case 'k20Notes': return l10n.k20Notes;
      case 'k200Amount': return l10n.k200Amount;
      case 'k200Notes': return l10n.k200Notes;
      case 'k5Amount': return l10n.k5Amount;
      case 'k50Amount': return l10n.k50Amount;
      case 'k50Notes': return l10n.k50Notes;
      case 'k500Amount': return l10n.k500Amount;
      case 'k500Notes': return l10n.k500Notes;
      case 'all': return l10n.all;
      case 'income': return l10n.income;
      case 'expense': return l10n.expense;
      case 'netProfit': return l10n.netProfit;
      case 'pleaseEnterAnAmount': return l10n.pleaseEnterAnAmount;
      case 'pleaseEnterAValidPositiveAmount': return l10n.pleaseEnterAValidPositiveAmount;
      case 'txs': return l10n.txs;
      case 'date': return l10n.date;
      case 'sales': return l10n.sales;
      case 'services': return l10n.services;
      case 'interest': return l10n.interest;
      case 'rental': return l10n.rental;
      case 'cashback': return l10n.cashback;
      case 'others': return l10n.others;
      case 'purchase': return l10n.purchase;
      case 'rent': return l10n.rent;
      case 'salary': return l10n.salary;
      case 'billsUtilities': return l10n.billsUtilities;
      case 'travel': return l10n.travel;
      case 'food': return l10n.food;
      case 'marketing': return l10n.marketing;
      case 'noDescription': return l10n.noDescription;
      case 'noCustomersAddedYet': return l10n.noCustomersAddedYet;
      case 'noResultsMatchYourSearch': return l10n.noResultsMatchYourSearch;
      case 'tapAddCustomerToStartLoggingCreditEntries': return l10n.tapAddCustomerToStartLoggingCreditEntries;
      case 'tryADifferentSearchQuery': return l10n.tryADifferentSearchQuery;
      case 'settled': return l10n.settled;
      case 'noPhoneNumber': return l10n.noPhoneNumber;
      case 'pleaseEnterAName': return l10n.pleaseEnterAName;
      case 'addButton': return l10n.addButton;
      case 'pleaseEnterAShopName': return l10n.pleaseEnterAShopName;
      case 'entries': return l10n.entries;
      case 'accountBalance': return l10n.accountBalance;
      case 'outstandingReceivable': return l10n.outstandingReceivable;
      case 'outstandingPayable': return l10n.outstandingPayable;
      case 'contact': return l10n.contact;
      case 'gaveCredit': return l10n.gaveCredit;
      case 'gotPayment': return l10n.gotPayment;
      case 'gave': return l10n.gave;
      case 'got': return l10n.got;
      case 'recordYouGave': return l10n.recordYouGave;
      case 'recordYouGot': return l10n.recordYouGot;
      case 'descHintGave': return l10n.descHintGave;
      case 'descHintGot': return l10n.descHintGot;
      case 'pleaseEnterAValidProductmedicineName': return l10n.pleaseEnterAValidName;
      case 'batch': return l10n.batchLabel;
      case 'expiry': return l10n.expiryLabel;
      case 'expired': return l10n.expiredText;
      case 'selectDate': return l10n.selectDate;
      case 'version': return l10n.version;
      case 'overviewInsights': return l10n.overviewInsights;
      case 'dayBookDailyPL': return l10n.dayBookDailyPL;
      case 'digitalLedgerKhata': return l10n.digitalLedgerKhata;
      case 'financialToolset': return l10n.financialToolset;
      case 'selectLanguage': return l10n.selectLanguage;
      case 'dailyPLAnalytics': return l10n.dailyPLAnalytics;
      case 'noPLDataYet': return l10n.noPLDataYet;
      case 'logYourDailyIncomeAndExpensesInTheDayBookTabToViewCharts': return l10n.logYourDailyIncomeAndExpensesInTheDayBookTabToViewCharts;
      case 'ledgerInsights': return l10n.ledgerInsights;
      case 'noLedgerAccountsYet': return l10n.noLedgerAccountsYet;
      case 'addCustomersOrVendorsInTheLedgerTabToTrackCreditsAndOutstandingBalances': return l10n.addCustomersOrVendorsInTheLedgerTabToTrackCreditsAndOutstandingBalances;
      case 'receivablesGet': return l10n.receivablesGet;
      case 'payablesGive': return l10n.payablesGive;
      case 'outstandingReceivables': return l10n.outstandingReceivables;
      case 'outstandingPayables': return l10n.outstandingPayables;
      default:
        return value;
    }
  }

  static const Map<String, String> _hindiMap = {
    // Categories
    'All': 'सभी',
    'General Kirana': 'सामान्य किराना',
    'Chai Shop': 'चाय की दुकान',
    'Saree/Cloth': 'साड़ी/कपड़ा',
    'Medical': 'मेडिकल',
    'Hardware': 'हार्डवेयर',
    'Mobile': 'मोबाइल',
    'Others': 'अन्य',

    // Tool Names
    'Yard to Meter Converter': 'यार्ड से मीटर कनवर्टर',
    'Saree Cost Calculator': 'साड़ी लागत कैलकुलेटर',
    'Blouse Fabric Left': 'ब्लाउज का बचा हुआ कपड़ा',
    'Fabric Wastage': 'कपड़े की बर्बादी',
    'Per Meter Rate Finder': 'प्रति मीटर दर खोजक',
    'Dress Material Costing': 'ड्रेस मटेरियल लागत',
    'Lace / Border Add-on': 'लेस / बॉर्डर जोड़ें',
    'Lot Per Piece Cost': 'लॉट प्रति पीस लागत',
    'Embroidery Pricing': 'कढ़ाई मूल्य निर्धारण',
    'Interest Calculator': 'ब्याज कैलकुलेटर',
    'Gram or Price': 'ग्राम या मूल्य',
    'Currency Converter': 'मुद्रा परिवर्तक',
    'EMI Calculator': 'ईएमआई कैलकुलेटर',
    'EMI Scheme Margin': 'ईएमआई योजना मार्जिन',
    'Accessory Margin': 'एक्सेसरी मार्जिन',
    'Phone Exchange Value': 'फ़ोन एक्सचेंज मूल्य',
    'Repair Job Margin': 'मरम्मत कार्य मार्जिन',
    'Screen Replacement Quote': 'स्क्रीन रिप्लेसमेंट कोट',
    'Bundle Deal Pricing': 'बंडल डील मूल्य निर्धारण',
    'Sales Target Tracker': 'बिक्री लक्ष्य ट्रैकर',
    'Service Charge Calculator': 'सेवा शुल्क कैलकुलेटर',
    'Expiry Tracker': 'एक्सपायरी ट्रैकर',
    'MRP vs PTR vs PTS': 'MRP बनाम PTR बनाम PTS',
    'Strip & Tablet Unit Cost': 'स्ट्रिप और टैबलेट यूनिट लागत',
    'Batch Stock Tracker': 'बैच स्टॉक ट्रैकर',
    'Distributor Return Value': 'वितरक वापसी मूल्य',
    'Substitute Margin Compare': 'विकल्प मार्जिन तुलना',
    'Purchase Cost Estimate': 'खरीद लागत अनुमान',
    'Weight to Price': 'वजन से मूल्य',
    'Cash Tally': 'कैश टैली',
    'GST Calculator': 'जीएसटी कैलकुलेटर',
    'Bulk Savings': 'थोक बचत',
    'Percent Off': 'प्रतिशत छूट',
    'Profit Calculator': 'लाभ कैलकुलेटर',
    'Margin Calculator': 'मार्जिन कैलकुलेटर',
    'Stock Reorder Alert': 'स्टॉक पुनरारंभ चेतावनी',
    'Wholesale vs Retail': 'थोक बनाम खुदरा',
    'Credit Days Calculator': 'क्रेडिट दिनों का कैलकुलेटर',
    'Paint Calculator': 'पेंट कैलकुलेटर',
    'Tile Calculator': 'टाइल कैलकुलेटर',
    'Cement Bags Calculator': 'सीमेंट बैग कैलकुलेटर',
    'Steel Rod Weight': 'स्टील रॉड वजन',
    'Plywood Sheet Counter': 'प्लाईवुड शीट काउंटर',
    'Wall Putty / Primer Estimator': 'दीवार पुट्टी / प्राइमर अनुमानक',
    'Labour Cost Estimator': 'मजदूरी लागत अनुमानक',
    'Pipe Length Estimator': 'पाइप की लंबाई का अनुमानक',
    'Sand / Gravel Estimator': 'रेत / बजरी अनुमानक',
    'Chai Mix Calculator': 'चाय मिक्स कैलकुलेटर',
    'Cup Costing': 'कप लागत निर्धारण',
    'Milk Quantity Planner': 'दूध मात्रा योजनाकार',
    'Gas Cost per Cup': 'प्रति कप गैस लागत',
    'Break-even Counter': 'नो-प्रॉफिट-नो-लॉस काउंटर',
    'Snack Margin Calculator': 'स्नैक मार्जिन कैलकुलेटर',
    'Takeaway vs Dine-in': 'टेकअवे बनाम डाइन-इन',
    'Ingredient Stock Days': 'सामग्री स्टॉक के दिन',

    // Tool Descriptions
    'Convert fabric length from yards to meters in real-time': 'वास्तविक समय में कपड़े की लंबाई को यार्ड से मीटर में बदलें',
    'Calculate total production cost of a saree including fabric and labor': 'कपड़े और मजदूरी सहित साड़ी की कुल उत्पादन लागत की गणना करें',
    'Calculate fabric remaining after cutting blouse piece': 'ब्लाउज पीस काटने के बाद बचे हुए कपड़े की गणना करें',
    'Calculate percentage of fabric wasted during stitching': 'सिलाई के दौरान बर्बाद हुए कपड़े के प्रतिशत की गणना करें',
    'Find rate per meter from total fabric length and price': 'कुल कपड़े की लंबाई और कीमत से प्रति मीटर दर ज्ञात करें',
    'Calculate cost of dress material set including accessories': 'सहायक उपकरण सहित ड्रेस सामग्री सेट की लागत की गणना करें',
    'Calculate cost of adding lace or border to saree': 'साड़ी में लेस या बॉर्डर जोड़ने की लागत की गणना करें',
    'Find cost per piece from total lot production cost': 'कुल लॉट उत्पादन लागत से प्रति पीस लागत ज्ञात करें',
    'Calculate cost of embroidery based on stitch count or hours': 'टांके की संख्या या घंटों के आधार पर कढ़ाई की लागत की गणना करें',
    'Calculate simple interest and total amount for months or years': 'महीनों या वर्षों के लिए साधारण ब्याज और कुल राशि की गणना करें',
    'Convert between weight in grams and pricing in real-time': 'वास्तविक समय में ग्राम में वजन और मूल्य निर्धारण के बीच रूपांतरण करें',
    'Convert currencies with live API rates and offline manual mode': 'लाइव एपीआई दरों और ऑफ़लाइन मैन्युअल मोड के साथ मुद्राओं को परिवर्तित करें',
    'Calculate monthly EMI and total interest for phone loans': 'फोन ऋण के लिए मासिक ईएमआई और कुल ब्याज की गणना करें',
    'Calculate retailer margin on phone EMI schemes': 'फोन ईएमआई योजनाओं पर खुदरा विक्रेता मार्जिन की गणना करें',
    'Calculate profit margins on phone accessories': 'फोन सहायक उपकरण पर लाभ मार्जिन की गणना करें',
    'Calculate trade-in value of old phones with depreciation': 'मूल्यह्रास के साथ पुराने फोन के ट्रेड-इन मूल्य की गणना करें',
    'Calculate profit margins on phone repair services': 'फोन मरम्मत सेवाओं पर लाभ मार्जिन की गणना करें',
    'Calculate customer quote for folder screen replacement': 'फ़ोल्डर स्क्रीन रिप्लेसमेंट के लिए ग्राहक कोट की गणना करें',
    'Calculate discounted price and margin for phone bundles': 'फोन बंडल के लिए रियायती मूल्य और मार्जिन की गणना करें',
    'Track daily progress towards monthly phone sales targets': 'मासिक फोन बिक्री लक्ष्यों की दिशा में दैनिक प्रगति को ट्रैक करें',
    'Calculate hourly rate charges for phone servicing': 'फोन सर्विसिंग के लिए प्रति घंटा दर शुल्क की गणना करें',
    'Track days remaining for item expiry with alerts': 'अलर्ट के साथ वस्तु की समाप्ति के लिए शेष दिनों को ट्रैक करें',
    'Calculate margins between MRP, PTR (retailer), and PTS (stockist)': 'MRP, PTR (खुदरा विक्रेता), और PTS (स्टॉकिस्ट) के बीच मार्जिन की गणना करें',
    'Calculate cost per single tablet from strip price': 'स्ट्रिप की कीमत से एक सिंगल टैबलेट की लागत की गणना करें',
    'Track stock levels of medicines by batch number': 'बैच नंबर द्वारा दवाओं के स्टॉक स्तर को ट्रैक करें',
    'Calculate value of expired medicines to return to distributor': 'वितरक को वापस करने के लिए एक्सपायर दवाओं के मूल्य की गणना करें',
    'Compare profit margins between brand substitute medicines': 'ब्रांड विकल्प दवाओं के बीच लाभ मार्जिन की तुलना करें',
    'Calculate total purchase cost of medicines at PTR': 'PTR पर दवाओं की कुल खरीद लागत की गणना करें',
    'Calculate price based on rate per kg and weight in grams': 'प्रति किलोग्राम दर और ग्राम में वजन के आधार पर मूल्य की गणना करें',
    'Calculate total value of cash denominations': 'नकद मूल्यवर्ग के कुल मूल्य की गणना करें',
    'Calculate GST inclusive and exclusive pricing': 'जीएसटी समावेशी और अनन्य मूल्य निर्धारण की गणना करें',
    'Calculate savings on bulk quantity purchases': 'थोक मात्रा में खरीद पर बचत की गणना करें',
    'Calculate final price after discount percentage': 'छूट प्रतिशत के बाद अंतिम मूल्य की गणना करें',
    'Calculate profit amount and profit percentage': 'लाभ राशि और लाभ प्रतिशत की गणना करें',
    'Calculate margin percentage on selling price': 'बिक्री मूल्य पर मार्जिन प्रतिशत की गणना करें',
    'Check if current stock level requires a reorder': 'जांचें कि क्या वर्तमान स्टॉक स्तर को फिर से ऑर्डर करने की आवश्यकता है',
    'Compare profit margins between wholesale and retail prices': 'थोक और खुदरा मूल्यों के बीच लाभ मार्जिन की तुलना करें',
    'Calculate due dates and remaining days for payments': 'भुगतान के लिए देय तिथियों और शेष दिनों की गणना करें',
    'Calculate paint quantity and cost for walls': 'दीवारों के लिए पेंट की मात्रा और लागत की गणना करें',
    'Calculate number of tiles and boxes needed for floor area': 'फर्श क्षेत्र के लिए आवश्यक टाइलों और बक्से की संख्या की गणना करें',
    'Calculate cement bags required for concrete volume': 'कंक्रीट की मात्रा के लिए आवश्यक सीमेंट बैग की गणना करें',
    'Calculate weight of steel rods based on diameter and length': 'व्यास और लंबाई के आधार पर स्टील की छड़ों के वजन की गणना करें',
    'Calculate number of plywood sheets needed for furniture': 'फर्नीचर के लिए आवश्यक प्लाईवुड शीट की संख्या की गणना करें',
    'Estimate wall putty and primer required for area': 'क्षेत्र के लिए आवश्यक दीवार पुट्टी और प्राइमर का अनुमान लगाएं',
    'Estimate labour charges based on area and daily rates': 'क्षेत्र और दैनिक दरों के आधार पर श्रम शुल्क का अनुमान लगाएं',
    'Calculate total length of pipes and rods needed': 'आवश्यक पाइप और छड़ों की कुल लंबाई की गणना करें',
    'Estimate volume and weight of sand or gravel needed': 'आवश्यक रेत या बजरी की मात्रा और वजन का अनुमान लगाएं',
    'Calculate batch ingredients and cost per cup': 'बैच सामग्री और प्रति कप लागत की गणना करें',
    'Calculate real cost per cup including daily overheads': 'दैनिक ओवरहेड्स सहित प्रति कप वास्तविक लागत की गणना करें',
    'Estimate raw milk required based on expected cups and wastage': 'अपेक्षित कप और बर्बादी के आधार पर आवश्यक कच्चे दूध का अनुमान लगाएं',
    'Calculate fuel cost share per tea cup': 'प्रति चाय कप ईंधन लागत हिस्से की गणना करें',
    'Calculate how many cups you must sell to cover costs and hit profit goals': 'लागत को कवर करने और लाभ लक्ष्यों को प्राप्त करने के लिए आपको कितने कप बेचने चाहिए, इसकी गणना करें',
    'Calculate margin and profit on samosas, biscuits, and snacks': 'समोसे, बिस्कुट और स्नैक्स पर मार्जिन और लाभ की गणना करें',
    'Compare profits when packing tea vs serving in cups': 'चाय पैक करने बनाम कप में परोसने पर होने वाले लाभ की तुलना करें',
    'Calculate days of stock remaining and reorder date': 'सामग्री के स्टॉक के शेष दिन और पुनरारंभ तिथि की गणना करें',
  };
}

