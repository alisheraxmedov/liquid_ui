import 'package:flutter/material.dart';
import 'package:liquid_ui/liquid_ui.dart';

void main() {
  runApp(const LiquidUIExampleApp());
}

/// Example application demonstrating the Liquid UI package.
class LiquidUIExampleApp extends StatelessWidget {
  const LiquidUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid UI Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ExamplePage(),
    );
  }
}

/// Example page showcasing various LiquidMaterial configurations.
class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Scrollable content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Spacer for navigation bar
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSection('Material Types'),
                      const SizedBox(height: 16),
                      _buildMaterialTypes(),
                      const SizedBox(height: 32),
                      _buildSection('Liquid Material with Options'),
                      const SizedBox(height: 16),
                      _buildLiquidMaterialOptions(),
                      const SizedBox(height: 32),
                      _buildSection('Legacy GlassWidget'),
                      const SizedBox(height: 16),
                      _buildGlassWidgets(),
                      const SizedBox(height: 32),
                      _buildSection('Glass Card'),
                      const SizedBox(height: 16),
                      _buildGlassCard(),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
            // Scroll-aware Navigation Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: LiquidNavigationBar(
                  scrollController: _scrollController,
                  height: 56,
                  blurOnScroll: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'Liquid UI Examples',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMaterialTypes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMaterialTypeItem('Ultra Thin', LiquidMaterialType.ultraThin),
        _buildMaterialTypeItem('Thin', LiquidMaterialType.thin),
        _buildMaterialTypeItem('Regular', LiquidMaterialType.regular),
        _buildMaterialTypeItem('Thick', LiquidMaterialType.thick),
      ],
    );
  }

  Widget _buildMaterialTypeItem(String label, LiquidMaterialType type) {
    return Column(
      children: [
        LiquidMaterial(
          type: type,
          width: 70,
          height: 70,
          borderRadius: 16,
          child: const Center(
            child: Icon(Icons.blur_on, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildLiquidMaterialOptions() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        LiquidMaterial(
          width: 150,
          height: 80,
          specularLight: true,
          noiseOverlay: false,
          child: const Center(
            child: Text(
              'Specular Light',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        LiquidMaterial(
          width: 150,
          height: 80,
          specularLight: false,
          noiseOverlay: true,
          child: const Center(
            child: Text(
              'Noise Overlay',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        LiquidMaterial(
          width: 150,
          height: 80,
          colorless: false,
          child: const Center(
            child: Text(
              'Colorless: Off',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        LiquidMaterial(
          width: 150,
          height: 80,
          colorless: true,
          child: const Center(
            child: Text(
              'Colorless: On',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GlassWidget(
          width: 80,
          height: 80,
          borderRadius: 40,
          child: const Center(
            child: Icon(Icons.flashlight_on, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(width: 20),
        GlassWidget(
          width: 80,
          height: 80,
          borderRadius: 40,
          child: const Center(
            child: Icon(Icons.camera_alt, color: Colors.white, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard() {
    return Center(
      child: LiquidMaterial(
        type: LiquidMaterialType.regular,
        width: 320,
        height: 150,
        specularLight: true,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Liquid Glass Card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'True iOS liquid material with specular light, colorless mode, and adaptive performance.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
