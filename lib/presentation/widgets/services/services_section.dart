import 'package:flutter/material.dart';
import 'package:follio/core/constants/app_strings.dart';
import 'package:follio/core/theme/app_colors.dart';
import 'package:follio/core/tokens/design_tokens.dart';
import 'package:follio/core/utils/responsive_utils.dart';
import 'package:follio/data/models/service_model.dart';
import 'package:follio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:follio/presentation/widgets/common/fade_slide_reveal.dart';
import 'package:follio/presentation/widgets/common/responsive_container.dart';
import 'package:follio/presentation/widgets/common/section_header.dart';
import 'package:follio/presentation/widgets/services/service_card.dart';
import 'package:provider/provider.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceModel> services = context.select<PortfolioViewModel, List<ServiceModel>>(
      (PortfolioViewModel vm) => vm.services,
    );
    final PortfolioColors colors = context.portfolioColors;
    final bool isDesktop = ResponsiveUtils.isDesktop(context);

    return Container(
      width: double.infinity,
      color: colors.sectionAlternateBackground,
      child: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const FadeSlideReveal(
              child: SectionHeader(
                category: AppStrings.servicesCategory,
                title: AppStrings.servicesTitle,
              ),
            ),
            if (isDesktop)
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: services
                        .map(
                          (ServiceModel s) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.space12,
                              ),
                              child: ServiceCard(service: s),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            else
              FadeSlideReveal(
                delay: const Duration(milliseconds: 150),
                child: Column(
                  children: services
                      .map(
                        (ServiceModel s) => Padding(
                          padding: const EdgeInsets.only(bottom: DesignTokens.space20),
                          child: SizedBox(
                            height: 280.0,
                            child: ServiceCard(service: s),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
