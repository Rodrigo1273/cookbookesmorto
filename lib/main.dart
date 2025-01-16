import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cookbookesmorto/pages/design_page.dart';
import 'package:cookbookesmorto/pages/forms_page.dart';
import 'package:cookbookesmorto/pages/images_page.dart';
import 'package:cookbookesmorto/pages/lists_page.dart';
import 'package:cookbookesmorto/pages/navigation_page.dart';

void main() {
  runApp(const CookbookEsmorto());
}

class CookbookEsmorto extends StatelessWidget {
  const CookbookEsmorto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookbook Esmorto',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC70039), // Rojo vibrante
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC70039), // Rojo vibrante
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = true;

  final categories = [
    {
      'title': 'Diseño IU',
      'icon': 'assets/lottie/design.json',
      'route': const DesignPage(),
      'color': const Color(0xFF581845), // Púrpura oscuro
      'description': 'Explora diseños creativos.',
    },
    {
      'title': 'Formulario',
      'icon': 'assets/lottie/forms.json',
      'route': const FormsPage(),
      'color': const Color(0xFF900C3F), // Vino intenso
      'description': 'Crea formularios dinámicos.',
    },
    {
      'title': 'Imágenes Dinámicas',
      'icon': 'assets/lottie/images.json',
      'route': const ImagesPage(),
      'color': const Color(0xFFC70039), // Rojo vibrante
      'description': 'Añade imágenes con animación.',
    },
    {
      'title': 'Listas',
      'icon': 'assets/lottie/lists.json',
      'route': const ListsPage(),
      'color': const Color(0xFFFF5733), // Naranja brillante
      'description': 'Gestiona listas fácilmente.',
    },
    {
      'title': 'Navegación',
      'icon': 'assets/lottie/navigation.json',
      'route': const NavigationPage(),
      'color': const Color(0xFFFFC305), // Amarillo cálido
      'description': 'Navega entre pantallas.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Cookbook Esmorto',
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              background: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(204),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.darken,
                child: Image.network(
                  'https://picsum.photos/800/400',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _isLoading
                ? SliverToBoxAdapter(
              child: _buildShimmerLoading(),
            )
                : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(category);
                },
                childCount: categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 8,
      shadowColor: (category['color'] as Color).withAlpha(102),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => category['route'] as Widget),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                category['color'] as Color,
                (category['color'] as Color).withAlpha(179),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  category['icon'] as String,
                  height: 80,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  category['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  category['description'] as String,
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
