import 'package:flutter/material.dart';
import 'package:online_image_classification/controller/home_provider.dart';
import 'package:online_image_classification/ui/theme/app_colors.dart';
import 'package:online_image_classification/ui/widgets/home/home_action_buttons.dart';
import 'package:online_image_classification/ui/widgets/home/home_analyze_button.dart';
import 'package:online_image_classification/ui/widgets/home/home_app_bar.dart';
import 'package:online_image_classification/ui/widgets/home/home_crop_button.dart';
import 'package:online_image_classification/ui/widgets/home/home_error_card.dart';
import 'package:online_image_classification/ui/widgets/home/home_image_preview.dart';
import 'package:online_image_classification/ui/widgets/home/home_result_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      appBar: HomeAppBar(),
      body: _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeImagePreview(),
            SizedBox(height: 16),
            HomeResultCard(),
            SizedBox(height: 16),
            HomeErrorCard(),
            HomeActionButtons(),
            SizedBox(height: 10),
            HomeCropButton(),
            SizedBox(height: 16),
            HomeAnalyzeButton(),
          ],
        ),
      ),
    );
  }
}
