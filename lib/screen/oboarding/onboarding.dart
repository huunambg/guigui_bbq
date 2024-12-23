import '/screen/login/login_screen.dart';
import '/widget/body_background.dart';
import 'package:gap/gap.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/screen/oboarding/widget/item_pageview_onboarding.dart';
import '/util/preferences_util.dart';
import '/util/view_ex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BodyCustom(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                controller: _pageController,
                children: const [
                  ItemPageviewOnboarding(
                    imagePath: "assets/images/onboard1.png",
                    title: "Quản lý điểm dễ dàng",
                    description:
                        "Theo dõi điểm số và tình hình học tập của học sinh mọi lúc, mọi nơi.",
                  ),
                  ItemPageviewOnboarding(
                    imagePath: "assets/images/onboard2.png",
                    title: "Báo cáo trực quan",
                    description:
                        "Xem biểu đồ, báo cáo học tập chi tiết để nắm bắt xu hướng và hiệu quả học tập.",
                  ),
                  ItemPageviewOnboarding(
                    imagePath: "assets/images/onboard3.png",
                    title: "Truy cập mọi lúc",
                    description:
                        "Sử dụng ứng dụng trên cả điện thoại và máy tính với dữ liệu đồng bộ.",
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController, // PageController
              count: 3,
              effect: SlideEffect(
                activeDotColor: GlobalColors.primary,
                dotColor: Colors.grey,
                dotHeight: 6,
                dotWidth: 6,
                radius: 10, // Tạo hình tròn
              ),
            ),
            const Gap(20),
            InkWell(
              onTap: () {
                if (_currentPage < 2) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  tapAndCheckInternet(() {
                    PreferencesUtil.setFirstTime(false);
                    Get.offAll(() => const LoginScreen());
                  });
                }
              },
              child: Container(
                height: 56.0,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    color: GlobalColors.primary,
                    borderRadius: BorderRadius.circular(16.0)),
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: GlobalTextStyles.font14w600ColorBlack,
                ),
              ),
            ),
            const Gap(20)
          ],
        ),
      ),
    );
  }
}
