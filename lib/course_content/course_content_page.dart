// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// class CourseContentPage extends StatefulWidget {
//   final List<dynamic> courseDataContent;

//   CourseContentPage({required this.courseDataContent});

//   @override
//   _CourseContentPageState createState() => _CourseContentPageState();
// }

// class _CourseContentPageState extends State<CourseContentPage> {
//   initState() {
//     super.initState();
//     print("Contenido del curso: ${widget.courseDataContent}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Contenido del Curso"),
//       ),
//       body: ListView.builder(
//         itemCount: widget.courseDataContent.length,
//         itemBuilder: (context, sectionIndex) {
//           final section = widget.courseDataContent[sectionIndex];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ExpansionTile(
//               title: Text(
//                 section['name'],
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: HtmlWidget(
//                 section['summary'],
//                 textStyle: TextStyle(fontSize: 14),
//               ),
//               // Text(
//               //   _stripHtml(section['summary']),
//               //   maxLines: 3,
//               //   overflow: TextOverflow.ellipsis,
//               // ),
//               children: [
//                 ..._buildModules(section['modules']),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   List<Widget> _buildModules(List<dynamic> modules) {
//     return modules.map((module) {
//       return ListTile(
//         title: Text(module['name']),
//         subtitle: module['description'] != null
//             ? HtmlWidget(
//                 module['description'],
//                 textStyle: TextStyle(fontSize: 14),
//               )
//             // Text(
//             //     _stripHtml(module['description']),
//             //     maxLines: 2,
//             //     overflow: TextOverflow.ellipsis,
//             //   )
//             : null,
//         trailing: module['contents'] != null && module['contents'].isNotEmpty
//             ? IconButton(
//                 icon: Icon(Icons.download),
//                 onPressed: () {
//                   HtmlWidget(
//                     module['contents'],
//                     textStyle: TextStyle(fontSize: 14),
//                   );
//                   // _handleDownload(module['contents']);
//                 },
//               )
//             : null,
//         onTap: module['contents'] != null
//             ? () {
//                 // Manejo adicional para contenido multimedia o archivos
//                 HtmlWidget(
//                   module['contents'],
//                   textStyle: TextStyle(fontSize: 14),
//                 );
//                 // _handleDownload(module['contents']);
//               }
//             : null,
//       );
//     }).toList();
//   }

//   void _handleDownload(List<dynamic> contents) {
//     for (var content in contents) {
//       print("Descargando archivo: ${content['filename']}");
//       print("URL del archivo: ${content['fileurl']}");
//       // Aquí puedes implementar la lógica para descargar el archivo
//     }
//   }

//   String _stripHtml(String htmlText) {
//     final document = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
//     return htmlText.replaceAll(document, '').trim();
//   }
// }
import 'package:celar_app/campus/campus_controler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseContentPage extends StatefulWidget {
  final List<dynamic> courseDataContent;
  final int index;

  CourseContentPage({required this.courseDataContent, required this.index});

  @override
  _CourseContentPageState createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  final campusController = CampusController();
  Map<String, dynamic> dataAssignments = {};

  @override
  void initState() {
    super.initState();
    _fetchContentAssignment();
  }

  void _fetchContentAssignment() async {
    dataAssignments = await campusController.fetchDataObject(
      '0443e79b541a5407da7414598bf4e602',
      'mod_assign_get_assignments',
      {'courseids[0]': '${widget.index}'},
    );

    print("Tareas del curso: $dataAssignments");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contenido del Curso"),
      ),
      body: ListView.builder(
        itemCount: widget.courseDataContent.length,
        itemBuilder: (context, sectionIndex) {
          final section = widget.courseDataContent[sectionIndex];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(
                section['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: section['summary'].contains('src="') &&
                      section['summary'] != null
                  ? null
                  : HtmlWidget(
                      section['summary'],
                      textStyle: TextStyle(fontSize: 14),
                    ),
              children: [
                ..._buildModules(section['modules']),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildModules(List<dynamic> modules) {
    // Verificar que dataAssignments y courses no sean nulos
    final courses = dataAssignments['courses'];
    final assignments = (courses != null && courses.isNotEmpty)
        ? courses[0]['assignments'] ?? []
        : [];

    return modules.map((module) {
      print("Modulo: ${module['id']}");

      // Buscar asignación relacionada al módulo por ID
      final assignment = assignments.isNotEmpty
          ? assignments.firstWhere(
              (assignment) => assignment['cmid'] == module['id'],
              orElse: () => null,
            )
          : null;

      // Verificar si assignment no es nulo y si tiene intro
      final hasIntro = assignment != null &&
          assignment['intro'] != null &&
          assignment['intro'].isNotEmpty;

      return Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: hasIntro
            ? ExpansionTile(
                title: Text(
                  module['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: module['description'] != null &&
                        module['description'].contains('src="')
                    ? null
                    : module['description'] != null
                        ? HtmlWidget(
                            module['description'],
                            textStyle: TextStyle(fontSize: 14),
                          )
                        : null,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlWidget(
                      assignment['intro'],
                      textStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              )
            : ListTile(
                title: Text(module['name']),
                subtitle: module['description'] != null &&
                        module['description'].contains('src="')
                    ? Image.network(extractImageUrl(module['description']))
                    : module['description'] != null
                        ? HtmlWidget(
                            module['description'],
                            textStyle: TextStyle(fontSize: 14),
                          )
                        : null,
                trailing:
                    module['contents'] != null && module['contents'].isNotEmpty
                        ? Icon(Icons.play_arrow)
                        : null,
                onTap: () {
                  print("Contenido del módulo: ${module['url']}");
                  if (module['contents'] != null &&
                      module['contents'].isNotEmpty) {
                    _handleNestedContents(module['contents']);
                  } else if (module['url'] != null) {
                    _launchURL(module['url']);
                  }
                },
              ),
      );
    }).toList();
  }

  String extractImageUrl(String html) {
    print("HTML: $html");
    final regex = RegExp(r'src="([^"]+)"');
    final match = regex.firstMatch(html);
    if (match != null && match.groupCount > 0) {
      print("HTML: ${match.group(1)}");
      return match.group(1)!; // Retorna la URL encontrada
    }
    return ''; // Retorna una cadena vacía si no encuentra la URL
  }

  void _handleVideo(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoUrl: url),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleNestedContents(List<dynamic> contents) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NestedContentsPage(contents: contents),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reproduciendo Video"),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class NestedContentsPage extends StatelessWidget {
  final List<dynamic> contents;

  NestedContentsPage({required this.contents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contenidos"),
      ),
      body: ListView.builder(
        itemCount: contents.length,
        itemBuilder: (context, index) {
          final content = contents[index];
          return ListTile(
            title: Text(content['filename'] ?? 'Sin nombre'),
            subtitle: Text(content['fileurl'] ?? 'Sin URL'),
            onTap: () {
              if (content['fileurl'] != null &&
                  content['fileurl'].contains('.mp4')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoPlayerScreen(videoUrl: content['fileurl']),
                  ),
                );
              } else if (content['fileurl'] != null) {
                _launchURL(content['fileurl']);
              }
            },
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
