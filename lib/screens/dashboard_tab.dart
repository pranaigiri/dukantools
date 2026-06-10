import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dukan_tools/providers/data_provider.dart';
import 'package:dukan_tools/models/pl_entry.dart';
import 'package:dukan_tools/models/ledger_account.dart';
import 'package:dukan_tools/common/helper.dart';
import 'package:dukan_tools/l10n/app_localizations.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final theme = Theme.of(context);
    final helper = Helper();
    final l10n = AppLocalizations.of(context)!;

    if (dataProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasPlData = dataProvider.plEntries.isNotEmpty;
    final hasLedgerData = dataProvider.ledgerAccounts.isNotEmpty;

    // Trigger restore snackbar if message exists
    if (dataProvider.restoreMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(dataProvider.restoreMessage!),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        dataProvider.clearRestoreMessage();
      });
    }

    return RefreshIndicator(
      onRefresh: () => dataProvider.loadData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Stats Header
            _buildWelcomeHeader(context, theme, dataProvider),
            const SizedBox(height: 16),

            // Monthly Sales Comparison Card
            _buildMonthlySalesComparisonCard(context, theme, dataProvider),
            const SizedBox(height: 20),

            // Cash Flow Summary Section
            _buildSectionHeader(theme, l10n.dailyPLAnalytics),
            const SizedBox(height: 10),
            if (hasPlData)
              _buildPLChartCard(context, theme, dataProvider.plEntries, helper)
            else
              _buildEmptyStateCard(
                theme,
                Icons.analytics_outlined,
                l10n.noPLDataYet,
                l10n.logYourDailyIncomeAndExpensesInTheDayBookTabToViewCharts,
              ),

            const SizedBox(height: 24),

            // Khata/Ledger Summary Section
            _buildSectionHeader(theme, l10n.ledgerInsights),
            const SizedBox(height: 10),
            if (hasLedgerData) ...[
              _buildLedgerOverviewCard(context, theme, dataProvider, helper),
              const SizedBox(height: 16),
              _buildTopAccountsCard(context, theme, dataProvider.topActiveAccounts, helper),
            ] else
              _buildEmptyStateCard(
                theme,
                Icons.supervised_user_circle_outlined,
                l10n.noLedgerAccountsYet,
                l10n.addCustomersOrVendorsInTheLedgerTabToTrackCreditsAndOutstandingBalances,
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, ThemeData theme, DataProvider provider) {
    final netProfit = provider.netProfit;
    final netColor = netProfit >= 0 ? Colors.green : Colors.red;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: theme.brightness == Brightness.dark
              ? [const Color(0xFF1E1E2C), const Color(0xFF252538)]
              : [const Color(0xFFE3F2FD), const Color(0xFFE8F5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.overviewDashboard,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.blueGrey[800],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.bubble_chart,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.netDayBookBalance,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${netProfit >= 0 ? '+' : ''}₹${netProfit.toStringAsFixed(2)}",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: netColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMiniHeaderStat(
                theme,
                l10n.receivablesGet,
                "₹${provider.totalReceivables.toStringAsFixed(1)}",
                Colors.teal,
              ),
              const SizedBox(width: 16),
              _buildMiniHeaderStat(
                theme,
                l10n.payablesGive,
                "₹${provider.totalPayables.toStringAsFixed(1)}",
                Colors.deepOrangeAccent,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMonthlySalesComparisonCard(BuildContext context, ThemeData theme, DataProvider provider) {
    final curSales = provider.currentMonthSalesCategory;
    final prevSales = provider.previousMonthSalesCategory;
    final curTotal = provider.currentMonthSales;
    final prevTotal = provider.previousMonthSales;
    final l10n = AppLocalizations.of(context)!;

    // Calculate growth for category Sales
    double salesGrowth = 0.0;
    if (prevSales > 0) {
      salesGrowth = ((curSales - prevSales) / prevSales) * 100;
    } else if (prevSales == 0 && curSales > 0) {
      salesGrowth = 100.0;
    }

    // Calculate growth for Total Revenue
    double totalGrowth = 0.0;
    if (prevTotal > 0) {
      totalGrowth = ((curTotal - prevTotal) / prevTotal) * 100;
    } else if (prevTotal == 0 && curTotal > 0) {
      totalGrowth = 100.0;
    }

    final salesGrowthColor = salesGrowth >= 0 ? Colors.green : Colors.red;
    final totalGrowthColor = totalGrowth >= 0 ? Colors.green : Colors.red;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.indigo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.salesComparisonMonthonmonth,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Comparison for Sales Category
            Text(
              l10n.salesCategory,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.thisMonth,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(
                            "₹${curSales.toStringAsFixed(2)}",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          _buildGrowthBadge(salesGrowth, salesGrowthColor),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.prevMonth,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹${prevSales.toStringAsFixed(2)}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Comparison for Total Revenue
            Text(
              l10n.totalRevenue,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.thisMonth,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(
                            "₹${curTotal.toStringAsFixed(2)}",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          _buildGrowthBadge(totalGrowth, totalGrowthColor),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.prevMonth,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹${prevTotal.toStringAsFixed(2)}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthBadge(double growth, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            growth >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            "${growth.abs().toStringAsFixed(1)}%",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniHeaderStat(ThemeData theme, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? Colors.white.withOpacity(0.03)
              : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? Colors.white38
                    : Colors.grey[600],
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Bar chart summarizing day-by-day cash flow for the last 7 days
  Widget _buildPLChartCard(BuildContext context, ThemeData theme, List<PLEntry> entries, Helper helper) {
    final now = DateTime.now();
    final last7Days = List.generate(7, (index) {
      return DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - index));
    });
    final l10n = AppLocalizations.of(context)!;

    double maxVal = 100.0;
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < last7Days.length; i++) {
      final day = last7Days[i];
      final dayEntries = entries.where((e) {
        return e.date.year == day.year &&
            e.date.month == day.month &&
            e.date.day == day.day;
      });

      double income = 0.0;
      double expense = 0.0;

      for (var entry in dayEntries) {
        if (entry.type == 'income') {
          income += entry.amount;
        } else {
          expense += entry.amount;
        }
      }

      if (income > maxVal) maxVal = income;
      if (expense > maxVal) maxVal = expense;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: income,
              color: Colors.green,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: expense,
              color: Colors.red,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  l10n.cashFlowLast7Days,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _buildLegendItem(Colors.green, l10n.income),
                const SizedBox(width: 8),
                _buildLegendItem(Colors.red, l10n.expense),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: _leftTitleWidgets,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) {
                          int index = val.toInt();
                          if (index >= 0 && index < last7Days.length) {
                            final d = last7Days[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                "${d.day}/${d.month}",
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _leftTitleWidgets(double value, TitleMeta meta) {
    if (value == 0) return const Text('');
    String text;
    if (value >= 1000) {
      text = '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      text = value.toStringAsFixed(0);
    }
    return SideTitleWidget(
      meta: meta,
      space: 4.0,
      child: Text(text, style: const TextStyle(fontSize: 9, color: Colors.grey)),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // Visual breakdown of Khata/Ledger outstanding balances
  Widget _buildLedgerOverviewCard(BuildContext context, ThemeData theme, DataProvider provider, Helper helper) {
    final receivables = provider.totalReceivables;
    final payables = provider.totalPayables;
    final total = receivables + payables;
    final l10n = AppLocalizations.of(context)!;

    double recPercent = 0.5;
    double payPercent = 0.5;

    if (total > 0) {
      recPercent = receivables / total;
      payPercent = payables / total;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pie_chart, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  l10n.ledgerBalanceRatio,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 120,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 30,
                        sections: [
                          PieChartSectionData(
                            color: Colors.teal,
                            value: receivables == 0 && payables == 0 ? 1 : receivables,
                            title: receivables > 0 ? '${(recPercent * 100).toStringAsFixed(0)}%' : '',
                            radius: 30,
                            titleStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.deepOrangeAccent,
                            value: receivables == 0 && payables == 0 ? 1 : payables,
                            title: payables > 0 ? '${(payPercent * 100).toStringAsFixed(0)}%' : '',
                            radius: 30,
                            titleStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIndicatorRow(
                        Colors.teal,
                        l10n.outstandingReceivables,
                        "₹${receivables.toStringAsFixed(2)}",
                        theme,
                      ),
                      const SizedBox(height: 12),
                      _buildIndicatorRow(
                        Colors.deepOrangeAccent,
                        l10n.outstandingPayables,
                        "₹${payables.toStringAsFixed(2)}",
                        theme,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(Color color, String title, String amount, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Top accounts by transactions or balance
  Widget _buildTopAccountsCard(BuildContext context, ThemeData theme, List<LedgerAccount> accounts, Helper helper) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_border, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  l10n.topActiveAccounts,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (accounts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(l10n.noTransactionsRecordedYet, style: const TextStyle(color: Colors.grey)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
                itemBuilder: (context, idx) {
                  final acc = accounts[idx];
                  final bal = acc.balance;
                  final color = bal >= 0 ? Colors.teal : Colors.red;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withOpacity(0.1),
                          child: Text(
                            acc.name.isNotEmpty ? acc.name[0].toUpperCase() : 'C',
                            style: TextStyle(color: color, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                acc.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${acc.transactions.length} ${l10n.transactions}",
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹${bal.abs().toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.bold, color: color),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bal >= 0 ? l10n.receivable : l10n.payable,
                              style: TextStyle(fontSize: 10, color: color.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(ThemeData theme, IconData icon, String title, String description) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.primary.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
