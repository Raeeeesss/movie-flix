import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/services/movie_stream_service.dart';
import '../../models/movie.dart';

class FullMoviePlayerScreen extends StatefulWidget {
  final Movie movie;

  const FullMoviePlayerScreen({super.key, required this.movie});

  @override
  State<FullMoviePlayerScreen> createState() => _FullMoviePlayerScreenState();
}

class _FullMoviePlayerScreenState extends State<FullMoviePlayerScreen> {
  late YoutubePlayerController _ytController;
  final MovieStreamService _streamService = MovieStreamService();
  bool _isPlayerReady = false;
  String _selectedQuality = '1080p Full HD';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final videoKey = _streamService.getYoutubeVideoKey(widget.movie);

    _ytController = YoutubePlayerController.fromVideoId(
      videoId: videoKey,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        strictRelatedVideos: true,
      ),
    );

    _ytController.listen((event) {
      if (mounted && !_isPlayerReady) {
        setState(() => _isPlayerReady = true);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _ytController.close();
    super.dispose();
  }

  Future<void> _launchExternalArchiveEmbed() async {
    final embedUrl = _streamService.getArchiveEmbedUrl(widget.movie);
    final uri = Uri.parse(embedUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchTorrentDownload() async {
    final torrentUrl = _streamService.getTorrentUrl(widget.movie);
    final uri = Uri.parse(torrentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // ── Main HD Video Stream Player ─────────────────────────────────
            Center(
              child: YoutubePlayer(
                controller: _ytController,
                aspectRatio: 16 / 9,
              ),
            ),

            // ── Top Header Navigation Bar ────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 8,
                  16,
                  16,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 2,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryAccent.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'FREE STREAM',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                _selectedQuality,
                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Torrent Download Action Button
                    IconButton(
                      icon: const Icon(Icons.download_rounded, color: Colors.white),
                      tooltip: 'Download Torrent',
                      onPressed: _launchTorrentDownload,
                    ),

                    // Quality Selection Menu
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.settings_rounded, color: Colors.white),
                      tooltip: 'Stream Settings',
                      onSelected: (q) {
                        setState(() => _selectedQuality = q);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Switched playback stream to $q')),
                        );
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: '1080p Full HD', child: Text('1080p Full HD')),
                        const PopupMenuItem(value: '720p HD', child: Text('720p HD')),
                        const PopupMenuItem(value: '480p SD', child: Text('480p SD')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Alternative Stream Options Bar ───────────────────────
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _launchExternalArchiveEmbed,
                    icon: const Icon(Icons.public_rounded, color: Colors.white, size: 18),
                    label: const Text(
                      'Internet Archive Player',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _launchTorrentDownload,
                    icon: const Icon(Icons.file_download_outlined, color: Colors.white, size: 18),
                    label: const Text(
                      'Public Domain Torrent',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
