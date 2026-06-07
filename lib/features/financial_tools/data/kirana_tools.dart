import 'package:flutter/material.dart';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';

final List<ToolConfig> kiranaTools = [
  // 1. Weight to Price
  ToolConfig(
    toolId: 'weight_to_price',
    name: 'Weight to Price',
    description: 'Calculate price based on rate per kg and weight in grams',
    icon: Icons.scale,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(
        fieldId: 'rate_per_kg',
        label: 'Rate per kg (₹)',
        type: FieldType.decimal,
        hint: 'e.g. 120',
      ),
      FieldConfig(
        fieldId: 'weight_g',
        label: 'Weight (grams)',
        type: FieldType.decimal,
        hint: 'e.g. 250',
      ),
    ],
    formulaText: 'Price = (Rate per kg / 1000) * Weight in grams',
    calculate: (inputs) {
      final rate = (inputs['rate_per_kg'] as num?)?.toDouble() ?? 0.0;
      final weight = (inputs['weight_g'] as num?)?.toDouble() ?? 0.0;
      final price = (rate / 1000.0) * weight;

      return CalculateResult(
        primaryResult: '₹${price.toStringAsFixed(2)}',
        primaryLabel: 'Total Bill Amount',
        secondaryResults: [
          SecondaryResult(label: 'Rate per Gram', value: '₹${(rate / 1000.0).toStringAsFixed(4)}'),
          SecondaryResult(label: 'Rate per 100g', value: '₹${(rate / 10.0).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 2. Cash Tally
  ToolConfig(
    toolId: 'cash_tally',
    name: 'Cash Tally',
    description: 'Calculate total value of cash denominations',
    icon: Icons.point_of_sale,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'note_500', label: '₹500 Notes', type: FieldType.number),
      FieldConfig(fieldId: 'note_200', label: '₹200 Notes', type: FieldType.number),
      FieldConfig(fieldId: 'note_100', label: '₹100 Notes', type: FieldType.number),
      FieldConfig(fieldId: 'note_50', label: '₹50 Notes', type: FieldType.number),
      FieldConfig(fieldId: 'note_20', label: '₹20 Notes', type: FieldType.number),
      FieldConfig(fieldId: 'note_10', label: '₹10 Notes/Coins', type: FieldType.number),
      FieldConfig(fieldId: 'note_5', label: '₹5 Notes/Coins', type: FieldType.number),
      FieldConfig(fieldId: 'note_2', label: '₹2 Coins', type: FieldType.number),
      FieldConfig(fieldId: 'note_1', label: '₹1 Coins', type: FieldType.number),
    ],
    formulaText: 'Total Cash = Sum of (Denomination * Count)',
    calculate: (inputs) {
      final n500 = (inputs['note_500'] as num?)?.toInt() ?? 0;
      final n200 = (inputs['note_200'] as num?)?.toInt() ?? 0;
      final n100 = (inputs['note_100'] as num?)?.toInt() ?? 0;
      final n50 = (inputs['note_50'] as num?)?.toInt() ?? 0;
      final n20 = (inputs['note_20'] as num?)?.toInt() ?? 0;
      final n10 = (inputs['note_10'] as num?)?.toInt() ?? 0;
      final n5 = (inputs['note_5'] as num?)?.toInt() ?? 0;
      final n2 = (inputs['note_2'] as num?)?.toInt() ?? 0;
      final n1 = (inputs['note_1'] as num?)?.toInt() ?? 0;

      final total = (500 * n500) +
          (200 * n200) +
          (100 * n100) +
          (50 * n50) +
          (20 * n20) +
          (10 * n10) +
          (5 * n5) +
          (2 * n2) +
          (1 * n1);

      final totalNotes = n500 + n200 + n100 + n50 + n20 + n10;
      final totalCoins = n5 + n2 + n1;

      return CalculateResult(
        primaryResult: '₹$total',
        primaryLabel: 'Total Cash Balance',
        secondaryResults: [
          SecondaryResult(label: 'Total Notes Count', value: '$totalNotes'),
          SecondaryResult(label: 'Total Coins Count', value: '$totalCoins'),
          if (n500 > 0) SecondaryResult(label: '₹500 Amount', value: '₹${500 * n500}'),
          if (n200 > 0) SecondaryResult(label: '₹200 Amount', value: '₹${200 * n200}'),
          if (n100 > 0) SecondaryResult(label: '₹100 Amount', value: '₹${100 * n100}'),
          if (n50 > 0) SecondaryResult(label: '₹50 Amount', value: '₹${50 * n50}'),
          if (n20 > 0) SecondaryResult(label: '₹20 Amount', value: '₹${20 * n20}'),
          if (n10 > 0) SecondaryResult(label: '₹10 Amount', value: '₹${10 * n10}'),
          if (n5 > 0) SecondaryResult(label: '₹5 Amount', value: '₹${5 * n5}'),
          if (n2 > 0) SecondaryResult(label: '₹2 Amount', value: '₹${2 * n2}'),
          if (n1 > 0) SecondaryResult(label: '₹1 Amount', value: '₹${1 * n1}'),
        ],
      );
    },
  ),

  // 3. GST Calculator
  ToolConfig(
    toolId: 'gst_calculator',
    name: 'GST Calculator',
    description: 'Calculate GST inclusive and exclusive pricing',
    icon: Icons.receipt_long,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(
        fieldId: 'amount',
        label: 'Amount (₹)',
        type: FieldType.decimal,
        hint: 'e.g. 1000',
      ),
      FieldConfig(
        fieldId: 'gst_slab',
        label: 'GST Slab',
        type: FieldType.dropdown,
        options: ['0%', '5%', '12%', '18%', '28%'],
        defaultValue: '18%',
      ),
      FieldConfig(
        fieldId: 'gst_type',
        label: 'Calculation Type',
        type: FieldType.toggle,
        options: ['GST Exclusive', 'GST Inclusive'],
        defaultValue: 'GST Exclusive',
      ),
    ],
    formulaText: 'Exclusive: Total = Base + GST\nInclusive: Base = Total / (1 + Rate)',
    calculate: (inputs) {
      final amount = (inputs['amount'] as num?)?.toDouble() ?? 0.0;
      final slabStr = inputs['gst_slab'] as String? ?? '18%';
      final typeStr = inputs['gst_type'] as String? ?? 'GST Exclusive';

      final slabPct = double.tryParse(slabStr.replaceAll('%', '')) ?? 18.0;
      final isExclusive = typeStr == 'GST Exclusive';

      double basePrice = 0.0;
      double gstAmount = 0.0;
      double totalAmount = 0.0;

      if (isExclusive) {
        basePrice = amount;
        gstAmount = amount * (slabPct / 100.0);
        totalAmount = basePrice + gstAmount;
      } else {
        totalAmount = amount;
        basePrice = amount / (1.0 + (slabPct / 100.0));
        gstAmount = totalAmount - basePrice;
      }

      final cgst = gstAmount / 2.0;
      final sgst = gstAmount / 2.0;

      return CalculateResult(
        primaryResult: '₹${totalAmount.toStringAsFixed(2)}',
        primaryLabel: 'Total Amount',
        secondaryResults: [
          SecondaryResult(label: 'Base Price', value: '₹${basePrice.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Total GST Amount', value: '₹${gstAmount.toStringAsFixed(2)}'),
          SecondaryResult(label: 'CGST (half)', value: '₹${cgst.toStringAsFixed(2)}'),
          SecondaryResult(label: 'SGST (half)', value: '₹${sgst.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 4. Bulk Savings
  ToolConfig(
    toolId: 'bulk_savings',
    name: 'Bulk Savings',
    description: 'Calculate savings on bulk quantity purchases',
    icon: Icons.shopping_cart,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'mrp', label: 'MRP per Item (₹)', type: FieldType.decimal, hint: 'e.g. 50'),
      FieldConfig(fieldId: 'qty', label: 'Quantity Purchased', type: FieldType.number, hint: 'e.g. 10'),
      FieldConfig(
        fieldId: 'discount_pct',
        label: 'Discount %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '10.0',
      ),
    ],
    formulaText: 'Savings = MRP * Qty * (Discount% / 100)',
    calculate: (inputs) {
      final mrp = (inputs['mrp'] as num?)?.toDouble() ?? 0.0;
      final qty = (inputs['qty'] as num?)?.toInt() ?? 0;
      final discountPct = (inputs['discount_pct'] as num?)?.toDouble() ?? 0.0;

      final totalMrp = mrp * qty;
      final savings = totalMrp * (discountPct / 100.0);
      final finalAmount = totalMrp - savings;

      return CalculateResult(
        primaryResult: '₹${finalAmount.toStringAsFixed(2)}',
        primaryLabel: 'Final Bill Amount',
        secondaryResults: [
          SecondaryResult(label: 'Total MRP', value: '₹${totalMrp.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Total Savings', value: '₹${savings.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Discount per Item', value: '₹${(mrp * (discountPct / 100.0)).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 5. Percent Off
  ToolConfig(
    toolId: 'percent_off',
    name: 'Percent Off',
    description: 'Calculate final price after discount percentage',
    icon: Icons.discount,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'original_price', label: 'Original Price (₹)', type: FieldType.decimal, hint: 'e.g. 250'),
      FieldConfig(
        fieldId: 'discount_pct',
        label: 'Discount %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '15.0',
      ),
    ],
    formulaText: 'Final Price = Original Price * (1 - Discount% / 100)',
    calculate: (inputs) {
      final price = (inputs['original_price'] as num?)?.toDouble() ?? 0.0;
      final discount = (inputs['discount_pct'] as num?)?.toDouble() ?? 0.0;

      final savings = price * (discount / 100.0);
      final finalPrice = price - savings;

      return CalculateResult(
        primaryResult: '₹${finalPrice.toStringAsFixed(2)}',
        primaryLabel: 'Discounted Price',
        secondaryResults: [
          SecondaryResult(label: 'Savings Amount', value: '₹${savings.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Original Price', value: '₹${price.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 6. Profit Calculator
  ToolConfig(
    toolId: 'profit_calculator',
    name: 'Profit Calculator',
    description: 'Calculate profit amount and profit percentage',
    icon: Icons.trending_up,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'cost_price', label: 'Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 80'),
      FieldConfig(fieldId: 'selling_price', label: 'Selling Price (₹)', type: FieldType.decimal, hint: 'e.g. 100'),
    ],
    formulaText: 'Profit = SP - CP | Profit % = (Profit / CP) * 100',
    calculate: (inputs) {
      final cp = (inputs['cost_price'] as num?)?.toDouble() ?? 0.0;
      final sp = (inputs['selling_price'] as num?)?.toDouble() ?? 0.0;

      final profit = sp - cp;
      final profitPct = cp > 0 ? (profit / cp) * 100.0 : 0.0;

      return CalculateResult(
        primaryResult: '₹${profit.toStringAsFixed(2)}',
        primaryLabel: 'Profit Amount',
        alertLevel: profit >= 0 ? AlertLevel.green : AlertLevel.red,
        secondaryResults: [
          SecondaryResult(label: 'Profit Percentage', value: '${profitPct.toStringAsFixed(2)}%'),
          SecondaryResult(label: 'Cost Price', value: '₹${cp.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Selling Price', value: '₹${sp.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 7. Margin Calculator
  ToolConfig(
    toolId: 'margin_calculator',
    name: 'Margin Calculator',
    description: 'Calculate margin percentage on selling price',
    icon: Icons.show_chart,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'cost_price', label: 'Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 80'),
      FieldConfig(fieldId: 'selling_price', label: 'Selling Price (₹)', type: FieldType.decimal, hint: 'e.g. 100'),
    ],
    formulaText: 'Margin % = ((SP - CP) / SP) * 100',
    calculate: (inputs) {
      final cp = (inputs['cost_price'] as num?)?.toDouble() ?? 0.0;
      final sp = (inputs['selling_price'] as num?)?.toDouble() ?? 0.0;

      final profit = sp - cp;
      final marginPct = sp > 0 ? (profit / sp) * 100.0 : 0.0;

      return CalculateResult(
        primaryResult: '${marginPct.toStringAsFixed(2)}%',
        primaryLabel: 'Profit Margin (%)',
        alertLevel: marginPct >= 0 ? AlertLevel.green : AlertLevel.red,
        secondaryResults: [
          SecondaryResult(label: 'Profit Amount', value: '₹${profit.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Cost Price', value: '₹${cp.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Selling Price', value: '₹${sp.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 8. Expiry Tracker
  ToolConfig(
    toolId: 'expiry_tracker_kirana',
    name: 'Expiry Tracker',
    description: 'Track days remaining for item expiry with alerts',
    icon: Icons.event_busy,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'product_name', label: 'Product Name', type: FieldType.number, hint: 'e.g. Milk Packet'),
      FieldConfig(fieldId: 'expiry_date', label: 'Expiry Date', type: FieldType.date),
    ],
    formulaText: 'Days = Expiry Date - Current Date',
    calculate: (inputs) {
      final name = inputs['product_name'] as String? ?? '';
      final expiryDate = inputs['expiry_date'] as DateTime?;

      if (expiryDate == null) {
        return const CalculateResult(
          primaryResult: 'Select Date',
          primaryLabel: 'Days Remaining',
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
        primaryLabel: days >= 0 ? 'Days Remaining' : 'OVERDUE / EXPIRED',
        alertLevel: alert,
        secondaryResults: [
          SecondaryResult(label: 'Product Name', value: name.isEmpty ? 'Not entered' : name),
          SecondaryResult(label: 'Expiry Date', value: '${expiry.day}/${expiry.month}/${expiry.year}'),
        ],
      );
    },
  ),

  // 9. Stock Reorder Alert
  ToolConfig(
    toolId: 'stock_reorder_alert',
    name: 'Stock Reorder Alert',
    description: 'Check if current stock level requires a reorder',
    icon: Icons.inventory,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'item_name', label: 'Item Name', type: FieldType.number, hint: 'e.g. Soap'),
      FieldConfig(fieldId: 'current_stock', label: 'Current Stock', type: FieldType.number, hint: 'e.g. 5'),
      FieldConfig(fieldId: 'min_threshold', label: 'Minimum Threshold', type: FieldType.number, hint: 'e.g. 10'),
    ],
    formulaText: 'Reorder = Current Stock < Minimum Threshold',
    calculate: (inputs) {
      final name = inputs['item_name'] as String? ?? '';
      final current = (inputs['current_stock'] as num?)?.toInt() ?? 0;
      final threshold = (inputs['min_threshold'] as num?)?.toInt() ?? 0;

      final reorder = current < threshold;
      final shortage = reorder ? (threshold - current) : 0;

      return CalculateResult(
        primaryResult: reorder ? 'REORDER NEEDED' : 'STOCK ADEQUATE',
        primaryLabel: 'Reorder Status',
        alertLevel: reorder ? AlertLevel.red : AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'Item Name', value: name.isEmpty ? 'Not entered' : name),
          SecondaryResult(label: 'Current Stock', value: '$current units'),
          SecondaryResult(label: 'Threshold Level', value: '$threshold units'),
          if (reorder) SecondaryResult(label: 'Shortage Quantity', value: '$shortage units'),
        ],
      );
    },
  ),

  // 10. Wholesale vs Retail Margin
  ToolConfig(
    toolId: 'wholesale_vs_retail_margin',
    name: 'Wholesale vs Retail',
    description: 'Compare profit margins between wholesale and retail prices',
    icon: Icons.compare_arrows,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'cost_price', label: 'Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 100'),
      FieldConfig(fieldId: 'wholesale_price', label: 'Wholesale Price (₹)', type: FieldType.decimal, hint: 'e.g. 115'),
      FieldConfig(fieldId: 'retail_price', label: 'Retail Price (₹)', type: FieldType.decimal, hint: 'e.g. 130'),
    ],
    formulaText: 'Wholesale Margin = ((WP - CP) / WP) * 100\nRetail Margin = ((RP - CP) / RP) * 100',
    calculate: (inputs) {
      final cp = (inputs['cost_price'] as num?)?.toDouble() ?? 0.0;
      final wp = (inputs['wholesale_price'] as num?)?.toDouble() ?? 0.0;
      final rp = (inputs['retail_price'] as num?)?.toDouble() ?? 0.0;

      final wProfit = wp - cp;
      final rProfit = rp - cp;

      final wMarginPct = wp > 0 ? (wProfit / wp) * 100.0 : 0.0;
      final rMarginPct = rp > 0 ? (rProfit / rp) * 100.0 : 0.0;

      return CalculateResult(
        primaryResult: 'Retail: ${rMarginPct.toStringAsFixed(1)}% | Wholesale: ${wMarginPct.toStringAsFixed(1)}%',
        primaryLabel: 'Margins Breakdown',
        alertLevel: AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'Retail Profit', value: '₹${rProfit.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Wholesale Profit', value: '₹${wProfit.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Spread Diff (Retail - Wholesale)', value: '₹${(rp - wp).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 11. Credit Days Calculator
  ToolConfig(
    toolId: 'credit_days_calculator',
    name: 'Credit Days Calculator',
    description: 'Calculate due dates and remaining days for payments',
    icon: Icons.calendar_today,
    category: ShopCategory.kirana,
    fields: const [
      FieldConfig(fieldId: 'bill_date', label: 'Bill Date', type: FieldType.date),
      FieldConfig(
        fieldId: 'credit_days',
        label: 'Credit Days Allowed',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 180.0,
        divisions: 36,
        defaultValue: '30.0',
      ),
    ],
    formulaText: 'Due Date = Bill Date + Credit Days',
    calculate: (inputs) {
      final billDate = inputs['bill_date'] as DateTime?;
      final creditDays = (inputs['credit_days'] as num?)?.toInt() ?? 30;

      if (billDate == null) {
        return const CalculateResult(
          primaryResult: 'Select Date',
          primaryLabel: 'Credit Due In',
          alertLevel: AlertLevel.none,
        );
      }

      final dueDate = billDate.add(Duration(days: creditDays));
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
      final remaining = due.difference(today).inDays;

      final isOverdue = remaining < 0;

      return CalculateResult(
        primaryResult: isOverdue ? 'OVERDUE BY ${remaining.abs()} DAYS' : '$remaining Days',
        primaryLabel: isOverdue ? 'Payment Alert' : 'Days Remaining',
        alertLevel: isOverdue ? AlertLevel.red : (remaining < 7 ? AlertLevel.yellow : AlertLevel.green),
        secondaryResults: [
          SecondaryResult(label: 'Due Date', value: '${due.day}/${due.month}/${due.year}'),
          SecondaryResult(label: 'Bill Date', value: '${billDate.day}/${billDate.month}/${billDate.year}'),
        ],
      );
    },
  ),
];
