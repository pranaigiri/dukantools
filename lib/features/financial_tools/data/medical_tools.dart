import 'package:flutter/material.dart';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';
import 'kirana_tools.dart';

final List<ToolConfig> medicalTools = [
  // 1. Expiry Tracker (CRITICAL)
  ToolConfig(
    toolId: 'expiry_tracker_medical',
    name: 'Expiry Tracker',
    description: 'Track medicine batches expiring soon with visual warning alerts',
    icon: Icons.medication,
    category: ShopCategory.medical,
    fields: const [
      FieldConfig(fieldId: 'medicine_name', label: 'Medicine Name', type: FieldType.number, hint: 'e.g. Paracetamol'),
      FieldConfig(fieldId: 'batch_number', label: 'Batch Number', type: FieldType.number, hint: 'e.g. B2401'),
      FieldConfig(fieldId: 'expiry_date', label: 'Expiry Date', type: FieldType.date),
    ],
    formulaText: 'Days = Expiry Date - Current Date',
    calculate: (inputs) {
      final name = inputs['medicine_name'] as String? ?? '';
      final batch = inputs['batch_number'] as String? ?? '';
      final expiryDate = inputs['expiry_date'] as DateTime?;

      if (expiryDate == null) {
        return const CalculateResult(
          primaryResult: 'Select Date',
          primaryLabel: 'Days to Expiry',
          alertLevel: AlertLevel.none,
        );
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
      final days = expiry.difference(today).inDays;

      AlertLevel alert = AlertLevel.green;
      if (days < 60) {
        alert = AlertLevel.red;
      } else if (days < 90) {
        alert = AlertLevel.yellow;
      }

      return CalculateResult(
        primaryResult: '$days Days',
        primaryLabel: days >= 0 ? 'Days Remaining' : 'EXPIRED',
        alertLevel: alert,
        secondaryResults: [
          SecondaryResult(label: 'Medicine Name', value: name.isEmpty ? 'Not entered' : name),
          SecondaryResult(label: 'Batch Number', value: batch.isEmpty ? 'Not entered' : batch),
          SecondaryResult(label: 'Expiry Date', value: '${expiry.day}/${expiry.month}/${expiry.year}'),
        ],
      );
    },
  ),

  // 2. MRP vs PTR vs PTS Calculator
  ToolConfig(
    toolId: 'mrp_ptr_pts_calculator',
    name: 'MRP vs PTR vs PTS',
    description: 'Calculate Retailer (PTR) and Stockist (PTS) purchase prices and margins',
    icon: Icons.price_change,
    category: ShopCategory.medical,
    fields: const [
      FieldConfig(fieldId: 'mrp', label: 'MRP (₹)', type: FieldType.decimal, hint: 'e.g. 100'),
      FieldConfig(
        fieldId: 'ptr_pct',
        label: 'PTR Discount % from MRP',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '20.0',
      ),
      FieldConfig(
        fieldId: 'pts_pct',
        label: 'PTS Discount % from PTR',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '10.0',
      ),
    ],
    formulaText: 'PTR = MRP * (1 - PTR%/100) | PTS = PTR * (1 - PTS%/100)',
    calculate: (inputs) {
      final mrp = (inputs['mrp'] as num?)?.toDouble() ?? 0.0;
      final ptrPct = (inputs['ptr_pct'] as num?)?.toDouble() ?? 20.0;
      final ptsPct = (inputs['pts_pct'] as num?)?.toDouble() ?? 10.0;

      final ptr = mrp * (1.0 - (ptrPct / 100.0));
      final pts = ptr * (1.0 - (ptsPct / 100.0));

      final rMargin = mrp - ptr;
      final sMargin = ptr - pts;

      return CalculateResult(
        primaryResult: 'PTR: ₹${ptr.toStringAsFixed(2)} | PTS: ₹${pts.toStringAsFixed(2)}',
        primaryLabel: 'Buy Prices Breakdown',
        alertLevel: AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'Retailer Margin', value: '₹${rMargin.toStringAsFixed(2)} (${ptrPct.toStringAsFixed(1)}%)'),
          SecondaryResult(label: 'Stockist Margin', value: '₹${sMargin.toStringAsFixed(2)} (${ptsPct.toStringAsFixed(1)}%)'),
          SecondaryResult(label: 'Total Chain Margin', value: '₹${(mrp - pts).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 3. Strip / Tablet Unit Cost
  ToolConfig(
    toolId: 'strip_tablet_cost',
    name: 'Strip & Tablet Unit Cost',
    description: 'Calculate individual strip and single tablet cost from box price',
    icon: Icons.medication_liquid,
    category: ShopCategory.medical,
    fields: const [
      FieldConfig(fieldId: 'box_price_ptr', label: 'Box Price at PTR (₹)', type: FieldType.decimal, hint: 'e.g. 600'),
      FieldConfig(fieldId: 'strips_per_box', label: 'Strips per Box', type: FieldType.number, hint: 'e.g. 10'),
      FieldConfig(fieldId: 'tablets_per_strip', label: 'Tablets per Strip', type: FieldType.number, hint: 'e.g. 10'),
    ],
    formulaText: 'Strip Cost = Box Price / Strips | Tablet Cost = Strip Cost / Tablets',
    calculate: (inputs) {
      final boxPrice = (inputs['box_price_ptr'] as num?)?.toDouble() ?? 0.0;
      final strips = (inputs['strips_per_box'] as num?)?.toInt() ?? 0;
      final tablets = (inputs['tablets_per_strip'] as num?)?.toInt() ?? 0;

      final costPerStrip = strips > 0 ? boxPrice / strips : 0.0;
      final costPerTablet = (strips > 0 && tablets > 0) ? costPerStrip / tablets : 0.0;

      return CalculateResult(
        primaryResult: '₹${costPerTablet.toStringAsFixed(2)} / tablet',
        primaryLabel: 'Tablet Cost Price',
        secondaryResults: [
          SecondaryResult(label: 'Cost per Strip', value: '₹${costPerStrip.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Total Tablets in Box', value: '${strips * tablets} tablets'),
        ],
      );
    },
  ),

  // 4. Batch Stock Tracker
  ToolConfig(
    toolId: 'batch_stock_tracker',
    name: 'Batch Stock Tracker',
    description: 'Track inventory and sales delta for specific batch numbers',
    icon: Icons.inventory_2,
    category: ShopCategory.medical,
    fields: const [
      FieldConfig(fieldId: 'batch_number', label: 'Batch Number', type: FieldType.number, hint: 'e.g. B2401'),
      FieldConfig(fieldId: 'qty_received', label: 'Quantity Received', type: FieldType.number, hint: 'e.g. 100'),
      FieldConfig(fieldId: 'qty_sold', label: 'Quantity Sold', type: FieldType.number, hint: 'e.g. 45'),
    ],
    formulaText: 'Remaining Stock = Quantity Received - Quantity Sold',
    calculate: (inputs) {
      final batch = inputs['batch_number'] as String? ?? '';
      final received = (inputs['qty_received'] as num?)?.toInt() ?? 0;
      final sold = (inputs['qty_sold'] as num?)?.toInt() ?? 0;

      final remaining = received - sold;

      return CalculateResult(
        primaryResult: '$remaining units',
        primaryLabel: 'Remaining Stock in Batch',
        alertLevel: remaining < 0 ? AlertLevel.red : (remaining < 10 ? AlertLevel.yellow : AlertLevel.green),
        secondaryResults: [
          SecondaryResult(label: 'Batch Number', value: batch.isEmpty ? 'Not entered' : batch),
          SecondaryResult(label: 'Received Count', value: '$received units'),
          SecondaryResult(label: 'Sold Count', value: '$sold units'),
        ],
      );
    },
  ),

  // 5. Return to Distributor Value
  ToolConfig(
    toolId: 'return_distributor_value',
    name: 'Distributor Return Value',
    description: 'Calculate total refund value for returning stocks to distributor',
    icon: Icons.assignment_return,
    category: ShopCategory.medical,
    fields: const [
      FieldConfig(fieldId: 'qty_return', label: 'Quantity to Return', type: FieldType.number, hint: 'e.g. 15'),
      FieldConfig(fieldId: 'ptr_unit', label: 'PTR per Unit (₹)', type: FieldType.decimal, hint: 'e.g. 40'),
    ],
    formulaText: 'Refund Value = Quantity to Return * PTR per Unit',
    calculate: (inputs) {
      final qty = (inputs['qty_return'] as num?)?.toInt() ?? 0;
      final ptr = (inputs['ptr_unit'] as num?)?.toDouble() ?? 0.0;

      final refund = qty * ptr;

      return CalculateResult(
        primaryResult: '₹${refund.toStringAsFixed(2)}',
        primaryLabel: 'Estimated Refund Value',
        secondaryResults: [
          SecondaryResult(label: 'Total Units Returning', value: '$qty units'),
          SecondaryResult(label: 'PTR Price per Unit', value: '₹${ptr.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 6. Substitute Margin Comparator
  ToolConfig(
    toolId: 'substitute_margin_comparator',
    name: 'Substitute Margin Compare',
    description: 'Compare cost, pricing, and margin percentages of two substitute brands',
    icon: Icons.swap_horiz,
    category: ShopCategory.medical,
    fields: const [
      FieldConfig(fieldId: 'brand_a_name', label: 'Brand A Name', type: FieldType.number, hint: 'e.g. Paracetamol A'),
      FieldConfig(fieldId: 'brand_a_cost', label: 'Brand A Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 12'),
      FieldConfig(fieldId: 'brand_a_sp', label: 'Brand A Selling Price (₹)', type: FieldType.decimal, hint: 'e.g. 20'),
      FieldConfig(fieldId: 'brand_b_name', label: 'Brand B Name', type: FieldType.number, hint: 'e.g. Paracetamol B'),
      FieldConfig(fieldId: 'brand_b_cost', label: 'Brand B Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 8'),
      FieldConfig(fieldId: 'brand_b_sp', label: 'Brand B Selling Price (₹)', type: FieldType.decimal, hint: 'e.g. 18'),
    ],
    formulaText: 'Margin % = ((SP - CP) / SP) * 100',
    calculate: (inputs) {
      final nameA = inputs['brand_a_name'] as String? ?? 'Brand A';
      final cpA = (inputs['brand_a_cost'] as num?)?.toDouble() ?? 0.0;
      final spA = (inputs['brand_a_sp'] as num?)?.toDouble() ?? 0.0;

      final nameB = inputs['brand_b_name'] as String? ?? 'Brand B';
      final cpB = (inputs['brand_b_cost'] as num?)?.toDouble() ?? 0.0;
      final spB = (inputs['brand_b_sp'] as num?)?.toDouble() ?? 0.0;

      final profitA = spA - cpA;
      final marginA = spA > 0 ? (profitA / spA) * 100.0 : 0.0;

      final profitB = spB - cpB;
      final marginB = spB > 0 ? (profitB / spB) * 100.0 : 0.0;

      final nameAStr = nameA.isEmpty ? 'Brand A' : nameA;
      final nameBStr = nameB.isEmpty ? 'Brand B' : nameB;

      final String betterBrand = marginA > marginB
          ? '$nameAStr (Higher Margin)'
          : (marginB > marginA ? '$nameBStr (Higher Margin)' : 'Equal Margins');

      return CalculateResult(
        primaryResult: betterBrand,
        primaryLabel: 'Recommended Brand',
        alertLevel: AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: '$nameAStr Margin', value: '${marginA.toStringAsFixed(1)}% (Profit: ₹${profitA.toStringAsFixed(2)})'),
          SecondaryResult(label: '$nameBStr Margin', value: '${marginB.toStringAsFixed(1)}% (Profit: ₹${profitB.toStringAsFixed(2)})'),
          SecondaryResult(label: 'Margin Diff', value: '${(marginA - marginB).abs().toStringAsFixed(1)}%'),
        ],
      );
    },
  ),

  // 7. Discount on MRP (Reusing Kirana Percent Off Config)
  kiranaTools.firstWhere((t) => t.toolId == 'percent_off'),

  // 8. GST on Medicines (Reusing Kirana GST Config)
  kiranaTools.firstWhere((t) => t.toolId == 'gst_calculator'),

  // 9. Monthly Purchase Estimate
  ToolConfig(
    toolId: 'monthly_purchase_estimate',
    name: 'Purchase Cost Estimate',
    description: 'Project monthly purchase spend based on daily average spend',
    icon: Icons.calendar_month,
    category: ShopCategory.medical,
    fields: const [
      FieldConfig(fieldId: 'avg_daily_spend', label: 'Average Daily Purchase Spend (₹)', type: FieldType.decimal, hint: 'e.g. 5000'),
      FieldConfig(
        fieldId: 'working_days',
        label: 'Working Days in Month',
        type: FieldType.slider,
        minValue: 1.0,
        maxValue: 31.0,
        divisions: 30,
        defaultValue: '26.0',
      ),
    ],
    formulaText: 'Estimated Cost = Daily Spend * Working Days',
    calculate: (inputs) {
      final spend = (inputs['avg_daily_spend'] as num?)?.toDouble() ?? 0.0;
      final days = (inputs['working_days'] as num?)?.toInt() ?? 26;

      final total = spend * days;

      return CalculateResult(
        primaryResult: '₹${total.toStringAsFixed(2)}',
        primaryLabel: 'Estimated Monthly Spend',
        secondaryResults: [
          SecondaryResult(label: 'Daily Purchase Rate', value: '₹${spend.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Active Purchase Days', value: '$days days'),
        ],
      );
    },
  ),
];
