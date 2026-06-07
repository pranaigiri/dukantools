import 'package:flutter/material.dart';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';
import 'kirana_tools.dart';

final List<ToolConfig> sareeTools = [
  // 1. Fabric Yard to Meter Converter
  ToolConfig(
    toolId: 'yard_to_meter_converter',
    name: 'Yard to Meter Converter',
    description: 'Convert fabric lengths between yards and meters',
    icon: Icons.straighten,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'length_val', label: 'Fabric Value', type: FieldType.decimal, hint: 'e.g. 5'),
      FieldConfig(
        fieldId: 'unit_type',
        label: 'Unit to Convert From',
        type: FieldType.toggle,
        options: ['Yards to Meters', 'Meters to Yards'],
        defaultValue: 'Yards to Meters',
      ),
    ],
    formulaText: '1 Yard = 0.9144 Meters | 1 Meter = 1.0936 Yards',
    calculate: (inputs) {
      final value = (inputs['length_val'] as num?)?.toDouble() ?? 0.0;
      final unit = inputs['unit_type'] as String? ?? 'Yards to Meters';

      double result = 0.0;
      String fromUnit = 'Yards';
      String toUnit = 'Meters';

      if (unit == 'Yards to Meters') {
        result = value * 0.9144;
        fromUnit = 'Yards';
        toUnit = 'Meters';
      } else {
        result = value / 0.9144;
        fromUnit = 'Meters';
        toUnit = 'Yards';
      }

      return CalculateResult(
        primaryResult: '${result.toStringAsFixed(3)} $toUnit',
        primaryLabel: 'Converted Length',
        secondaryResults: [
          SecondaryResult(label: 'Original Length', value: '${value.toStringAsFixed(2)} $fromUnit'),
          SecondaryResult(label: 'Conversion Factor', value: '1 Yard = 0.9144 Meters'),
        ],
      );
    },
  ),

  // 2. Saree Full Cost Calculator
  ToolConfig(
    toolId: 'saree_full_cost_calculator',
    name: 'Saree Cost Calculator',
    description: 'Calculate full cost of saree including borders, fall, and embroidery',
    icon: Icons.checkroom,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'fabric_cost', label: 'Base Fabric Cost (₹)', type: FieldType.decimal, hint: 'e.g. 1200'),
      FieldConfig(fieldId: 'blouse_cost', label: 'Blouse Fabric Cost (₹)', type: FieldType.decimal, hint: 'e.g. 300'),
      FieldConfig(fieldId: 'fall_cost', label: 'Fall Cost (₹)', type: FieldType.decimal, hint: 'e.g. 80'),
      FieldConfig(fieldId: 'stitching_cost', label: 'Pico / Stitching (₹)', type: FieldType.decimal, hint: 'e.g. 150'),
      FieldConfig(fieldId: 'embroidery_cost', label: 'Embroidery Charges (₹)', type: FieldType.decimal, hint: 'e.g. 400'),
      FieldConfig(fieldId: 'transport_cost', label: 'Transport Cost (₹)', type: FieldType.decimal, hint: 'e.g. 50'),
      FieldConfig(
        fieldId: 'margin_pct',
        label: 'Target Margin %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '25.0',
      ),
    ],
    formulaText: 'Total Cost = Sum of Components\nSuggested MRP = Total Cost / (1 - Margin%/100)',
    calculate: (inputs) {
      final fabric = (inputs['fabric_cost'] as num?)?.toDouble() ?? 0.0;
      final blouse = (inputs['blouse_cost'] as num?)?.toDouble() ?? 0.0;
      final fall = (inputs['fall_cost'] as num?)?.toDouble() ?? 0.0;
      final stitching = (inputs['stitching_cost'] as num?)?.toDouble() ?? 0.0;
      final embroidery = (inputs['embroidery_cost'] as num?)?.toDouble() ?? 0.0;
      final transport = (inputs['transport_cost'] as num?)?.toDouble() ?? 0.0;
      final margin = (inputs['margin_pct'] as num?)?.toDouble() ?? 25.0;

      final totalCost = fabric + blouse + fall + stitching + embroidery + transport;
      final mrp = margin < 100 ? totalCost / (1.0 - (margin / 100.0)) : totalCost;

      return CalculateResult(
        primaryResult: '₹${mrp.toStringAsFixed(2)}',
        primaryLabel: 'Suggested MRP',
        secondaryResults: [
          SecondaryResult(label: 'Total Cost Price (CP)', value: '₹${totalCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Net Profit Margin', value: '₹${(mrp - totalCost).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 3. Blouse Piece Remaining
  ToolConfig(
    toolId: 'blouse_piece_remaining',
    name: 'Blouse Fabric Left',
    description: 'Calculate remaining fabric length after cutting blouse',
    icon: Icons.content_cut,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'total_length', label: 'Total Saree/Fabric (m)', type: FieldType.decimal, hint: 'e.g. 6.5'),
      FieldConfig(fieldId: 'blouse_req', label: 'Blouse Cut Requirement (m)', type: FieldType.decimal, hint: 'e.g. 0.8'),
    ],
    formulaText: 'Remaining Length = Total Saree Length - Blouse Length',
    calculate: (inputs) {
      final total = (inputs['total_length'] as num?)?.toDouble() ?? 0.0;
      final req = (inputs['blouse_req'] as num?)?.toDouble() ?? 0.0;
      final remaining = total - req;

      return CalculateResult(
        primaryResult: '${remaining.toStringAsFixed(2)} meters',
        primaryLabel: 'Remaining Saree Fabric',
        alertLevel: remaining < 0 ? AlertLevel.red : AlertLevel.green,
        secondaryResults: [
          SecondaryResult(label: 'Total Length', value: '${total.toStringAsFixed(2)} m'),
          SecondaryResult(label: 'Blouse Length Cut', value: '${req.toStringAsFixed(2)} m'),
        ],
      );
    },
  ),

  // 4. Fabric Wastage
  ToolConfig(
    toolId: 'fabric_wastage',
    name: 'Fabric Wastage',
    description: 'Calculate scrap and net usable fabric after tailoring',
    icon: Icons.delete_outline,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'total_purchased', label: 'Total Fabric Purchased (m)', type: FieldType.decimal, hint: 'e.g. 10'),
      FieldConfig(
        fieldId: 'wastage_pct',
        label: 'Wastage %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '12.0',
      ),
    ],
    formulaText: 'Scrap = Total * Wastage%\nUsable = Total - Scrap',
    calculate: (inputs) {
      final total = (inputs['total_purchased'] as num?)?.toDouble() ?? 0.0;
      final wastage = (inputs['wastage_pct'] as num?)?.toDouble() ?? 12.0;

      final scrap = total * (wastage / 100.0);
      final usable = total - scrap;

      return CalculateResult(
        primaryResult: '${usable.toStringAsFixed(2)} meters',
        primaryLabel: 'Usable Fabric Length',
        secondaryResults: [
          SecondaryResult(label: 'Scrap Fabric', value: '${scrap.toStringAsFixed(2)} m'),
          SecondaryResult(label: 'Total Purchased', value: '${total.toStringAsFixed(2)} m'),
        ],
      );
    },
  ),

  // 5. Per Meter Rate Finder
  ToolConfig(
    toolId: 'per_meter_rate_finder',
    name: 'Per Meter Rate Finder',
    description: 'Find rate per meter from total cost and length',
    icon: Icons.calculate,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'total_cost', label: 'Total Fabric Cost (₹)', type: FieldType.decimal, hint: 'e.g. 1500'),
      FieldConfig(fieldId: 'total_meters', label: 'Total Meters Purchased', type: FieldType.decimal, hint: 'e.g. 12.5'),
    ],
    formulaText: 'Rate per Meter = Total Cost / Total Meters',
    calculate: (inputs) {
      final cost = (inputs['total_cost'] as num?)?.toDouble() ?? 0.0;
      final meters = (inputs['total_meters'] as num?)?.toDouble() ?? 0.0;

      final rate = meters > 0 ? cost / meters : 0.0;

      return CalculateResult(
        primaryResult: '₹${rate.toStringAsFixed(2)} / meter',
        primaryLabel: 'Rate per Meter',
        secondaryResults: [
          SecondaryResult(label: 'Cost for 5 meters', value: '₹${(rate * 5).toStringAsFixed(2)}'),
          SecondaryResult(label: 'Cost for 6 meters (Standard Saree)', value: '₹${(rate * 6).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 6. Suit / Dress Material Costing
  ToolConfig(
    toolId: 'suit_dress_material_costing',
    name: 'Dress Material Costing',
    description: 'Calculate total cost of stitch outfits with margins',
    icon: Icons.dry_cleaning,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'fabric_rate_m', label: 'Fabric Rate per Meter (₹)', type: FieldType.decimal, hint: 'e.g. 150'),
      FieldConfig(fieldId: 'meters_needed', label: 'Meters Needed', type: FieldType.decimal, hint: 'e.g. 4.5'),
      FieldConfig(fieldId: 'stitching_charge', label: 'Stitching / Tailoring (₹)', type: FieldType.decimal, hint: 'e.g. 500'),
      FieldConfig(fieldId: 'lining_cost', label: 'Lining / Inner Cost (₹)', type: FieldType.decimal, hint: 'e.g. 120'),
      FieldConfig(
        fieldId: 'margin_pct',
        label: 'Target Margin %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '30.0',
      ),
    ],
    formulaText: 'Cost = (Rate * Meters) + Stitching + Lining\nRetail = Cost / (1 - Margin%/100)',
    calculate: (inputs) {
      final rate = (inputs['fabric_rate_m'] as num?)?.toDouble() ?? 0.0;
      final meters = (inputs['meters_needed'] as num?)?.toDouble() ?? 0.0;
      final stitching = (inputs['stitching_charge'] as num?)?.toDouble() ?? 0.0;
      final lining = (inputs['lining_cost'] as num?)?.toDouble() ?? 0.0;
      final margin = (inputs['margin_pct'] as num?)?.toDouble() ?? 30.0;

      final fabricCost = rate * meters;
      final totalCost = fabricCost + stitching + lining;
      final retailPrice = margin < 100 ? totalCost / (1.0 - (margin / 100.0)) : totalCost;

      return CalculateResult(
        primaryResult: '₹${retailPrice.toStringAsFixed(2)}',
        primaryLabel: 'Suggested Retail Price',
        secondaryResults: [
          SecondaryResult(label: 'Total Material Cost', value: '₹${totalCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Fabric Cost Share', value: '₹${fabricCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Profit Earned', value: '₹${(retailPrice - totalCost).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 7. Lace / Border Add-on
  ToolConfig(
    toolId: 'lace_border_addon',
    name: 'Lace / Border Add-on',
    description: 'Calculate cost of adding lace border to sarees or dupattas',
    icon: Icons.border_style,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'base_item_price', label: 'Base Item Price (₹)', type: FieldType.decimal, hint: 'e.g. 800'),
      FieldConfig(fieldId: 'lace_rate_m', label: 'Lace Rate per Meter (₹)', type: FieldType.decimal, hint: 'e.g. 40'),
      FieldConfig(fieldId: 'meters_used', label: 'Lace Length Used (m)', type: FieldType.decimal, hint: 'e.g. 5.5'),
    ],
    formulaText: 'Final Price = Base Price + (Lace Rate * Length)',
    calculate: (inputs) {
      final base = (inputs['base_item_price'] as num?)?.toDouble() ?? 0.0;
      final laceRate = (inputs['lace_rate_m'] as num?)?.toDouble() ?? 0.0;
      final meters = (inputs['meters_used'] as num?)?.toDouble() ?? 0.0;

      final laceCost = laceRate * meters;
      final finalPrice = base + laceCost;

      return CalculateResult(
        primaryResult: '₹${finalPrice.toStringAsFixed(2)}',
        primaryLabel: 'Final Price with Lace',
        secondaryResults: [
          SecondaryResult(label: 'Lace Material Cost', value: '₹${laceCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Base Saree Price', value: '₹${base.toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 8. Wholesale Lot Per Piece Cost
  ToolConfig(
    toolId: 'wholesale_lot_cost_per_piece',
    name: 'Lot Per Piece Cost',
    description: 'Calculate unit cost and margin for bundle or lot purchases',
    icon: Icons.layers,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'lot_cost', label: 'Lot Total Cost (₹)', type: FieldType.decimal, hint: 'e.g. 10000'),
      FieldConfig(fieldId: 'pieces_count', label: 'Number of Pieces in Lot', type: FieldType.number, hint: 'e.g. 20'),
      FieldConfig(fieldId: 'selling_price_piece', label: 'Selling Price per Piece (₹)', type: FieldType.decimal, hint: 'e.g. 750'),
    ],
    formulaText: 'Cost/Piece = Lot Cost / Pieces\nMargin % = ((SP - Cost) / SP) * 100',
    calculate: (inputs) {
      final lotCost = (inputs['lot_cost'] as num?)?.toDouble() ?? 0.0;
      final pieces = (inputs['pieces_count'] as num?)?.toInt() ?? 0;
      final sp = (inputs['selling_price_piece'] as num?)?.toDouble() ?? 0.0;

      final costPerPiece = pieces > 0 ? lotCost / pieces : 0.0;
      final profit = sp - costPerPiece;
      final margin = sp > 0 ? (profit / sp) * 100.0 : 0.0;

      return CalculateResult(
        primaryResult: '₹${costPerPiece.toStringAsFixed(2)}',
        primaryLabel: 'Cost per Piece',
        alertLevel: margin >= 0 ? AlertLevel.green : AlertLevel.red,
        secondaryResults: [
          SecondaryResult(label: 'Margin Percentage', value: '${margin.toStringAsFixed(1)}%'),
          SecondaryResult(label: 'Profit per Piece', value: '₹${profit.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Total Expected Revenue', value: '₹${(pieces * sp).toStringAsFixed(2)}'),
        ],
      );
    },
  ),

  // 9. GST on Textile (Reusing Kirana GST Config)
  kiranaTools.firstWhere((t) => t.toolId == 'gst_calculator'),

  // 10. Embroidery Work Pricing
  ToolConfig(
    toolId: 'embroidery_work_pricing',
    name: 'Embroidery Pricing',
    description: 'Calculate suggested retail price for custom embroidery design',
    icon: Icons.auto_fix_high,
    category: ShopCategory.saree,
    fields: const [
      FieldConfig(fieldId: 'base_fabric_cost', label: 'Base Fabric Cost (₹)', type: FieldType.decimal, hint: 'e.g. 500'),
      FieldConfig(fieldId: 'embroidery_charges', label: 'Embroidery/Zardozi Labours (₹)', type: FieldType.decimal, hint: 'e.g. 1200'),
      FieldConfig(fieldId: 'other_charges', label: 'Other Work (Stones, Beads) (₹)', type: FieldType.decimal, hint: 'e.g. 200'),
      FieldConfig(
        fieldId: 'margin_pct',
        label: 'Target Margin %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 100.0,
        divisions: 100,
        defaultValue: '40.0',
      ),
    ],
    formulaText: 'Loaded Cost = Material + Labours\nSuggested Retail = Loaded Cost / (1 - Margin%/100)',
    calculate: (inputs) {
      final base = (inputs['base_fabric_cost'] as num?)?.toDouble() ?? 0.0;
      final emb = (inputs['embroidery_charges'] as num?)?.toDouble() ?? 0.0;
      final others = (inputs['other_charges'] as num?)?.toDouble() ?? 0.0;
      final margin = (inputs['margin_pct'] as num?)?.toDouble() ?? 40.0;

      final loadedCost = base + emb + others;
      final suggestedPrice = margin < 100 ? loadedCost / (1.0 - (margin / 100.0)) : loadedCost;

      return CalculateResult(
        primaryResult: '₹${suggestedPrice.toStringAsFixed(2)}',
        primaryLabel: 'Suggested Retail Price',
        secondaryResults: [
          SecondaryResult(label: 'Loaded Production Cost', value: '₹${loadedCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Profit Margin Amount', value: '₹${(suggestedPrice - loadedCost).toStringAsFixed(2)}'),
        ],
      );
    },
  ),
];
