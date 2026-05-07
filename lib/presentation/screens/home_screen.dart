import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newscloud_marcelo_davila/presentation/screens/detail_screen.dart';
import 'package:newscloud_marcelo_davila/presentation/widgets/shimmer_loading.dart';

import '../../logic/news_cubit.dart';
import '../../logic/news_state.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final Map<String, IconData> _allCategories = {
    'general': Icons.home_outlined,
    'technology': Icons.memory_outlined,
    'business': Icons.business_center_outlined,
    'science': Icons.science_outlined,
    'sports': Icons.sports_soccer_outlined,
    'health': Icons.health_and_safety_outlined,
    'entertainment': Icons.movie_outlined,
  };

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().fetchNewsByTab(_allCategories.keys.toList()[_currentIndex]);
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return; 
    
    setState(() {
      _currentIndex = index;
    });
    context.read<NewsCubit>().fetchNewsByTab(_allCategories.keys.toList()[index]);
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF121414);
    
    return Scaffold(
      backgroundColor: bgColor,
      drawer: _buildSidebar(context),
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'NewsCloud',
          style: TextStyle(
            color: Color(0xFFE2E2E2),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF9CE39E)),
          onPressed: () {},
        ),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial || state is NewsLoading) {
            return const ShimmerLoading();
          } else if (state is NewsError) {
            return RefreshIndicator(
              onRefresh: () => context.read<NewsCubit>().fetchNewsByTab(
                _allCategories.keys.toList()[_currentIndex],
              ),
              color: const Color(0xFF9CE39E),
              backgroundColor: const Color(0xFF1E2020),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Color(0xFFFFB4AB), size: 60),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFE2E2E2), fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9CE39E)),
                            onPressed: () => context.read<NewsCubit>().fetchNewsByTab(_allCategories.keys.toList()[_currentIndex]),
                            child: const Text('Reintentar', style: TextStyle(color: Color(0xFF003911))),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is NewsLoaded) {
            final articles = state.articles;
            
            if (articles.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<NewsCubit>().fetchNewsByTab(
                  _allCategories.keys.toList()[_currentIndex],
                ),
                color: const Color(0xFF9CE39E),
                backgroundColor: const Color(0xFF1E2020),
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 500,
                    child: Center(
                      child: Text('No hay noticias disponibles.', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NewsCubit>().fetchNewsByTab(
                _allCategories.keys.toList()[_currentIndex],
              ),
              color: const Color(0xFF9CE39E),
              backgroundColor: const Color(0xFF1E2020),
              child: ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return NewsCard(
                    article: articles[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(article: articles[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF1E2020),
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: const Color(0xFF99F1DD), 
          unselectedItemColor: const Color(0xFFC0C9BC),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.home_outlined, 0),
              activeIcon: _buildNavIcon(Icons.home, 0, isActive: true),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.memory_outlined, 1),
              activeIcon: _buildNavIcon(Icons.memory, 1, isActive: true),
              label: 'Technology',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.business_center_outlined, 2),
              activeIcon: _buildNavIcon(Icons.business_center, 2, isActive: true),
              label: 'Business',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121414),
      child: Column(
        children: [
          // Header del Sidebar
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1E2020)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_queue, size: 50, color: Color(0xFF9CE39E)),
                  const SizedBox(height: 10),
                  const Text(
                    'FILTRAR NOTICIAS',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),
          ),
          // Listado de Categorías
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _allCategories.entries.map((entry) {
                return ListTile(
                  leading: Icon(entry.value, color: const Color(0xFFA7FFEB)),
                  title: Text(
                    entry.key.toUpperCase(),
                    style: const TextStyle(color: Color(0xFFC0C9BC), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    // Cierra el sidebar
                    Navigator.pop(context);
                    // Dispara la lógica de filtrado
                    context.read<NewsCubit>().fetchNewsByTab(entry.key);
                  },
                );
              }).toList(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("v1.0.0 - Universidad Nur", style: TextStyle(color: Colors.grey, fontSize: 10)),
          )
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF007061) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon),
    );
  }
}