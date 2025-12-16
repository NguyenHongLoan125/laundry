
class PaymentInfo {
  final String branch;
  final String orderId;
  final String createdDate;
  final String paymentMethod;

  PaymentInfo({
    required this.branch,
    required this.orderId,
    required this.createdDate,
    required this.paymentMethod,
  });
}