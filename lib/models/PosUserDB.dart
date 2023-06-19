class PosUserDb {
  PosUserDb({
    required this.status,
    required this.message,
    required this.posSessionOrderId,
    required this.posSessionTopUpId,
    required this.productsCount,
    required this.productId,
    required this.response,
    required this.termCondition,
    required this.instruction,
    required this.preOrderInstruction,
    required this.pickUp,
    required this.messagePreOrderClosed,
    required this.messageTopUpClosed,
    required this.messagePreOrderTimeClosed,
    required this.preOrderTimeFrom,
    required this.preOrderTimeTo,
    required this.canteenMenu,
    required this.unregistered,
  });

  int status;
  bool message;
  int posSessionOrderId;
  int posSessionTopUpId;
  int productsCount;
  int productId;
  List<PosUserData> response;
  String termCondition;
  String instruction;
  String preOrderInstruction;
  List<String> pickUp;
  String messagePreOrderClosed;
  String messageTopUpClosed;
  String messagePreOrderTimeClosed;
  String preOrderTimeFrom;
  String preOrderTimeTo;
  List<CanteenMenu> canteenMenu;
  String unregistered;

  factory PosUserDb.fromMap(Map<String, dynamic> json) => PosUserDb(
    status: json["status"],
    message: json["message"],
    posSessionOrderId: json["pos_session_order_id"],
    posSessionTopUpId: json["pos_session_top_up_id"],
    productsCount: json["products_count"],
    productId: json["product_id"],
    response: List<PosUserData>.from(json["response"].map((x) => PosUserData.fromMap(x))),
    termCondition: json["term_condition"],
    instruction: json["instruction"],
    preOrderInstruction: json["pre_order_instruction"],
    pickUp: List<String>.from(json["pick_up"].map((x) => x)),
    messagePreOrderClosed: json["message_pre_order_closed"],
    messageTopUpClosed: json["message_top_up_closed"],
    messagePreOrderTimeClosed: json["message_pre_order_time_closed"],
    preOrderTimeFrom: json["pre_order_time_from"],
    preOrderTimeTo: json["pre_order_time_to"],
    canteenMenu: List<CanteenMenu>.from(json["canteen_menu"].map((x) => CanteenMenu.fromMap(x))),
    unregistered: json["unregistered"],
  );
}

class CanteenMenu {
  CanteenMenu({
    required this.title,
    required this.subtitle,
  });

  String title;
  String subtitle;

  factory CanteenMenu.fromMap(Map<String, dynamic> json) => CanteenMenu(
    title: json["title"],
    subtitle: json["subtitle"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "subtitle": subtitle,
  };
}

class PosUserData {
  PosUserData({
    required this.id,
    required this.name,
    required this.cardId,
    required this.balanceCard,
    required this.campus,
    required this.purchaseLimit,
    required this.cardNo,
  });

  int id;
  String name;
  String cardId;
  double balanceCard;
  String campus;
  double purchaseLimit;
  String cardNo;

  factory PosUserData.fromMap(Map<String, dynamic> json) => PosUserData(
    id: json["id"],
    name: json["name"],
    cardId: json["card_id"],
    balanceCard: json["balance_card"],
    campus: json["campus"],
    purchaseLimit: json["purchase_limit"],
    cardNo: json["card_no"] ?? "",
  );
}
