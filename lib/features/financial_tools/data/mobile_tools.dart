import 'package:flutter/material.dart';
import 'dart:math';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';
import 'kirana_tools.dart';

final List<ToolConfig> mobileTools = [
  // 1. EMI Calculator (enhanced)
  ToolConfig(
    toolId: 'emi_calculator',
    name: 'EMI Calculator',
    description: 'Calculate monthly installment, total repayment, and interest breakdown',
    icon: Icons.credit_card,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(fieldId: 'phone_price', label: 'Phone Price (₹)', type: FieldType.decimal, hint: 'e.g. 15000'),
      FieldConfig(fieldId: 'down_payment', label: 'Down Payment (₹)', type: FieldType.decimal, hint: 'e.g. 3000'),
      FieldConfig(
        fieldId: 'tenure_months',
        label: 'Tenure (Months)',
        type: FieldType.dropdown,
        options: ['3', '6', '9', '12', '18', '24'],
        defaultValue: '6',
      ),
      FieldConfig(
        fieldId: 'interest_rate',
        label: 'Interest Rate (% P.A.)',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 30.0,
        divisions: 60,
        defaultValue: '14.0',
      ),
    ],
    formulaText: 'EMI = [P x r x (1+r)^n] / [(1+r)^n - 1] | P = Price - Down Payment',
    calculate: (inputs) {
      final price = (inputs['phone_price'] as num?)?.toDouble() ?? 0.0;
      final down = (inputs['down_payment'] as num?)?.toDouble() ?? 0.0;
      final tenureStr = inputs['tenure_months'] as String? ?? '6';
      final ratePA = (inputs['interest_rate'] as num?)?.toDouble() ?? 14.0;

      final n = int.tryParse(tenureStr) ?? 6;
      final p = price - down;

      if (p <= 0) {
        return CalculateResult(
          primaryResult: '₹0.00 / mo',
          primaryLabel: 'Monthly EMI',
          secondaryResults: [
            SecondaryResult(label: 'Total Repayment', value: '₹${down.toStringAsFixed(2)}'),
            SecondaryResult(label: 'Total Interest Paid', value: '₹0.00'),
            SecondaryResult(label: 'Net Principal Loaned', value: '₹0.00'),
          ],
        );
      }

      final double r = (ratePA / 12.0) / 100.0;
      double emi = 0.0;

      if (r == 0) {
        emi = p / n;
      } else {
        emi = (p * r * pow(1.0 + r, n)) / (pow(1.0 + r, n) - 1.0);
      }

      final totalRepayment = (emi * n) + down;
      final totalInterest = (emi * n) - p;

      return CalculateResult(
        primaryResult: '₹${emi.toStringAsFixed(2)} / mo',
        primaryLabel: 'Monthly EMI',
        secondaryResults: [
          SecondaryResult(label: 'Total Repayment (inc. down payment)', value: '₹${totalRepayment.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Total Interest Paid', value: '₹${totalInterest.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Principal Loan Amount', value: '₹${p.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 2. EMI Scheme Margin
  ToolConfig(
    toolId: 'emi_scheme_margin',
    name: 'EMI Scheme Margin',
    description: 'Compare profits between a cash sale and an EMI subvention deal',
    icon: Icons.account_balance,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(fieldId: 'phone_cost', label: 'Phone Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 12000'),
      FieldConfig(fieldId: 'phone_mrp', label: 'Phone Selling Price (₹)', type: FieldType.decimal, hint: 'e.g. 15000'),
      FieldConfig(fieldId: 'processing_fee_earned', label: 'Processing Fee Commission (₹)', type: FieldType.decimal, hint: 'e.g. 250'),
      FieldConfig(fieldId: 'subvention_cost', label: 'Subvention Cost / Interest Share (₹)', type: FieldType.decimal, hint: 'e.g. 500'),
    ],
    formulaText: 'EMI Profit = (SP - CP) + Comm. - Subvention | Cash Profit = SP - CP',
    calculate: (inputs) {
      final cp = (inputs['phone_cost'] as num?)?.toDouble() ?? 0.0;
      final sp = (inputs['phone_mrp'] as num?)?.toDouble() ?? 0.0;
      final fee = (inputs['processing_fee_earned'] as num?)?.toDouble() ?? 0.0;
      final sub = (inputs['subvention_cost'] as num?)?.toDouble() ?? 0.0;

      final cashMargin = sp - cp;
      final cashMarginPct = sp > 0 ? (cashMargin / sp) * 100.0 : 0.0;

      final emiMargin = (sp - cp) + fee - sub;
      final emiMarginPct = sp > 0 ? (emiMargin / sp) * 100.0 : 0.0;

      final isEmiBetter = emiMargin > cashMargin;
      final difference = (emiMargin - cashMargin).abs();

      return CalculateResult(
        primaryResult: isEmiBetter ? 'EMI SALE BETTER' : 'CASH SALE BETTER',
        primaryLabel: 'Recommended Deal',
        alertLevel: AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'EMI Net Margin', value: '₹${emiMargin.toStringAsFixed(2)} (${emiMarginPct.toStringAsFixed(1)}%)'),
          SecondaryResult(label: 'Cash Net Margin', value: '₹${cashMargin.toStringAsFixed(2)} (${cashMarginPct.toStringAsFixed(1)}%)'),
          SecondaryResult(label: 'Profit Difference', value: '₹${difference.toStringAsFixed(2)} per sale'),
        ],
      );
    },
  ),

  // 3. Accessory Margin Calculator
  ToolConfig(
    toolId: 'accessory_margin_calculator',
    name: 'Accessory Margin',
    description: 'Calculate retail price for covers, power banks, and cables with presets',
    icon: Icons.headphones,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(
        fieldId: 'item_type',
        label: 'Accessory Type',
        type: FieldType.dropdown,
        options: [
          'Phone cases / covers (60%)',
          'Chargers local brand (40%)',
          'Chargers branded (20%)',
          'Earphones local (50%)',
          'Earphones branded (25%)',
          'Screen guards (55%)',
          'Power banks (35%)',
          'Cables (45%)',
          'Custom'
        ],
        defaultValue: 'Phone cases / covers (60%)',
      ),
      FieldConfig(
        fieldId: 'margin_pct',
        label: 'Margin %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '60.0',
      ),
      FieldConfig(fieldId: 'cost_price', label: 'Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 100'),
    ],
    formulaText: 'Selling Price = Cost Price / (1 - Margin%/100)',
    onFieldChanged: (fieldId, value, inputs, controllers) {
      if (fieldId == 'item_type') {
        final type = value as String;
        double margin = 60.0;
        if (type.contains('cases')) {
          margin = 60.0;
        } else if (type.contains('Chargers local')) {
          margin = 40.0;
        } else if (type.contains('Chargers branded')) {
          margin = 20.0;
        } else if (type.contains('Earphones local')) {
          margin = 50.0;
        } else if (type.contains('Earphones branded')) {
          margin = 25.0;
        } else if (type.contains('Screen guards')) {
          margin = 55.0;
        } else if (type.contains('Power banks')) {
          margin = 35.0;
        } else if (type.contains('Cables')) {
          margin = 45.0;
        } else if (type == 'Custom') {
          return;
        }

        inputs['margin_pct'] = margin;
      }
    },
    calculate: (inputs) {
      final margin = (inputs['margin_pct'] as num?)?.toDouble() ?? 60.0;
      final cost = (inputs['cost_price'] as num?)?.toDouble() ?? 0.0;

      final sp = margin < 100 ? cost / (1.0 - (margin / 100.0)) : cost;
      final profit = sp - cost;

      return CalculateResult(
        primaryResult: '₹${sp.toStringAsFixed(2)}',
        primaryLabel: 'Suggested Retail Price',
        secondaryResults: [
          SecondaryResult(label: 'Profit Amount', value: '₹${profit.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Cost Price', value: '₹${cost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Margin set', value: '${margin.toStringAsFixed(1)}%'),
        ],
      );
    },
  ),

  // 4. Phone Exchange Value Estimator
  ToolConfig(
    toolId: 'phone_exchange_estimator',
    name: 'Phone Exchange Value',
    description: 'Calculate suggested exchange trade-in range based on condition and age',
    icon: Icons.swap_horiz,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(fieldId: 'original_mrp', label: 'Original MRP of Old Phone (₹)', type: FieldType.decimal, hint: 'e.g. 20000'),
      FieldConfig(fieldId: 'phone_age_years', label: 'Age of Phone (Years)', type: FieldType.number, hint: 'e.g. 1', defaultValue: '1'),
      FieldConfig(
        fieldId: 'phone_condition',
        label: 'Condition of Phone',
        type: FieldType.dropdown,
        options: ['Excellent (45% MRP)', 'Good (35% MRP)', 'Fair (22% MRP)', 'Poor (12% MRP)'],
        defaultValue: 'Good (35% MRP)',
      ),
    ],
    formulaText: 'Base = MRP * Cond% | Value = Base * (0.9 ^ (Age - 1))\nRange = Value * 0.9 to Value * 1.1',
    calculate: (inputs) {
      final mrp = (inputs['original_mrp'] as num?)?.toDouble() ?? 0.0;
      final age = (inputs['phone_age_years'] as num?)?.toInt() ?? 1;
      final condStr = inputs['phone_condition'] as String? ?? 'Good (35% MRP)';

      double factor = 0.35;
      if (condStr.contains('Excellent')) {
        factor = 0.45;
      } else if (condStr.contains('Good')) {
        factor = 0.35;
      } else if (condStr.contains('Fair')) {
        factor = 0.22;
      } else if (condStr.contains('Poor')) {
        factor = 0.12;
      }

      double value = mrp * factor;
      if (age > 1) {
        value = value * pow(0.9, age - 1);
      }

      final minVal = value * 0.9;
      final maxVal = value * 1.1;

      return CalculateResult(
        primaryResult: '₹${minVal.toStringAsFixed(0)} - ₹${maxVal.toStringAsFixed(0)}',
        primaryLabel: 'Buyback Value Range',
        alertLevel: AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'Average Value estimate', value: '₹${value.toStringAsFixed(0)}'),
          SecondaryResult(label: 'Initial Condition Factor', value: '${(factor * 100).toStringAsFixed(0)}% MRP'),
          SecondaryResult(label: 'Year Depreciation applied', value: '${(age - 1) * 10}% extra depreciation'),
        ],
      );
    },
  ),

  // 5. Repair Job Margin
  ToolConfig(
    toolId: 'repair_job_margin',
    name: 'Repair Job Margin',
    description: 'Calculate net profit margin on hardware repairs',
    icon: Icons.build,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(fieldId: 'part_cost', label: 'Spare Part Cost (₹)', type: FieldType.decimal, hint: 'e.g. 800'),
      FieldConfig(fieldId: 'labor_cost', label: 'Labor Cost (₹)', type: FieldType.decimal, hint: 'e.g. 200'),
      FieldConfig(fieldId: 'quote_price', label: 'Customer Quoted Price (₹)', type: FieldType.decimal, hint: 'e.g. 1500'),
    ],
    formulaText: 'Total Cost = Part + Labor | Margin% = ((Quote - Cost) / Quote) * 100',
    calculate: (inputs) {
      final part = (inputs['part_cost'] as num?)?.toDouble() ?? 0.0;
      final labor = (inputs['labor_cost'] as num?)?.toDouble() ?? 0.0;
      final quote = (inputs['quote_price'] as num?)?.toDouble() ?? 0.0;

      final cost = part + labor;
      final profit = quote - cost;
      final margin = quote > 0 ? (profit / quote) * 100.0 : 0.0;

      return CalculateResult(
        primaryResult: '₹${profit.toStringAsFixed(2)}',
        primaryLabel: 'Net Repair Profit',
        alertLevel: margin >= 0 ? AlertLevel.green : AlertLevel.red,
        secondaryResults: [
          SecondaryResult(label: 'Profit Margin Percentage', value: '${margin.toStringAsFixed(1)}%'),
          SecondaryResult(label: 'Total Cost (CP)', value: '₹${cost.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 6. Screen Replacement Quote
  ToolConfig(
    toolId: 'screen_replacement_quote',
    name: 'Screen Replacement Quote',
    description: 'Calculate quote suggestions for displays and glass repairs',
    icon: Icons.phone_android,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(
        fieldId: 'part_type',
        label: 'Display Quality Type',
        type: FieldType.toggle,
        options: ['Original Screen', 'Copy Display / Folder'],
        defaultValue: 'Original Screen',
      ),
      FieldConfig(fieldId: 'part_cost', label: 'Display Folder Cost (₹)', type: FieldType.decimal, hint: 'e.g. 1800'),
      FieldConfig(fieldId: 'labor_cost', label: 'Fitting Labor Cost (₹)', type: FieldType.decimal, hint: 'e.g. 300', defaultValue: '300'),
      FieldConfig(fieldId: 'warranty_days', label: 'Warranty Given (Days)', type: FieldType.number, hint: 'e.g. 90', defaultValue: '90'),
      FieldConfig(fieldId: 'final_quote', label: 'Final Custom Quote (₹)', type: FieldType.decimal, hint: 'Leave blank to use suggested'),
    ],
    formulaText: 'Suggested Quote = (Cost + Labor) / 0.65 (35% Margin)',
    calculate: (inputs) {
      final part = (inputs['part_cost'] as num?)?.toDouble() ?? 0.0;
      final labor = (inputs['labor_cost'] as num?)?.toDouble() ?? 300.0;
      final warranty = (inputs['warranty_days'] as num?)?.toInt() ?? 90;
      final customQuote = (inputs['final_quote'] as num?)?.toDouble() ?? 0.0;

      final cost = part + labor;
      final suggested = cost / 0.65;
      final finalQuote = customQuote > 0 ? customQuote : suggested;
      final profit = finalQuote - cost;
      final margin = finalQuote > 0 ? (profit / finalQuote) * 100.0 : 0.0;

      return CalculateResult(
        primaryResult: '₹${finalQuote.toStringAsFixed(2)}',
        primaryLabel: 'Final Billing Quote',
        alertLevel: margin >= 35 ? AlertLevel.green : (margin >= 20 ? AlertLevel.yellow : AlertLevel.red),
        secondaryResults: [
          SecondaryResult(label: 'Suggested Quote (35% Margin)', value: '₹${suggested.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Earned Profit', value: '₹${profit.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Actual Margin %', value: '${margin.toStringAsFixed(1)}%'),
          SecondaryResult(label: 'Warranty Period', value: '$warranty Days'),
        ],
      );
    },
  ),

  // 7. Bundle Deal Pricing
  ToolConfig(
    toolId: 'bundle_deal_pricing',
    name: 'Bundle Deal Pricing',
    description: 'Calculate phone + accessories combo selling price and discount savings',
    icon: Icons.shopping_bag,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(fieldId: 'phone_cost', label: 'Phone Cost (₹)', type: FieldType.decimal, hint: 'e.g. 10000'),
      FieldConfig(fieldId: 'acc1_cost', label: 'Accessory 1 Cost (₹)', type: FieldType.decimal, hint: 'e.g. 200 (Case)'),
      FieldConfig(fieldId: 'acc2_cost', label: 'Accessory 2 Cost (₹)', type: FieldType.decimal, hint: 'e.g. 150 (Tempered)'),
      FieldConfig(fieldId: 'acc3_cost', label: 'Accessory 3 Cost (₹)', type: FieldType.decimal, hint: 'e.g. 300 (Charger)'),
      FieldConfig(
        fieldId: 'target_margin_pct',
        label: 'Target Combo Margin %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '15.0',
      ),
    ],
    formulaText: 'Combo Cost = Sum | Combo Price = Cost / (1 - Margin%/100)\nSeparate Sum = Retail Phone (10% marg) + Retail Acc (40% marg)',
    calculate: (inputs) {
      final pCost = (inputs['phone_cost'] as num?)?.toDouble() ?? 0.0;
      final a1Cost = (inputs['acc1_cost'] as num?)?.toDouble() ?? 0.0;
      final a2Cost = (inputs['acc2_cost'] as num?)?.toDouble() ?? 0.0;
      final a3Cost = (inputs['acc3_cost'] as num?)?.toDouble() ?? 0.0;
      final target = (inputs['target_margin_pct'] as num?)?.toDouble() ?? 15.0;

      final totalCost = pCost + a1Cost + a2Cost + a3Cost;
      final comboSP = target < 100 ? totalCost / (1.0 - (target / 100.0)) : totalCost;

      // Estimate separate retail prices: Phone has 10% margin, accessories have 40% margin
      final sepPhone = pCost / 0.9;
      final sepAccs = (a1Cost + a2Cost + a3Cost) / 0.6;
      final separateTotal = sepPhone + sepAccs;

      final savings = separateTotal - comboSP;

      return CalculateResult(
        primaryResult: '₹${comboSP.toStringAsFixed(2)}',
        primaryLabel: 'Suggested Bundle Price',
        secondaryResults: [
          SecondaryResult(label: 'Customer Combo Savings', value: '₹${max(0.0, savings).toStringAsFixed(2)}'),
          SecondaryResult(label: 'Total Combo Cost Price', value: '₹${totalCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Standard Separate Cost', value: '₹${separateTotal.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 8. GST on Electronics (Reusing Kirana GST Config, default slab 18%)
  kiranaTools.firstWhere((t) => t.toolId == 'gst_calculator'),

  // 9. Monthly Sales Target Tracker
  ToolConfig(
    toolId: 'monthly_sales_target',
    name: 'Sales Target Tracker',
    description: 'Track daily run-rate required to hit monthly sales target',
    icon: Icons.flag,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(fieldId: 'target_revenue', label: 'Monthly Revenue Target (₹)', type: FieldType.decimal, hint: 'e.g. 200000'),
      FieldConfig(
        fieldId: 'month_days',
        label: 'Total Days in Month',
        type: FieldType.slider,
        minValue: 28.0,
        maxValue: 31.0,
        divisions: 3,
        defaultValue: '30.0',
      ),
      FieldConfig(fieldId: 'today_date', label: 'Select Today\'s Date', type: FieldType.date),
      FieldConfig(fieldId: 'revenue_earned', label: 'Revenue Earned So Far (₹)', type: FieldType.decimal, hint: 'e.g. 80000'),
    ],
    formulaText: 'Daily Pace = (Target - Earned) / Remaining Days\nOn-Track if Earned >= Target * Today / Days',
    calculate: (inputs) {
      final target = (inputs['target_revenue'] as num?)?.toDouble() ?? 0.0;
      final days = (inputs['month_days'] as num?)?.toInt() ?? 30;
      final todayDate = inputs['today_date'] as DateTime?;
      final earned = (inputs['revenue_earned'] as num?)?.toDouble() ?? 0.0;

      final todayDay = todayDate?.day ?? DateTime.now().day;
      final remainingDays = max(1, days - todayDay + 1);

      final needed = target - earned;
      final ratePerDay = needed > 0 ? needed / remainingDays : 0.0;

      final expectedEarned = (target / max(1, days)) * todayDay;
      final isOnTrack = earned >= expectedEarned;

      return CalculateResult(
        primaryResult: '₹${ratePerDay.toStringAsFixed(2)} / day',
        primaryLabel: 'Required Daily Run-Rate',
        alertLevel: isOnTrack ? AlertLevel.green : AlertLevel.red,
        secondaryResults: [
          SecondaryResult(label: 'Target Tracker Status', value: isOnTrack ? 'ON TRACK' : 'BEHIND TARGET'),
          SecondaryResult(label: 'Expected Revenue Pace', value: '₹${expectedEarned.toStringAsFixed(2)} (Earned: ₹${earned.toStringAsFixed(2)})'),
          SecondaryResult(label: 'Remaining Target', value: '₹${max(0.0, needed).toStringAsFixed(2)}'),
          SecondaryResult(label: 'Remaining Days', value: '$remainingDays days left'),
        ],
      );
    },
  ),

  // 10. Service Charge Calculator
  ToolConfig(
    toolId: 'service_charge_calculator',
    name: 'Service Charge Calculator',
    description: 'Calculate repair service charges based on labor duration and hourly rate',
    icon: Icons.timer,
    category: ShopCategory.mobile,
    fields: const [
      FieldConfig(fieldId: 'time_mins', label: 'Time Taken (Minutes)', type: FieldType.number, hint: 'e.g. 45'),
      FieldConfig(fieldId: 'hourly_rate', label: 'Hourly Service Rate (₹/hour)', type: FieldType.decimal, hint: 'e.g. 400', defaultValue: '400'),
    ],
    formulaText: 'Service Charge = (Minutes / 60) * Hourly Rate',
    calculate: (inputs) {
      final mins = (inputs['time_mins'] as num?)?.toInt() ?? 0;
      final rate = (inputs['hourly_rate'] as num?)?.toDouble() ?? 400.0;

      final charge = (mins / 60.0) * rate;

      return CalculateResult(
        primaryResult: '₹${charge.toStringAsFixed(2)}',
        primaryLabel: 'Service Fee to Bill',
        secondaryResults: [
          SecondaryResult(label: 'Labor Duration', value: '$mins minutes'),
          SecondaryResult(label: 'Billing Hourly Rate', value: '₹${rate.toStringAsFixed(2)} / hour'),
        ],
      );
    },
  ),
];
