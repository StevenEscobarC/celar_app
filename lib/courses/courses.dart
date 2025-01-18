import 'package:celar_app/common/custom_app_bar.dart';
import 'package:celar_app/courses/courses_controller.dart';
import 'package:celar_app/models/courses.dart';
import 'package:flutter/material.dart';

/// Página para mostrar los cursos disponibles y permitir la inscripción.
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  CoursesController coursesController = CoursesController();
  List<CourseData> courses = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List<CourseData>> fecthLista() async {
    courses = await coursesController.list();
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        name: '',
        id: '',
        imageUrl: '',
      ),
      body: Container(
        color: const Color.fromARGB(255, 18, 44, 131),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<CourseData>>(
                    future:
                        fecthLista(), // Llama a la función que obtiene los datos
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Muestra un indicador de carga mientras se obtienen los datos
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // Maneja posibles errores
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Si no hay datos o la lista está vacía
                        return const Center(
                            child: Text("No hay cursos disponibles"));
                      } else {
                        // Cuando los datos están disponibles, construye la lista
                        final courses = snapshot.data!;
                        return ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(course.courseName),
                                subtitle: Text("ID: ${course.courseId}"),
                                trailing: ElevatedButton(
                                  // Cambiar esta palabra por la que se usa en el servidor
                                  onPressed: course.state == "pre_registered"
                                      ? () async {
                                          Navigator.pushNamed(
                                              context, '/matricula',
                                              arguments: course.courseId);
                                        }
                                      : () async {
                                          Navigator.pushNamed(
                                              context, '/matricula',
                                              arguments: course);
                                        }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrangeAccent,
                                  ),
                                  child: const Text("Inscribir"),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
