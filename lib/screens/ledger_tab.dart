import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dukan_tools/providers/data_provider.dart';
import 'package:dukan_tools/screens/ledger_detail_screen.dart';
import 'package:dukan_tools/models/shop.dart';

class LedgerTab extends StatefulWidget {
  const LedgerTab({super.key});

  @override
  State<LedgerTab> createState() => _LedgerTabState();
}

class _LedgerTabState extends State<LedgerTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final theme = Theme.of(context);

    if (dataProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredAccounts = dataProvider.ledgerAccounts.where((acc) {
      return acc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          acc.phone.contains(_searchQuery);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // Shop Selector Bar
          _buildShopSelector(context, theme, dataProvider),

          // Receivables vs Payables Header Card
          _buildSummaryHeaderCard(theme, dataProvider),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search customer or phone...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
            ),
          ),

          // List of Ledger Accounts
          Expanded(
            child: filteredAccounts.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: filteredAccounts.length,
                    itemBuilder: (context, index) {
                      final acc = filteredAccounts[index];
                      return _buildAccountItem(theme, acc, dataProvider);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'ledger_add_customer_fab',
        onPressed: () => _showAddCustomerDialog(context, dataProvider),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text("Add Customer"),
      ),
    );
  }

  Widget _buildSummaryHeaderCard(ThemeData theme, DataProvider provider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E2C)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  "You Will Get",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${provider.totalReceivables.toStringAsFixed(2)}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: theme.dividerColor.withOpacity(0.2)),
          Expanded(
            child: Column(
              children: [
                Text(
                  "You Will Give",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${provider.totalPayables.toStringAsFixed(2)}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isEmpty ? "No customers added yet" : "No results match your search",
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            _searchQuery.isEmpty
                ? "Tap 'Add Customer' to start logging credit entries."
                : "Try a different search query.",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(ThemeData theme, var acc, DataProvider provider) {
    final balance = acc.balance;
    Color balColor = Colors.grey;
    String balText = "Settled";
    String label = "Balance";

    if (balance > 0) {
      balColor = Colors.green;
      balText = "₹${balance.toStringAsFixed(2)}";
      label = "You will get";
    } else if (balance < 0) {
      balColor = Colors.red;
      balText = "₹${balance.abs().toStringAsFixed(2)}";
      label = "You will give";
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.08),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LedgerDetailScreen(accountId: acc.id),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: balColor.withOpacity(0.1),
          child: Text(
            acc.name.isNotEmpty ? acc.name[0].toUpperCase() : 'C',
            style: TextStyle(color: balColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          acc.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          acc.phone.isNotEmpty ? acc.phone : 'No phone number',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              balText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: balColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: balColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context, DataProvider provider) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Add New Customer Account", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name *",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone (Optional)",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  provider.addLedgerAccount(
                    nameController.text.trim(),
                    phoneController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShopSelector(BuildContext context, ThemeData theme, DataProvider provider) {
    final activeShop = provider.activeShop;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _showShopSelectorBottomSheet(context, provider),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF1E1E2C)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.storefront,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Active Shop",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activeShop.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showManageShopsDialog(context, provider),
            icon: const Icon(Icons.settings),
            tooltip: "Manage Shops",
            style: IconButton.styleFrom(
              backgroundColor: theme.brightness == Brightness.dark
                  ? const Color(0xFF1E1E2C)
                  : Colors.grey.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  void _showShopSelectorBottomSheet(BuildContext context, DataProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Switch Shop",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddShopDialog(context, provider);
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("New Shop", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.shops.length,
                  itemBuilder: (context, index) {
                    final shop = provider.shops[index];
                    final isSelected = shop.id == provider.activeShopId;
                    
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: isSelected 
                          ? theme.colorScheme.primary.withOpacity(0.08)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : theme.dividerColor.withOpacity(0.08),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          provider.setActiveShop(shop.id);
                          Navigator.pop(context);
                        },
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          child: Icon(
                            Icons.storefront,
                            color: isSelected ? theme.colorScheme.primary : Colors.grey,
                          ),
                        ),
                        title: Text(
                          shop.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAddShopDialog(BuildContext context, DataProvider provider) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Create New Shop", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Shop Name *",
                prefixIcon: Icon(Icons.storefront),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter a shop name";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  provider.addShop(nameController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void _showManageShopsDialog(BuildContext context, DataProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.storefront, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Manage Shops", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: provider.shops.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final shop = provider.shops[index];
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                            onPressed: () {
                              _showEditShopNameDialog(context, provider, shop);
                            },
                          ),
                          if (provider.shops.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              onPressed: () {
                                _confirmDeleteShop(context, provider, shop);
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddShopDialog(context, provider);
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Add Shop"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditShopNameDialog(BuildContext context, DataProvider provider, Shop shop) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: shop.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Rename Shop", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "New Shop Name *",
                prefixIcon: Icon(Icons.storefront),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter a shop name";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  provider.updateShopName(shop.id, nameController.text.trim());
                  Navigator.pop(context); // Close rename dialog
                  Navigator.pop(context); // Close manage dialog
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteShop(BuildContext context, DataProvider provider, Shop shop) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Delete Shop?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to delete '${shop.name}'? All customer accounts and ledger transaction history under this shop will be permanently deleted."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                provider.deleteShop(shop.id);
                Navigator.pop(context); // Close confirm dialog
                Navigator.pop(context); // Close manage dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Shop '${shop.name}' and its accounts deleted")),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
