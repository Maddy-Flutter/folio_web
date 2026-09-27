import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/testimonial_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/section_header.dart';
import 'package:follio/presentation/widgets/testimonials/testimonial_card.dart';
import 'package:provider/provider.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TestimonialModel> testimonials =
        context.select<PortfolioViewModel, List<TestimonialModel>>(
      (PortfolioViewModel vm) => vm.testimonials,
    );
    final bool isDesktop = ResponsiveUtils.isDesktop(context);

    return ResponsiveContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const FadeSlideReveal(
            child: SectionHeader(
              category: AppStrings.reviewsCategory,
              title: AppStrings.reviewsTitle,
            ),
          ),
          if (isDesktop)
            FadeSlideReveal(
              delay: const Duration(milliseconds: 150),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: testimonials.asMap().entries.map((MapEntry<int, TestimonialModel> entry) {
                    final int idx = entry.key;
                    final TestimonialModel t = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.space12,
                        ),
                        child: TestimonialCard(
                          testimonial: t,
                          isHighlighted: idx == 1,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          else
            FadeSlideReveal(
              delay: const Duration(milliseconds: 150),
              child: Column(
                children: testimonials.asMap().entries.map((MapEntry<int, TestimonialModel> entry) {
                  final int idx = entry.key;
                  final TestimonialModel t = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.space20),
                    child: SizedBox(
                      height: 250.0,
                      child: TestimonialCard(
                        testimonial: t,
                        isHighlighted: idx == 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
