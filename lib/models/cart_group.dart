class CartGroup {
  final int groupId;
  final String groupName;
  final int cost;
  final List<int> storeIds;
  final List<MatchedStore> matchedStores;

  CartGroup({
    required this.groupId,
    required this.groupName,
    required this.cost,
    required this.storeIds,
    required this.matchedStores,
  });

  factory CartGroup.fromJson(Map<String, dynamic> json) {
    return CartGroup(
      groupId: json['group_id'],
      groupName: json['group_name'],
      cost: json['cost'],
      storeIds: List<int>.from(json['store_ids'] ?? []),
      matchedStores:
          (json['matched_stores'] as List<dynamic>)
              .map((e) => MatchedStore.fromJson(e))
              .toList(),
    );
  }
}

class MatchedStore {
  final int id;
  final String name;

  MatchedStore({required this.id, required this.name});

  factory MatchedStore.fromJson(Map<String, dynamic> json) {
    return MatchedStore(id: json['id'], name: json['name']);
  }
}
