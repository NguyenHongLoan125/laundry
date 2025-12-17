import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/auth/data/models/service_model.dart';
import '../../../core/constants/app_colors.dart';

class RecentOrders extends StatelessWidget {
  final List<OrderModel> order;
  final VoidCallback seeAll;

  const RecentOrders({super.key, required this.order, required this.seeAll});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final recentOrderHeight = size.height * 0.18;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đơn giặt gần đây',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  fontSize: size.width * 0.06,
                ),
              ),
              InkWell(
                onTap: seeAll,
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: size.width * 0.05,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: size.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: recentOrderHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: (size.width * 0.010).clamp(4.0, 10.0),
                  right: (size.width * 0.020).clamp(8.0, 16.0),
                ),
                clipBehavior: Clip.none,
                itemCount: order.length + 1,

                separatorBuilder: (_, index) {
                  final gapSmall = (size.width * 0.020).clamp(8.0, 14.0);
                  final gapBig = (size.width * 0.025).clamp(10.0, 18.0);
                  return SizedBox(width: index == 0 ? gapBig : gapSmall);
                },

                itemBuilder: (context, index) {
                  final createWidth = size.width * 0.26;
                  final cardWidth = (size.width * 0.58).clamp(220.0, size.width * 0.75);

                  if (index == 0) {
                    return SizedBox(
                      width: createWidth,
                      child: CreateOrder(
                        size: size,
                        height: recentOrderHeight,
                        onTap: () {},
                      ),
                    );
                  }

                  final o = order[index - 1];
                  final theme = _themeByStatus(o.status);

                  return SizedBox(
                    width: cardWidth,
                    child: RecentOrderCard(
                      order: o,
                      onTap: () {},
                      height: recentOrderHeight,
                      size: size,
                      bgColor: theme.bgColor,
                      bgCircleIcon: theme.bgCircleIcon,
                      colorTextAndStatus: theme.colorTextAndStatus,
                    ),
                  );
                },
              ),
            ),

          ),
        ],
      ),
    );
  }
}

//nút add
class CreateOrder extends StatelessWidget {
  final double height;
  final Size size;
  final VoidCallback? onTap;

  const CreateOrder({
    super.key,
    required this.size,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          width: size.width * 0.26,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1.5, color: AppColors.textPrimary),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.textPrimary, width: 2),
                ),
                child: CircleAvatar(
                  radius: size.width * 0.06,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    color: AppColors.textPrimary,
                    size: size.width * 0.07,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'Tạo đơn',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: size.height * 0.017,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//1 đơn
class RecentOrderCard extends StatelessWidget {
  final double height;
  final Size size;

  final OrderModel order;
  final VoidCallback onTap;

  final Color bgColor, bgCircleIcon, colorTextAndStatus;

  const RecentOrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.height,
    required this.size,
    required this.bgColor,
    required this.bgCircleIcon,
    required this.colorTextAndStatus,
  });

  Widget iconForStatus(OrderStatus? status) {
    switch (status) {
      case OrderStatus.cancelled:
        return Image.asset(
          'lib/src/assets/images/red_washer.png',
          width: size.width * 0.10,
          height: size.width * 0.10,
          fit: BoxFit.contain,
        );
      case OrderStatus.completed:
        return Image.asset(
          'lib/src/assets/images/green_washer.png',
          width: size.width * 0.10,
          height: size.width * 0.10,
          fit: BoxFit.contain,
        );
      case OrderStatus.processing:
      default:
        return Image.asset(
          'lib/src/assets/images/blue_washer.png',
          width: size.width * 0.10,
          height: size.width * 0.10,
          fit: BoxFit.contain,
        );
    }
  }

  String statusText(OrderStatus? status) {
    switch (status) {
      case OrderStatus.cancelled:
        return 'Đã huỷ';
      case OrderStatus.completed:
        return 'Hoàn thành';
      case OrderStatus.processing:
      default:
        return 'Đang xử lý';
    }
  }

  String formatDate(DateTime? d) {
    if (d == null) return '--/--/----';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  String formatVnd(double? value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write('.');
    }
    return '${buf.toString()}đ';
  }

  @override
  Widget build(BuildContext context) {
    final idText = order.id ?? '#---';
    final dateText = formatDate(order.date);
    final priceText = formatVnd(order.price);
    final sttText = statusText(order.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          // bỏ padding ở đây để Positioned chạm sát viền card
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1.5, color: colorTextAndStatus),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: size.width * 0.16,
                      height: size.width * 0.16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bgCircleIcon,
                        border: Border.all(width: 2, color: colorTextAndStatus),
                      ),
                      child: iconForStatus(order.status),
                    ),

                    SizedBox(width: (size.width * 0.03).clamp(8.0, 14.0)),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ID
                          Text(
                            idText,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: TextStyle(
                              color: colorTextAndStatus,
                              fontWeight: FontWeight.w700,
                              fontSize: (size.width * 0.038).clamp(12.0, 16.0),
                            ),
                          ),

                          SizedBox(height: (size.width * 0.012).clamp(4.0, 8.0)),

                          // Dòng 2: Date
                          Row(
                            children: [
                              Text(
                                dateText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colorTextAndStatus,
                                  fontSize: (size.width * 0.034).clamp(11.0, 14.0),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: (size.width * 0.02).clamp(6.0, 10.0)),
                          //price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                priceText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colorTextAndStatus,
                                  fontWeight: FontWeight.w700,
                                  fontSize: (size.width * 0.038).clamp(12.0, 16.0),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: (size.width * 0.03).clamp(10.0, 14.0),
                    vertical: (size.width * 0.018).clamp(6.0, 10.0),
                  ),
                  decoration: BoxDecoration(
                    color: colorTextAndStatus,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular((size.width * 0.04).clamp(12.0, 18.0)),
                      bottomRight: const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    sttText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: (size.width * 0.032).clamp(11.0, 13.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTheme {
  final Color bgColor;
  final Color bgCircleIcon;
  final Color colorTextAndStatus;

  const _OrderTheme({
    required this.bgColor,
    required this.bgCircleIcon,
    required this.colorTextAndStatus,
  });
}

_OrderTheme _themeByStatus(OrderStatus? status) {
  switch (status) {
    case OrderStatus.cancelled:
      return const _OrderTheme(
        bgColor: Color(0xFFFFEEF3),
        bgCircleIcon: Colors.white,
        colorTextAndStatus: Color(0xFFFF1F4B),
      );

    case OrderStatus.completed:
      return const _OrderTheme(
        bgColor: Color(0xFFE9FFFB),
        bgCircleIcon: Colors.white,
        colorTextAndStatus: Color(0xFF00A690),
      );

    case OrderStatus.processing:
    default:
      return const _OrderTheme(
        bgColor: Color(0xFFEFF5FF),
        bgCircleIcon: Colors.white,
        colorTextAndStatus: Color(0xFF2563EB),
      );
  }
}
