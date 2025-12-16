import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/rating_controller.dart';

class ServiceRatingScreen extends StatefulWidget {
  const ServiceRatingScreen({Key? key}) : super(key: key);

  @override
  State<ServiceRatingScreen> createState() => _ServiceRatingScreenState();
}

class _ServiceRatingScreenState extends State<ServiceRatingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final ctrl = Provider.of<RatingController>(context, listen: false);
        ctrl.loadFeedbackOptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF2FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF2FB),
        elevation: 0,
        centerTitle: true,
        title: Text("Đánh giá"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00BCD4)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<RatingController>(
        builder: (context, ctrl, child) {
          if (ctrl.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00BCD4)),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Bạn thấy dịch vụ của chúng\ntôi như thế nào?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00BCD4),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      final isSelected = starIndex <= ctrl.selectedStars;

                      return GestureDetector(
                        onTap: () => ctrl.selectStar(starIndex),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            isSelected ? Icons.star : Icons.star_border,
                            color: isSelected
                                ? const Color(0xFFFFE758)
                                : const Color(0xFFFFEA76),
                            size: 48,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Feedback Question
                  const Text(
                    'Bạn chưa hài lòng ở điểm nào?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF00BCD4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Feedback Tags
                  if (ctrl.feedbackOptions.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: ctrl.feedbackOptions.map((tag) {
                        final isSelected = ctrl.selectedFeedbackTags.contains(tag);
                        return GestureDetector(
                          onTap: () => ctrl.toggleFeedbackTag(tag),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00BCD4).withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00BCD4)
                                    : const Color(0xFFABF8FD),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? const Color(0xFF00BCD4)
                                    : const Color(0xFF757575),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),

                  // Comment Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Chất lượng dịch vụ: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF757575),
                              ),
                            ),
                            const Text(
                              'đã lại đánh giá',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: ctrl.commentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Hãy chia sẻ đánh giá cho dịch vụ này bạn nhé!\nBạn có phản hồi hay dễ xuất gì không?',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                              height: 1.5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF00BCD4),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ctrl.isSubmitting
                          ? null
                          : () async {
                        if (ctrl.selectedStars == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng chọn số sao đánh giá'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final success = await ctrl.submitRating();

                        if (mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cảm ơn bạn đã đánh giá!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(ctrl.error ?? 'Có lỗi xảy ra'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BCD4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: ctrl.isSubmitting
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Gửi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}