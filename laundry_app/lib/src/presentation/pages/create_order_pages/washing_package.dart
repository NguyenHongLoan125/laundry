import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/controllers/create_order_controller.dart';
import '../../../core/constants/app_colors.dart';

class WashingPackage extends StatefulWidget {
  final List<MyWashingPackageModel> myWashingPackages;
  final VoidCallback seeAll;
  const WashingPackage({super.key, required this.myWashingPackages, required this.seeAll});

  @override
  State<WashingPackage> createState() => _WashingPackageState();
}

class _WashingPackageState extends State<WashingPackage> {

  int? _selectedIndex;
  bool _useNone = false;

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final spacingBetweenPart = (size.height * 0.02);
    final cardHeight = (size.height * 0.15);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gói giặt',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  fontSize: size.width * 0.06,
                ),
              ),
              InkWell(
                onTap: widget.seeAll,
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: (size.width * 0.05),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: spacingBetweenPart),
          // My list washing package
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.myWashingPackages.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: (size.width * 0.03).clamp(10.0, 16.0)),
            itemBuilder: (context, index) {
              final selected = !_useNone && _selectedIndex == index;

              final p = widget.myWashingPackages[index];

              return SizedBox(
                height: cardHeight,
                child: CustomMyWashingPackageCard(
                  size: size,
                  title: p.name ?? '',
                  remainingText: (p.discount!=null)
                      ? 'Bạn được giảm giá ${(p.discount!* 100).round()}%'
                      : 'Bạn được giảm giá',
                  expiryText: (p.expirationDate!=null)
                      ?'Vui lòng sử dụng trước ngày ${_formatDate(p.expirationDate)} '
                      : '',
                  selected: selected,
                  onTap: () {
                    setState(() {
                      _useNone = false;
                      _selectedIndex = (_selectedIndex == index) ? null : index;
                    });
                  },
                ),
              );
            },
          ),

          // Button for none use washing package
          _NoneUsePackageButton(
            size: size,
            selected: _useNone,
            onTap: () {
              setState(() {
                _useNone = true;
                _selectedIndex = null;
              });
            },
          ),
        ],
      ),
    );
  }
}

class CustomMyWashingPackageCard extends StatelessWidget {
  final Size size;
  final String title;
  final String remainingText;
  final String expiryText;
  final bool selected;
  final VoidCallback onTap;

  const CustomMyWashingPackageCard({
    super.key,
    required this.size,
    required this.title,
    required this.remainingText,
    required this.expiryText,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (size.width * 0.03).clamp(12.0, 18.0);
    final borderW = (size.width * 0.004).clamp(1.2, 2.0);

    final cardBg = Colors.white;
    final borderColor = AppColors.textPrimary;
    final titleColor = AppColors.text;
    final textGray = AppColors.textSecondary;

    final padH = (size.width * 0.06).clamp(18.0, 28.0);
    final padV = (size.width * 0.04).clamp(14.0, 22.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderColor, width: borderW),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                    fontSize: (size.width * 0.05).clamp(18.0, 26.0),
                  ),
                ),
                SizedBox(height: (size.width * 0.02).clamp(8.0, 14.0)),

                // status
                Text(
                  remainingText,
                  style: TextStyle(
                    color: textGray,
                    fontWeight: FontWeight.w500,
                    fontSize: (size.width * 0.03).clamp(14.0, 20.0),
                  ),
                ),
                SizedBox(height: (size.width * 0.02).clamp(10.0, 16.0)),

                // expiration date
                Text(
                  expiryText,
                  style: TextStyle(
                    color: textGray,
                    fontWeight: FontWeight.w400,
                    fontSize: (size.width * 0.04).clamp(12.0, 16.0),
                  ),
                ),
              ],
            ),
          ),

          // tick (chỉ hiện khi selected)
          if (selected)
            Positioned(
              top: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                  bottomLeft: Radius.circular((radius * 2).clamp(20.0, 40.0)),
                ),
                child: Container(
                  width: (size.width * 0.12).clamp(52.0, 72.0),
                  height: (size.width * 0.12).clamp(52.0, 72.0),
                  color: borderColor,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: (size.width * 0.05).clamp(26.0, 34.0),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoneUsePackageButton extends StatelessWidget {
  final Size size;
  final bool selected;
  final VoidCallback onTap;

  const _NoneUsePackageButton({
    required this.size,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (size.width * 0.03).clamp(12.0, 16.0);
    final bg = selected ? AppColors.textPrimary : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: (size.width * 0.05).clamp(14.0, 18.0),
          vertical: (size.width * 0.035).clamp(12.0, 16.0),
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color:AppColors.text.withOpacity(selected ? 1 : 0.35),
            width: (size.width * 0.004).clamp(1.0, 1.6),
          ),
        ),
        child: Center(
              child: Text(
                'Không sử dụng gói giặt',
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: (size.width * 0.04).clamp(13.0, 16.0),
                ),
              ),
        ),
      ),
    );
  }
}
