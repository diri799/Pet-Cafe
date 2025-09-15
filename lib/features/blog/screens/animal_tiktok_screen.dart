import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalTikTokScreen extends StatefulWidget {
  const AnimalTikTokScreen({super.key});

  @override
  State<AnimalTikTokScreen> createState() => _AnimalTikTokScreenState();
}

class _AnimalTikTokScreenState extends State<AnimalTikTokScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [];
  final Set<String> _likedVideos = {};
  final Set<String> _favoriteVideos = {};
  final Map<String, VideoPlayerController> _videoControllers = {};
  final Map<String, bool> _isPlaying = {};
  SharedPreferences? _prefs;

  final List<Map<String, dynamic>> _videos = [
    {
      'id': '1',
      'title': 'Cute Dog Playing',
      'description': 'Watch this adorable golden retriever having fun in the park',
      'videoUrl': 'assets/images/mixkit-dog-catches-a-ball-in-a-river-1494-4k.mp4',
      'thumbnail': 'assets/images/dog1.jpg',
      'likes': 1250,
      'comments': 89,
      'shares': 45,
      'author': 'PetLover123',
    },
    {
      'id': '2',
      'title': 'Cat Training Tips',
      'description': 'Learn how to train your cat with these simple techniques',
      'videoUrl': 'assets/images/mixkit-pet-owner-playing-with-a-cute-cat-1779-full-hd.mp4',
      'thumbnail': 'assets/images/pet1.jpg',
      'likes': 890,
      'comments': 67,
      'shares': 23,
      'author': 'CatWhisperer',
    },
    {
      'id': '3',
      'title': 'Exotic Bird Feeding',
      'description': 'Beautiful macaw parrot enjoying its meal in the wild',
      'videoUrl': 'assets/images/mixkit-macaw-parrot-feeding-on-a-branch-4669-4k.mp4',
      'thumbnail': 'assets/images/pet2.jpg',
      'likes': 2100,
      'comments': 156,
      'shares': 78,
      'author': 'BirdWatcher',
    },
    {
      'id': '4',
      'title': 'Lizard in Nature',
      'description': 'Amazing close-up of a lizard in its natural habitat',
      'videoUrl': 'assets/images/mixkit-lizard-over-a-trunk-at-nature-closeup-1473-4k.mp4',
      'thumbnail': 'assets/images/pet3.jpg',
      'likes': 750,
      'comments': 34,
      'shares': 12,
      'author': 'NatureExplorer',
    },
    {
      'id': '5',
      'title': 'Dog Sitting Serenely',
      'description': 'Peaceful moment of a dog sitting by the water',
      'videoUrl': 'assets/images/mixkit-dog-sitting-on-log-1550-4k.mp4',
      'thumbnail': 'assets/images/dog2.jpg',
      'likes': 1680,
      'comments': 98,
      'shares': 56,
      'author': 'ZenPets',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadComments();
    _initializeVideos();
    _loadPersistentData();
  }

  Future<void> _initializeVideos() async {
    for (var video in _videos) {
      final videoId = video['id'];
      final videoUrl = video['videoUrl'];
      
      try {
        final controller = VideoPlayerController.asset(videoUrl);
        await controller.initialize();
        _videoControllers[videoId] = controller;
        _isPlaying[videoId] = false;
      } catch (e) {
        debugPrint('Error initializing video $videoId: $e');
      }
    }
    
    // Start playing the first video
    if (_videos.isNotEmpty) {
      _playVideo(_videos[0]['id']);
    }
  }

  Future<void> _loadPersistentData() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load liked videos
    final likedVideos = _prefs?.getStringList('liked_videos') ?? [];
    _likedVideos.addAll(likedVideos);
    
    // Load favorite videos
    final favoriteVideos = _prefs?.getStringList('favorite_videos') ?? [];
    _favoriteVideos.addAll(favoriteVideos);
    
    setState(() {});
  }

  Future<void> _savePersistentData() async {
    await _prefs?.setStringList('liked_videos', _likedVideos.toList());
    await _prefs?.setStringList('favorite_videos', _favoriteVideos.toList());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _commentController.dispose();
    
    // Dispose all video controllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    
    super.dispose();
  }

  void _playVideo(String videoId) {
    // Pause all other videos
    for (var entry in _videoControllers.entries) {
      if (entry.key != videoId) {
        entry.value.pause();
        _isPlaying[entry.key] = false;
      }
    }
    
    // Play the selected video
    final controller = _videoControllers[videoId];
    if (controller != null) {
      controller.play();
      _isPlaying[videoId] = true;
    }
  }

  void _pauseVideo(String videoId) {
    final controller = _videoControllers[videoId];
    if (controller != null) {
      controller.pause();
      _isPlaying[videoId] = false;
    }
  }

  void _toggleVideoPlayback(String videoId) {
    if (_isPlaying[videoId] == true) {
      _pauseVideo(videoId);
    } else {
      _playVideo(videoId);
    }
  }

  void _loadComments() {
    _comments.addAll([
      {
        'id': '1',
        'author': 'PetLover123',
        'content': 'So cute! My dog does the same thing! 🐕',
        'time': '2 hours ago',
        'likes': 5,
      },
      {
        'id': '2',
        'author': 'DogOwner',
        'content': 'Amazing video! Thanks for sharing.',
        'time': '4 hours ago',
        'likes': 3,
      },
      {
        'id': '3',
        'author': 'AnimalFan',
        'content': 'This made my day! 😍',
        'time': '1 day ago',
        'likes': 8,
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're in veterinarian or shelter context
    final currentRoute = GoRouterState.of(context).uri.path;
    final isVetContext = currentRoute == '/vet-animal-feed';
    final isShelterContext = currentRoute == '/shelter-animal-feed';
    final isSpecialContext = isVetContext || isShelterContext;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Back button for vet or shelter context
          if (isSpecialContext)
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  icon: const Icon(Iconsax.arrow_left, color: Colors.white),
                  onPressed: () => context.go(isVetContext ? '/vet-dashboard' : '/shelter-dashboard'),
                  tooltip: 'Back to Dashboard',
                ),
              ),
            ),
          // Video Player
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              // Play the new video when page changes
              if (index < _videos.length) {
                _playVideo(_videos[index]['id']);
              }
            },
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              return _buildVideoCard(video);
            },
          ),
          
          // Top App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isVetContext) {
                          context.go('/vet-blog');
                        } else if (isShelterContext) {
                          context.go('/shelter-blog');
                        } else {
                          context.go('/blog');
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Text(
                      'Animal Feed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Search functionality
                      },
                      icon: const Icon(
                        Iconsax.search_normal,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Right Side Actions
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                _buildActionButton(
                  icon: _likedVideos.contains(_videos[_currentIndex]['id']) 
                      ? Iconsax.heart5 
                      : Iconsax.heart,
                  count: _videos[_currentIndex]['likes'],
                  onTap: () => _toggleLike(),
                  isLiked: _likedVideos.contains(_videos[_currentIndex]['id']),
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  icon: Iconsax.message,
                  count: _videos[_currentIndex]['comments'],
                  onTap: () => _showComments(),
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  icon: Iconsax.share,
                  count: _videos[_currentIndex]['shares'],
                  onTap: () => _shareVideo(),
                ),
                const SizedBox(height: 20),
                _buildActionButton(
                  icon: Iconsax.more,
                  onTap: () => _showMoreOptions(),
                ),
              ],
            ),
          ),
          
          // Bottom Info
          Positioned(
            bottom: 0,
            left: 0,
            right: 80,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _videos[_currentIndex]['author'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _videos[_currentIndex]['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _videos[_currentIndex]['description'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    final videoId = video['id'];
    final controller = _videoControllers[videoId];
    final isPlaying = _isPlaying[videoId] ?? false;
    
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player
          if (controller != null && controller.value.isInitialized)
            GestureDetector(
              onTap: () => _toggleVideoPlayback(videoId),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            )
          else
            Container(
              color: Colors.grey[900],
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          
          // Play/Pause Button Overlay
          if (!isPlaying)
            Center(
              child: GestureDetector(
                onTap: () => _toggleVideoPlayback(videoId),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          
          // Video Progress Bar
          if (controller != null && controller.value.isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  backgroundColor: Colors.white24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    required VoidCallback onTap,
    bool isLiked = false,
  }) {
    return Column(
      children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isLiked ? Colors.red : Colors.white,
                size: 24,
              ),
            ),
          ),
        if (count != null) ...[
          const SizedBox(height: 4),
          Text(
            _formatCount(count),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  void _toggleLike() {
    setState(() {
      final videoId = _videos[_currentIndex]['id'];
      if (_likedVideos.contains(videoId)) {
        _likedVideos.remove(videoId);
        _videos[_currentIndex]['likes']--;
      } else {
        _likedVideos.add(videoId);
        _videos[_currentIndex]['likes']++;
      }
    });
    
    // Save to persistent storage
    _savePersistentData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_likedVideos.contains(_videos[_currentIndex]['id']) ? 'Liked!' : 'Unliked!'),
        backgroundColor: _likedVideos.contains(_videos[_currentIndex]['id']) ? Colors.red : Colors.grey,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Comments header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Comments list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              comment['author'].toString().substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['author'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment['content'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      comment['time'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: () => _likeComment(index),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Iconsax.heart,
                                            size: 16,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            comment['likes'].toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Comment input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _postComment(),
                      icon: const Icon(
                        Iconsax.send_1,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video shared!'),
        backgroundColor: AppTheme.primaryColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _likeComment(int index) {
    setState(() {
      _comments[index]['likes']++;
    });
  }

  void _postComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'author': 'You',
          'content': _commentController.text.trim(),
          'time': 'now',
          'likes': 0,
        });
        _videos[_currentIndex]['comments']++;
      });
      _commentController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment posted!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _toggleFavorite() {
    setState(() {
      final videoId = _videos[_currentIndex]['id'];
      if (_favoriteVideos.contains(videoId)) {
        _favoriteVideos.remove(videoId);
      } else {
        _favoriteVideos.add(videoId);
      }
    });
    
    // Save to persistent storage
    _savePersistentData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_favoriteVideos.contains(_videos[_currentIndex]['id']) 
            ? 'Added to favorites!' 
            : 'Removed from favorites!'),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(_favoriteVideos.contains(_videos[_currentIndex]['id']) 
                  ? Iconsax.bookmark_25 
                  : Iconsax.bookmark),
              title: Text(_favoriteVideos.contains(_videos[_currentIndex]['id']) 
                  ? 'Remove from Favorites' 
                  : 'Save to Favorites'),
              onTap: () {
                Navigator.pop(context);
                _toggleFavorite();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.flag),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Report submitted'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.copy),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link copied to clipboard'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
