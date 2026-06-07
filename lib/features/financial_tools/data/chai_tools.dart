import 'package:flutter/material.dart';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';

final List<ToolConfig> chaiTools = [
  // 1. Chai Mix Calculator
  ToolConfig(
    toolId: 'chai_mix_calculator',
    name: 'Chai Mix Calculator',
    description: 'Calculate batch ingredients and cost per cup',
    icon: Icons.local_cafe,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'tea_g_cup', label: 'Tea Leaves (g/cup)', type: FieldType.decimal, hint: 'e.g. 2'),
      FieldConfig(fieldId: 'milk_ml_cup', label: 'Milk (ml/cup)', type: FieldType.decimal, hint: 'e.g. 60'),
      FieldConfig(fieldId: 'water_ml_cup', label: 'Water (ml/cup)', type: FieldType.decimal, hint: 'e.g. 40'),
      FieldConfig(fieldId: 'sugar_g_cup', label: 'Sugar (g/cup)', type: FieldType.decimal, hint: 'e.g. 8'),
      FieldConfig(fieldId: 'cups_count', label: 'Number of Cups', type: FieldType.number, hint: 'e.g. 50'),
      FieldConfig(fieldId: 'tea_cost_100g', label: 'Tea Leaves Cost (₹ per 100g)', type: FieldType.decimal, hint: 'e.g. 40'),
      FieldConfig(fieldId: 'milk_cost_liter', label: 'Milk Cost (₹ per Liter)', type: FieldType.decimal, hint: 'e.g. 60'),
      FieldConfig(fieldId: 'sugar_cost_kg', label: 'Sugar Cost (₹ per kg)', type: FieldType.decimal, hint: 'e.g. 45'),
    ],
    formulaText: 'Batch Cost = Tea Cost + Milk Cost + Sugar Cost',
    calculate: (inputs) {
      final teaG = (inputs['tea_g_cup'] as num?)?.toDouble() ?? 0.0;
      final milkMl = (inputs['milk_ml_cup'] as num?)?.toDouble() ?? 0.0;
      final waterMl = (inputs['water_ml_cup'] as num?)?.toDouble() ?? 0.0;
      final sugarG = (inputs['sugar_g_cup'] as num?)?.toDouble() ?? 0.0;
      final cups = (inputs['cups_count'] as num?)?.toInt() ?? 0;

      final teaCost100g = (inputs['tea_cost_100g'] as num?)?.toDouble() ?? 0.0;
      final milkCostL = (inputs['milk_cost_liter'] as num?)?.toDouble() ?? 0.0;
      final sugarCostKg = (inputs['sugar_cost_kg'] as num?)?.toDouble() ?? 0.0;

      final totalTeaG = teaG * cups;
      final totalMilkMl = milkMl * cups;
      final totalWaterMl = waterMl * cups;
      final totalSugarG = sugarG * cups;

      final teaCost = (totalTeaG / 100.0) * teaCost100g;
      final milkCost = (totalMilkMl / 1000.0) * milkCostL;
      final sugarCost = (totalSugarG / 1000.0) * sugarCostKg;

      final totalBatchCost = teaCost + milkCost + sugarCost;
      final costPerCup = cups > 0 ? totalBatchCost / cups : 0.0;

      return CalculateResult(
        primaryResult: '₹${costPerCup.toStringAsFixed(2)}',
        primaryLabel: 'Ingredient Cost per Cup',
        secondaryResults: [
          SecondaryResult(label: 'Total Batch Cost', value: '₹${totalBatchCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Tea Leaves Needed', value: '${totalTeaG.toStringAsFixed(1)}g (Cost: ₹${teaCost.toStringAsFixed(2)})'),
          SecondaryResult(label: 'Milk Needed', value: '${(totalMilkMl / 1000.0).toStringAsFixed(2)}L (Cost: ₹${milkCost.toStringAsFixed(2)})'),
          SecondaryResult(label: 'Water Needed', value: '${(totalWaterMl / 1000.0).toStringAsFixed(2)}L'),
          SecondaryResult(label: 'Sugar Needed', value: '${(totalSugarG / 1000.0).toStringAsFixed(2)}kg (Cost: ₹${sugarCost.toStringAsFixed(2)})'),
        ],
      );
    },
  ),

  // 2. Cup Costing
  ToolConfig(
    toolId: 'cup_costing',
    name: 'Cup Costing',
    description: 'Calculate real cost per cup including daily overheads',
    icon: Icons.coffee,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'ingredient_cost', label: 'Ingredient Cost/Cup (₹)', type: FieldType.decimal, hint: 'e.g. 3.50'),
      FieldConfig(fieldId: 'gas_cost_day', label: 'Gas Cost per Day (₹)', type: FieldType.decimal, hint: 'e.g. 100'),
      FieldConfig(fieldId: 'cups_per_day', label: 'Cups Sold per Day', type: FieldType.number, hint: 'e.g. 150'),
      FieldConfig(fieldId: 'labor_cost_day', label: 'Labor Cost per Day (₹)', type: FieldType.decimal, hint: 'e.g. 300'),
    ],
    formulaText: 'Real Cost = Ingredients + (Gas + Labor) / Cups per Day',
    calculate: (inputs) {
      final ingCost = (inputs['ingredient_cost'] as num?)?.toDouble() ?? 0.0;
      final gasCost = (inputs['gas_cost_day'] as num?)?.toDouble() ?? 0.0;
      final cups = (inputs['cups_per_day'] as num?)?.toInt() ?? 0;
      final laborCost = (inputs['labor_cost_day'] as num?)?.toDouble() ?? 0.0;

      final overheadPerCup = cups > 0 ? (gasCost + laborCost) / cups : 0.0;
      final realCost = ingCost + overheadPerCup;
      final suggestedPrice = realCost / 0.7; // 30% margin

      return CalculateResult(
        primaryResult: '₹${realCost.toStringAsFixed(2)}',
        primaryLabel: 'Actual Cost per Cup',
        secondaryResults: [
          SecondaryResult(label: 'Suggested Selling Price (30% margin)', value: '₹${suggestedPrice.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Min Selling Price (Break-even)', value: '₹${realCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Overhead Cost per Cup', value: '₹${overheadPerCup.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 3. Milk Quantity Planner
  ToolConfig(
    toolId: 'milk_quantity_planner',
    name: 'Milk Quantity Planner',
    description: 'Estimate raw milk required based on expected cups and wastage',
    icon: Icons.water_drop,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'expected_cups', label: 'Expected Cups to Sell', type: FieldType.number, hint: 'e.g. 200'),
      FieldConfig(fieldId: 'milk_ml_cup', label: 'Milk per Cup (ml)', type: FieldType.decimal, hint: 'e.g. 60'),
      FieldConfig(
        fieldId: 'wastage_pct',
        label: 'Wastage / Boil Spill %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 50.0,
        divisions: 50,
        defaultValue: '5.0',
      ),
    ],
    formulaText: 'Total Milk = (Expected Cups * ml per Cup / 1000) * (1 + Wastage%)',
    calculate: (inputs) {
      final cups = (inputs['expected_cups'] as num?)?.toInt() ?? 0;
      final milkMl = (inputs['milk_ml_cup'] as num?)?.toDouble() ?? 0.0;
      final wastage = (inputs['wastage_pct'] as num?)?.toDouble() ?? 5.0;

      final baseMilkLiters = (cups * milkMl) / 1000.0;
      final totalMilkLiters = baseMilkLiters * (1.0 + (wastage / 100.0));

      return CalculateResult(
        primaryResult: '${totalMilkLiters.toStringAsFixed(2)} Liters',
        primaryLabel: 'Required Milk Volume',
        secondaryResults: [
          SecondaryResult(label: 'Net Milk Needed', value: '${baseMilkLiters.toStringAsFixed(2)} L'),
          SecondaryResult(label: 'Expected Wastage', value: '${(totalMilkLiters - baseMilkLiters).toStringAsFixed(2)} L'),
        ],
      );
    },
  ),

  // 4. Gas Cylinder Cost per Cup
  ToolConfig(
    toolId: 'gas_cylinder_cost_per_cup',
    name: 'Gas Cost per Cup',
    description: 'Calculate fuel cost share per tea cup',
    icon: Icons.local_fire_department,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'cylinder_cost', label: 'Cylinder Cost (₹)', type: FieldType.decimal, hint: 'e.g. 1050'),
      FieldConfig(fieldId: 'days_lasted', label: 'Days Cylinder Lasts', type: FieldType.number, hint: 'e.g. 15'),
      FieldConfig(fieldId: 'cups_per_day', label: 'Average Cups per Day', type: FieldType.number, hint: 'e.g. 120'),
    ],
    formulaText: 'Gas Cost per Cup = Cylinder Cost / (Days * Cups per Day)',
    calculate: (inputs) {
      final cost = (inputs['cylinder_cost'] as num?)?.toDouble() ?? 0.0;
      final days = (inputs['days_lasted'] as num?)?.toInt() ?? 0;
      final cups = (inputs['cups_per_day'] as num?)?.toInt() ?? 0;

      final totalCups = days * cups;
      final costPerCup = totalCups > 0 ? cost / totalCups : 0.0;

      return CalculateResult(
        primaryResult: '₹${costPerCup.toStringAsFixed(2)}',
        primaryLabel: 'Gas Cost per Cup',
        secondaryResults: [
          SecondaryResult(label: 'Total Cups boiled per Cylinder', value: '$totalCups cups'),
          SecondaryResult(label: 'Daily Fuel Cost', value: '₹${(days > 0 ? cost / days : 0.0).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 5. Break-even Cup Counter
  ToolConfig(
    toolId: 'breakeven_cup_counter',
    name: 'Break-even Counter',
    description: 'Calculate how many cups you must sell to cover costs and hit profit goals',
    icon: Icons.bar_chart,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'fixed_costs_day', label: 'Fixed Costs per Day (₹)', type: FieldType.decimal, hint: 'Rent, salaries, electric'),
      FieldConfig(fieldId: 'variable_cost_cup', label: 'Variable Cost per Cup (₹)', type: FieldType.decimal, hint: 'Milk, sugar, tea, cups'),
      FieldConfig(fieldId: 'selling_price_cup', label: 'Selling Price per Cup (₹)', type: FieldType.decimal, hint: 'e.g. 10'),
      FieldConfig(fieldId: 'target_profit_day', label: 'Target Profit per Day (₹)', type: FieldType.decimal, hint: 'e.g. 500'),
    ],
    formulaText: 'Break-even Cups = Fixed Costs / (Selling Price - Variable Cost)',
    calculate: (inputs) {
      final fixed = (inputs['fixed_costs_day'] as num?)?.toDouble() ?? 0.0;
      final variable = (inputs['variable_cost_cup'] as num?)?.toDouble() ?? 0.0;
      final price = (inputs['selling_price_cup'] as num?)?.toDouble() ?? 0.0;
      final target = (inputs['target_profit_day'] as num?)?.toDouble() ?? 0.0;

      final marginPerCup = price - variable;
      int breakEvenCups = 0;
      int targetCups = 0;

      if (marginPerCup > 0) {
        breakEvenCups = (fixed / marginPerCup).ceil();
        targetCups = ((fixed + target) / marginPerCup).ceil();
      }

      return CalculateResult(
        primaryResult: '$breakEvenCups Cups',
        primaryLabel: 'Cups for Break-Even',
        alertLevel: marginPerCup <= 0 ? AlertLevel.red : AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'Profit Margin per Cup', value: '₹${marginPerCup.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Cups to Hit Target Profit', value: '$targetCups cups'),
          SecondaryResult(label: 'Daily Revenue at Break-even', value: '₹${(breakEvenCups * price).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 6. Snack Margin Calculator
  ToolConfig(
    toolId: 'snack_margin_calculator',
    name: 'Snack Margin Calculator',
    description: 'Calculate margin and profit on samosas, biscuits, and snacks',
    icon: Icons.lunch_dining,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'snack_cost', label: 'Snack Cost Price (₹)', type: FieldType.decimal, hint: 'e.g. 7'),
      FieldConfig(fieldId: 'snack_selling', label: 'Snack Selling Price (₹)', type: FieldType.decimal, hint: 'e.g. 10'),
    ],
    formulaText: 'Profit = SP - CP | Margin % = (Profit / SP) * 100',
    calculate: (inputs) {
      final cp = (inputs['snack_cost'] as num?)?.toDouble() ?? 0.0;
      final sp = (inputs['snack_selling'] as num?)?.toDouble() ?? 0.0;

      final profit = sp - cp;
      final margin = sp > 0 ? (profit / sp) * 100.0 : 0.0;

      return CalculateResult(
        primaryResult: '${margin.toStringAsFixed(1)}%',
        primaryLabel: 'Profit Margin',
        alertLevel: margin >= 0 ? AlertLevel.green : AlertLevel.red,
        secondaryResults: [
          SecondaryResult(label: 'Profit per Piece', value: '₹${profit.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Cost Price', value: '₹${cp.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Selling Price', value: '₹${sp.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 7. Takeaway vs Dine-in Margin
  ToolConfig(
    toolId: 'takeaway_vs_dinein_margin',
    name: 'Takeaway vs Dine-in',
    description: 'Compare profits when packing tea vs serving in cups',
    icon: Icons.compare,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'tea_cost', label: 'Base Tea Cost (₹)', type: FieldType.decimal, hint: 'Ingredients cost only'),
      FieldConfig(fieldId: 'pkg_cost', label: 'Packaging Cost (₹)', type: FieldType.decimal, hint: 'Disposable cup, bag, carrier'),
      FieldConfig(fieldId: 'dinein_price', label: 'Dine-in Price (₹)', type: FieldType.decimal, hint: 'e.g. 10'),
      FieldConfig(fieldId: 'takeaway_price', label: 'Takeaway Price (₹)', type: FieldType.decimal, hint: 'e.g. 12'),
    ],
    formulaText: 'Dine-in Profit = Dine-in Price - Tea Cost\nTakeaway Profit = Takeaway Price - (Tea + Pkg) Cost',
    calculate: (inputs) {
      final teaCost = (inputs['tea_cost'] as num?)?.toDouble() ?? 0.0;
      final pkgCost = (inputs['pkg_cost'] as num?)?.toDouble() ?? 0.0;
      final dPrice = (inputs['dinein_price'] as num?)?.toDouble() ?? 0.0;
      final tPrice = (inputs['takeaway_price'] as num?)?.toDouble() ?? 0.0;

      final dProfit = dPrice - teaCost;
      final dMargin = dPrice > 0 ? (dProfit / dPrice) * 100.0 : 0.0;

      final tCost = teaCost + pkgCost;
      final tProfit = tPrice - tCost;
      final tMargin = tPrice > 0 ? (tProfit / tPrice) * 100.0 : 0.0;

      final isTakeawayBetter = tProfit > dProfit;

      return CalculateResult(
        primaryResult: isTakeawayBetter ? 'TAKEAWAY MORE PROFITABLE' : 'DINE-IN MORE PROFITABLE',
        primaryLabel: 'Profit Strategy Alert',
        alertLevel: AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'Dine-in Margin %', value: '${dMargin.toStringAsFixed(1)}% (Profit: ₹${dProfit.toStringAsFixed(2)})'),
          SecondaryResult(label: 'Takeaway Margin %', value: '${tMargin.toStringAsFixed(1)}% (Profit: ₹${tProfit.toStringAsFixed(2)})'),
          SecondaryResult(label: 'Profit Difference', value: '₹${(tProfit - dProfit).abs().toStringAsFixed(2)} per cup'),
        ],
      );
    },
  ),

  // 8. Ingredient Stock Days
  ToolConfig(
    toolId: 'ingredient_stock_days',
    name: 'Ingredient Stock Days',
    description: 'Calculate days of stock remaining and reorder date',
    icon: Icons.hourglass_bottom,
    category: ShopCategory.chai,
    fields: const [
      FieldConfig(fieldId: 'current_stock', label: 'Current Stock (g / kg / L)', type: FieldType.decimal, hint: 'e.g. 15'),
      FieldConfig(fieldId: 'daily_use', label: 'Daily Consumption (g / kg / L)', type: FieldType.decimal, hint: 'e.g. 1.5'),
    ],
    formulaText: 'Days Remaining = Current Stock / Daily Consumption',
    calculate: (inputs) {
      final stock = (inputs['current_stock'] as num?)?.toDouble() ?? 0.0;
      final daily = (inputs['daily_use'] as num?)?.toDouble() ?? 0.0;

      final days = daily > 0 ? stock / daily : 0.0;
      final now = DateTime.now();
      final reorderDate = now.add(Duration(days: days.floor()));

      return CalculateResult(
        primaryResult: '${days.toStringAsFixed(1)} Days',
        primaryLabel: 'Stock Lifespan',
        alertLevel: days < 3 ? AlertLevel.red : (days < 5 ? AlertLevel.yellow : AlertLevel.green),
        secondaryResults: [
          SecondaryResult(label: 'Expected Run-out Date', value: '${reorderDate.day}/${reorderDate.month}/${reorderDate.year}'),
          SecondaryResult(label: 'Current Level', value: '${stock.toStringAsFixed(2)} units'),
          SecondaryResult(label: 'Daily Burn Rate', value: '${daily.toStringAsFixed(2)} units/day'),
        ],
      );
    },
  ),
];
