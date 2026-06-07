import 'package:flutter/material.dart';
import '../models/tool_config.dart';
import '../models/field_config.dart';
import '../models/calculate_result.dart';
import 'kirana_tools.dart';

final List<ToolConfig> hardwareTools = [
  // 1. Paint Calculator
  ToolConfig(
    toolId: 'paint_calculator',
    name: 'Paint Calculator',
    description: 'Calculate paintable area, liters needed, and required pack sizes',
    icon: Icons.format_paint,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'room_l', label: 'Room Length (ft)', type: FieldType.decimal, hint: 'e.g. 12'),
      FieldConfig(fieldId: 'room_w', label: 'Room Width (ft)', type: FieldType.decimal, hint: 'e.g. 10'),
      FieldConfig(fieldId: 'room_h', label: 'Room Height (ft)', type: FieldType.decimal, hint: 'e.g. 9'),
      FieldConfig(
        fieldId: 'coats_count',
        label: 'Number of Coats',
        type: FieldType.slider,
        minValue: 1.0,
        maxValue: 5.0,
        divisions: 4,
        defaultValue: '2.0',
      ),
      FieldConfig(fieldId: 'coverage_rate', label: 'Coverage (sq ft / Liter)', type: FieldType.decimal, hint: 'e.g. 80', defaultValue: '80'),
      FieldConfig(
        fieldId: 'deduct_doors',
        label: 'Deduct Standard Doors/Windows (40 sq ft)',
        type: FieldType.toggle,
        options: ['Yes', 'No'],
        defaultValue: 'Yes',
      ),
    ],
    formulaText: 'Wall Area = 2 * Height * (Length + Width) + Ceiling Area\nLiters = Area * Coats / Coverage',
    calculate: (inputs) {
      final l = (inputs['room_l'] as num?)?.toDouble() ?? 0.0;
      final w = (inputs['room_w'] as num?)?.toDouble() ?? 0.0;
      final h = (inputs['room_h'] as num?)?.toDouble() ?? 0.0;
      final coats = (inputs['coats_count'] as num?)?.toInt() ?? 2;
      final coverage = (inputs['coverage_rate'] as num?)?.toDouble() ?? 80.0;
      final deduct = inputs['deduct_doors'] as String? ?? 'Yes';

      final wallArea = 2.0 * h * (l + w);
      final ceilingArea = l * w;
      double totalArea = wallArea + ceilingArea;

      if (deduct == 'Yes') {
        totalArea -= 40.0;
      }
      if (totalArea < 0) totalArea = 0.0;

      final liters = coverage > 0 ? (totalArea * coats) / coverage : 0.0;

      final tins10L = (liters / 10.0).ceil();
      final tins4L = (liters / 4.0).ceil();
      final tins1L = liters.ceil();

      return CalculateResult(
        primaryResult: '${liters.toStringAsFixed(1)} Liters',
        primaryLabel: 'Total Paint Needed',
        secondaryResults: [
          SecondaryResult(label: 'Total Paintable Area', value: '${totalArea.toStringAsFixed(1)} sq ft'),
          SecondaryResult(label: '10L Can Size', value: '$tins10L cans'),
          SecondaryResult(label: '4L Can Size', value: '$tins4L cans'),
          SecondaryResult(label: '1L Can Size', value: '$tins1L cans'),
        ],
      );
    },
  ),

  // 2. Tile Calculator
  ToolConfig(
    toolId: 'tile_calculator',
    name: 'Tile Calculator',
    description: 'Calculate tiles and boxes needed for a floor area with wastage',
    icon: Icons.grid_4x4,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'area_l', label: 'Area Length (ft)', type: FieldType.decimal, hint: 'e.g. 15'),
      FieldConfig(fieldId: 'area_w', label: 'Area Width (ft)', type: FieldType.decimal, hint: 'e.g. 12'),
      FieldConfig(fieldId: 'tile_l_inch', label: 'Tile Length (inches)', type: FieldType.decimal, hint: 'e.g. 24'),
      FieldConfig(fieldId: 'tile_w_inch', label: 'Tile Width (inches)', type: FieldType.decimal, hint: 'e.g. 24'),
      FieldConfig(
        fieldId: 'wastage_pct',
        label: 'Wastage %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 30.0,
        divisions: 30,
        defaultValue: '10.0',
      ),
      FieldConfig(
        fieldId: 'tiles_per_box',
        label: 'Tiles per Box',
        type: FieldType.slider,
        minValue: 1.0,
        maxValue: 20.0,
        divisions: 19,
        defaultValue: '4.0',
      ),
    ],
    formulaText: 'Tiles = (Floor Area / Tile Area) * (1 + Wastage%)\nBoxes = Tiles / Tiles per Box',
    calculate: (inputs) {
      final areaL = (inputs['area_l'] as num?)?.toDouble() ?? 0.0;
      final areaW = (inputs['area_w'] as num?)?.toDouble() ?? 0.0;
      final tileL = (inputs['tile_l_inch'] as num?)?.toDouble() ?? 0.0;
      final tileW = (inputs['tile_w_inch'] as num?)?.toDouble() ?? 0.0;
      final wastage = (inputs['wastage_pct'] as num?)?.toDouble() ?? 10.0;
      final perBox = (inputs['tiles_per_box'] as num?)?.toInt() ?? 4;

      final floorArea = areaL * areaW;
      final tileAreaSqFt = (tileL * tileW) / 144.0;

      double tilesNeeded = 0.0;
      int boxesNeeded = 0;

      if (tileAreaSqFt > 0) {
        final rawTiles = floorArea / tileAreaSqFt;
        tilesNeeded = rawTiles * (1.0 + (wastage / 100.0));
      }

      if (perBox > 0) {
        boxesNeeded = (tilesNeeded / perBox).ceil();
      }

      return CalculateResult(
        primaryResult: '${tilesNeeded.ceil()} Tiles',
        primaryLabel: 'Required Tiles count',
        secondaryResults: [
          SecondaryResult(label: 'Boxes to Purchase', value: '$boxesNeeded boxes'),
          SecondaryResult(label: 'Total Floor Area', value: '${floorArea.toStringAsFixed(1)} sq ft'),
          SecondaryResult(label: 'Single Tile Size', value: '${tileL.toStringAsFixed(0)}" x ${tileW.toStringAsFixed(0)}" (${tileAreaSqFt.toStringAsFixed(3)} sq ft)'),
        ],
      );
    },
  ),

  // 3. Cement Bags Calculator
  ToolConfig(
    toolId: 'cement_bags_calculator',
    name: 'Cement Bags Calculator',
    description: 'Calculate cement, sand, and aggregate requirements for concrete',
    icon: Icons.foundation,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'length_ft', label: 'Slab/Column Length (ft)', type: FieldType.decimal, hint: 'e.g. 10'),
      FieldConfig(fieldId: 'width_ft', label: 'Slab/Column Width (ft)', type: FieldType.decimal, hint: 'e.g. 10'),
      FieldConfig(fieldId: 'thickness_ft', label: 'Thickness (ft)', type: FieldType.decimal, hint: 'e.g. 0.5 (or 6 inches)'),
      FieldConfig(
        fieldId: 'mix_ratio',
        label: 'Concrete Mix Ratio',
        type: FieldType.dropdown,
        options: ['1:2:4 (M15 - Slab)', '1:1.5:3 (M20 - Column/Beam)', '1:3:6 (M10 - Foundation)'],
        defaultValue: '1:2:4 (M15 - Slab)',
      ),
    ],
    formulaText: 'Dry Volume = Wet Volume * 1.54\nSum = Ratio parts sum | Component = Volume * part / Sum',
    calculate: (inputs) {
      final l = (inputs['length_ft'] as num?)?.toDouble() ?? 0.0;
      final w = (inputs['width_ft'] as num?)?.toDouble() ?? 0.0;
      final t = (inputs['thickness_ft'] as num?)?.toDouble() ?? 0.0;
      final mix = inputs['mix_ratio'] as String? ?? '1:2:4 (M15 - Slab)';

      final volumeFt = l * w * t;
      // Convert cu ft to cu m (1 cu ft = 0.0283168 cu m)
      final volumeM3 = volumeFt * 0.0283168;
      // Dry volume factor is 1.54
      final dryVolume = volumeM3 * 1.54;

      double cPart = 1.0;
      double sPart = 2.0;
      double aPart = 4.0;

      if (mix.startsWith('1:1.5:3')) {
        cPart = 1.0;
        sPart = 1.5;
        aPart = 3.0;
      } else if (mix.startsWith('1:3:6')) {
        cPart = 1.0;
        sPart = 3.0;
        aPart = 6.0;
      }

      final sumParts = cPart + sPart + aPart;

      final cementM3 = dryVolume * (cPart / sumParts);
      // 1 bag of cement is 0.0347 cu m
      final cementBags = cementM3 / 0.0347;

      final sandM3 = dryVolume * (sPart / sumParts);
      final sandFt = sandM3 * 35.3147; // 1 m3 = 35.3147 cu ft

      final aggM3 = dryVolume * (aPart / sumParts);
      final aggFt = aggM3 * 35.3147;

      return CalculateResult(
        primaryResult: '${cementBags.ceil()} Bags',
        primaryLabel: 'Required Cement Bags',
        secondaryResults: [
          SecondaryResult(label: 'Sand Quantity', value: '${sandFt.toStringAsFixed(1)} cu ft'),
          SecondaryResult(label: 'Aggregate Quantity', value: '${aggFt.toStringAsFixed(1)} cu ft'),
          SecondaryResult(label: 'Total Wet Volume', value: '${volumeFt.toStringAsFixed(1)} cu ft (${volumeM3.toStringAsFixed(2)} m³)'),
        ],
      );
    },
  ),

  // 4. Steel Rod Weight
  ToolConfig(
    toolId: 'steel_rod_weight',
    name: 'Steel Rod Weight',
    description: 'Calculate total weight of steel rebar reinforcement rods',
    icon: Icons.linear_scale,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'rod_diameter_mm', label: 'Rod Diameter (mm)', type: FieldType.decimal, hint: 'e.g. 8, 10, 12, 16, 20'),
      FieldConfig(fieldId: 'length_meters', label: 'Length per Rod (meters)', type: FieldType.decimal, hint: 'e.g. 12', defaultValue: '12'),
      FieldConfig(fieldId: 'rods_count', label: 'Number of Rods', type: FieldType.number, hint: 'e.g. 20'),
    ],
    formulaText: 'Weight per Meter = (d² / 162) | Total Weight = Weight * Length * Count',
    calculate: (inputs) {
      final dia = (inputs['rod_diameter_mm'] as num?)?.toDouble() ?? 0.0;
      final len = (inputs['length_meters'] as num?)?.toDouble() ?? 12.0;
      final count = (inputs['rods_count'] as num?)?.toInt() ?? 0;

      final weightPerMeter = (dia * dia) / 162.0;
      final weightPerRod = weightPerMeter * len;
      final totalWeight = weightPerRod * count;

      return CalculateResult(
        primaryResult: '${totalWeight.toStringAsFixed(2)} kg',
        primaryLabel: 'Total Steel Weight',
        secondaryResults: [
          SecondaryResult(label: 'Weight per Rod', value: '${weightPerRod.toStringAsFixed(2)} kg'),
          SecondaryResult(label: 'Weight per Meter', value: '${weightPerMeter.toStringAsFixed(3)} kg/m'),
          SecondaryResult(label: 'Total Length Needed', value: '${len * count} meters'),
        ],
      );
    },
  ),

  // 5. Plywood Sheet Counter
  ToolConfig(
    toolId: 'plywood_sheet_counter',
    name: 'Plywood Sheet Counter',
    description: 'Calculate sheets needed to cover a total area with wastage margins',
    icon: Icons.table_chart,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'area_sqft', label: 'Area to Cover (sq ft)', type: FieldType.decimal, hint: 'e.g. 160'),
      FieldConfig(
        fieldId: 'sheet_size',
        label: 'Sheet Dimension size',
        type: FieldType.dropdown,
        options: ['8x4 ft (32 sq ft)', '6x4 ft (24 sq ft)', '6x3 ft (18 sq ft)'],
        defaultValue: '8x4 ft (32 sq ft)',
      ),
      FieldConfig(
        fieldId: 'wastage_pct',
        label: 'Wastage %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 30.0,
        divisions: 30,
        defaultValue: '8.0',
      ),
      FieldConfig(fieldId: 'sheet_rate', label: 'Rate per Sheet (₹)', type: FieldType.decimal, hint: 'e.g. 1500'),
    ],
    formulaText: 'Sheets = (Area * (1 + Wastage%)) / Sheet Size Area',
    calculate: (inputs) {
      final area = (inputs['area_sqft'] as num?)?.toDouble() ?? 0.0;
      final size = inputs['sheet_size'] as String? ?? '8x4 ft (32 sq ft)';
      final wastage = (inputs['wastage_pct'] as num?)?.toDouble() ?? 8.0;
      final rate = (inputs['sheet_rate'] as num?)?.toDouble() ?? 0.0;

      double sheetArea = 32.0;
      if (size.contains('6x4')) {
        sheetArea = 24.0;
      } else if (size.contains('6x3')) {
        sheetArea = 18.0;
      }

      final totalAreaWithWastage = area * (1.0 + (wastage / 100.0));
      int sheetsNeeded = 0;
      if (sheetArea > 0) {
        sheetsNeeded = (totalAreaWithWastage / sheetArea).ceil();
      }
      final totalCost = sheetsNeeded * rate;

      return CalculateResult(
        primaryResult: '$sheetsNeeded Sheets',
        primaryLabel: 'Required Plywood Sheets',
        secondaryResults: [
          SecondaryResult(label: 'Total Material Cost', value: '₹${totalCost.toStringAsFixed(2)}'),
          SecondaryResult(label: 'Total Area with Wastage', value: '${totalAreaWithWastage.toStringAsFixed(1)} sq ft'),
          SecondaryResult(label: 'Single Sheet Cover', value: '$sheetArea sq ft'),
        ],
      );
    },
  ),

  // 6. Wall Putty / Primer Quantity
  ToolConfig(
    toolId: 'wall_putty_primer_quantity',
    name: 'Wall Putty / Primer Estimator',
    description: 'Calculate putty/primer weight needed for a wall surface area',
    icon: Icons.brush,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'wall_area_sqft', label: 'Wall Surface Area (sq ft)', type: FieldType.decimal, hint: 'e.g. 500'),
      FieldConfig(fieldId: 'coverage_kg', label: 'Coverage (sq ft per kg)', type: FieldType.decimal, hint: 'Putty: 15, Primer: 100', defaultValue: '15'),
      FieldConfig(fieldId: 'bag_size_kg', label: 'Bag / Tub Size (kg)', type: FieldType.decimal, hint: 'e.g. 20', defaultValue: '20'),
    ],
    formulaText: 'Weight (kg) = Area / Coverage | Bags = Weight / Bag Size',
    calculate: (inputs) {
      final area = (inputs['wall_area_sqft'] as num?)?.toDouble() ?? 0.0;
      final coverage = (inputs['coverage_kg'] as num?)?.toDouble() ?? 15.0;
      final bagSize = (inputs['bag_size_kg'] as num?)?.toDouble() ?? 20.0;

      final kgNeeded = coverage > 0 ? area / coverage : 0.0;
      final bags = bagSize > 0 ? (kgNeeded / bagSize).ceil() : 0;

      return CalculateResult(
        primaryResult: '${kgNeeded.toStringAsFixed(1)} kg',
        primaryLabel: 'Putty / Primer Weight Needed',
        secondaryResults: [
          SecondaryResult(label: 'Pack / Bags to Buy', value: '$bags packs'),
          SecondaryResult(label: 'Coverage Rate', value: '$coverage sq ft/kg'),
        ],
      );
    },
  ),

  // 7. Labour Cost Estimator
  ToolConfig(
    toolId: 'labour_cost_estimator',
    name: 'Labour Cost Estimator',
    description: 'Estimate labour contracting charges based on work area size',
    icon: Icons.engineering,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(
        fieldId: 'work_type',
        label: 'Type of Work',
        type: FieldType.dropdown,
        options: ['Painting', 'Tiling', 'Plastering/Masonry', 'Electrical/Plumbing', 'Other Work'],
        defaultValue: 'Painting',
      ),
      FieldConfig(fieldId: 'area_sqft', label: 'Work Area (sq ft)', type: FieldType.decimal, hint: 'e.g. 1200'),
      FieldConfig(fieldId: 'rate_sqft', label: 'Labour Rate per sq ft (₹)', type: FieldType.decimal, hint: 'e.g. 15'),
    ],
    formulaText: 'Total Cost = Area * Rate per sq ft',
    calculate: (inputs) {
      final type = inputs['work_type'] as String? ?? 'Painting';
      final area = (inputs['area_sqft'] as num?)?.toDouble() ?? 0.0;
      final rate = (inputs['rate_sqft'] as num?)?.toDouble() ?? 0.0;

      final total = area * rate;

      return CalculateResult(
        primaryResult: '₹${total.toStringAsFixed(2)}',
        primaryLabel: 'Estimated Labour Cost',
        secondaryResults: [
          SecondaryResult(label: 'Work Category', value: type),
          SecondaryResult(label: 'Rate Contract', value: '₹${rate.toStringAsFixed(2)} / sq ft'),
          SecondaryResult(label: 'Contracted Area', value: '${area.toStringAsFixed(1)} sq ft'),
        ],
      );
    },
  ),

  // 8. Pipe Length Estimator
  ToolConfig(
    toolId: 'pipe_length_estimator',
    name: 'Pipe Length Estimator',
    description: 'Calculate conduit or water plumbing pipes needed for fittings',
    icon: Icons.plumbing,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'points_count', label: 'Number of Connection Points', type: FieldType.number, hint: 'e.g. 12'),
      FieldConfig(fieldId: 'avg_dist_ft', label: 'Average Distance per Point (ft)', type: FieldType.decimal, hint: 'e.g. 15'),
      FieldConfig(
        fieldId: 'allowance_pct',
        label: 'Fittings Allowance / Joint Wastage %',
        type: FieldType.slider,
        minValue: 0.0,
        maxValue: 50.0,
        divisions: 50,
        defaultValue: '10.0',
      ),
    ],
    formulaText: 'Total Length = (Points * Average Distance) * (1 + Allowance%)',
    calculate: (inputs) {
      final points = (inputs['points_count'] as num?)?.toInt() ?? 0;
      final avgDist = (inputs['avg_dist_ft'] as num?)?.toDouble() ?? 0.0;
      final allowance = (inputs['allowance_pct'] as num?)?.toDouble() ?? 10.0;

      final netLength = points * avgDist;
      final totalLength = netLength * (1.0 + (allowance / 100.0));
      // Standard pipes come in 10-ft lengths (or 3 meters)
      final pipesCount = (totalLength / 10.0).ceil();

      return CalculateResult(
        primaryResult: '${totalLength.toStringAsFixed(1)} ft',
        primaryLabel: 'Required Pipe Length',
        secondaryResults: [
          SecondaryResult(label: 'Standard 10-ft Pipes Count', value: '$pipesCount pipes'),
          SecondaryResult(label: 'Net Distance needed', value: '${netLength.toStringAsFixed(1)} ft'),
        ],
      );
    },
  ),

  // 9. Sand / Aggregate Estimator
  ToolConfig(
    toolId: 'sand_aggregate_estimator',
    name: 'Sand / Gravel Estimator',
    description: 'Estimate sand and gravel aggregate volumes for bulk deliveries',
    icon: Icons.terrain,
    category: ShopCategory.hardware,
    fields: const [
      FieldConfig(fieldId: 'concrete_volume', label: 'Concrete Volume', type: FieldType.decimal, hint: 'e.g. 100'),
      FieldConfig(
        fieldId: 'unit_type',
        label: 'Volume Unit Type',
        type: FieldType.toggle,
        options: ['Cubic Feet (cu ft)', 'Cubic Meters (cu m)'],
        defaultValue: 'Cubic Feet (cu ft)',
      ),
      FieldConfig(
        fieldId: 'mix_ratio',
        label: 'Concrete Mix Ratio',
        type: FieldType.dropdown,
        options: ['1:2:4 (M15)', '1:1.5:3 (M20)', '1:3:6 (M10)'],
        defaultValue: '1:2:4 (M15)',
      ),
    ],
    formulaText: 'Dry Volume = Wet Volume * 1.54\nSand = Dry Vol * Sand Part / Sum\nAggregate = Dry Vol * Agg Part / Sum',
    calculate: (inputs) {
      final vol = (inputs['concrete_volume'] as num?)?.toDouble() ?? 0.0;
      final unit = inputs['unit_type'] as String? ?? 'Cubic Feet (cu ft)';
      final mix = inputs['mix_ratio'] as String? ?? '1:2:4 (M15)';

      final isFt = unit == 'Cubic Feet (cu ft)';
      final volumeM3 = isFt ? vol * 0.0283168 : vol;
      final dryVolM3 = volumeM3 * 1.54;

      double cPart = 1.0;
      double sPart = 2.0;
      double aPart = 4.0;

      if (mix.startsWith('1:1.5:3')) {
        cPart = 1.0;
        sPart = 1.5;
        aPart = 3.0;
      } else if (mix.startsWith('1:3:6')) {
        cPart = 1.0;
        sPart = 3.0;
        aPart = 6.0;
      }

      final sum = cPart + sPart + aPart;

      final sandM3 = dryVolM3 * (sPart / sum);
      final aggM3 = dryVolM3 * (aPart / sum);

      final sandFt = sandM3 * 35.3147;
      final aggFt = aggM3 * 35.3147;

      final String sandStr = isFt ? '${sandFt.toStringAsFixed(1)} cu ft' : '${sandM3.toStringAsFixed(2)} cu m';
      final String aggStr = isFt ? '${aggFt.toStringAsFixed(1)} cu ft' : '${aggM3.toStringAsFixed(2)} cu m';

      return CalculateResult(
        primaryResult: 'Sand: $sandStr\nAggregate: $aggStr',
        primaryLabel: 'Required Materials Volume',
        secondaryResults: [
          SecondaryResult(label: 'Total Wet Volume', value: isFt ? '$vol cu ft' : '$vol cu m'),
          SecondaryResult(label: 'Approx Sand Brass (1 Brass = 100 cu ft)', value: '${(sandFt / 100.0).toStringAsFixed(2)} brass'),
          SecondaryResult(label: 'Approx Gravel Brass', value: '${(aggFt / 100.0).toStringAsFixed(2)} brass'),
        ],
      );
    },
  ),

  // 10. Hardware Item Margin (Reusing Kirana Margin Calculator)
  kiranaTools.firstWhere((t) => t.toolId == 'margin_calculator'),
];
