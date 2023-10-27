import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apizz',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const InicioScreen(),
      routes: {
        '/prediccion_genero': (context) => const PrediccionGeneroScreen(),
        '/determinacion_edad': (context) => const DeterminacionEdadScreen(),
        '/universidades_pais': (context) => const UniversidadesPorPaisScreen(),
        '/clima_rd': (context) => const ClimaEnRDScreen(),
        '/blog_mozilla': (context) => const BlogMozillaScreen(),
        '/acerca_de': (context) => const AcercaDeScreen(),
      },
    );
  }
}

class InicioScreen extends StatelessWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Image.asset('assets/caja_herramientas.png'),
      ),
      drawer: const NavigationMenu(),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Predicción de Género'),
            onTap: () {
              Navigator.of(context).pushNamed('/prediccion_genero');
            },
          ),
          ListTile(
            title: const Text('Determinación de Edad'),
            onTap: () {
              Navigator.of(context).pushNamed('/determinacion_edad');
            },
          ),
          ListTile(
            title: const Text('Universidades por País'),
            onTap: () {
              Navigator.of(context).pushNamed('/universidades_pais');
            },
          ),
          ListTile(
            title: const Text('Clima en RD'),
            onTap: () {
              Navigator.of(context).pushNamed('/clima_rd');
            },
          ),
          ListTile(
            title: const Text('Blog Mozilla'),
            onTap: () {
              Navigator.of(context).pushNamed('/blog_mozilla');
            },
          ),
          ListTile(
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.of(context).pushNamed('/acerca_de');
            },
          ),
        ],
      ),
    );
  }
}

ElevatedButton buildElevatedButton(String text, void Function()? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
  );
}

class PrediccionGeneroScreen extends StatefulWidget {
  const PrediccionGeneroScreen({Key? key}) : super(key: key);

  @override
  _PrediccionGeneroScreenState createState() => _PrediccionGeneroScreenState();
}

class _PrediccionGeneroScreenState extends State<PrediccionGeneroScreen> {
  String name = "";
  String gender = "";
  bool isLoading = false;

  void _getGender() async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
    final data = json.decode(response.body);

    setState(() {
      isLoading = false;
      gender = data['gender'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción de Género'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildElevatedButton('Predecir Género', () {
              _getGender();
            }),
            if (isLoading)
              const CircularProgressIndicator()
            else if (gender.isNotEmpty)
              Text('Género: $gender', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class DeterminacionEdadScreen extends StatefulWidget {
  const DeterminacionEdadScreen({Key? key}) : super(key: key);

  @override
  _DeterminacionEdadScreenState createState() =>
      _DeterminacionEdadScreenState();
}

class _DeterminacionEdadScreenState extends State<DeterminacionEdadScreen> {
  String name = "";
  int age = 0;
  String ageGroup = "";
  bool isLoading = false;

  void _getAge() async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.get(Uri.parse('https://api.agify.io/?name=$name'));
    final data = json.decode(response.body);

    setState(() {
      isLoading = false;
      age = data['age'];
      ageGroup = _getAgeGroup(age);
    });
  }

  String _getAgeGroup(int age) {
    if (age < 18) {
      return 'joven';
    } else if (age < 60) {
      return 'adulto';
    } else {
      return 'anciano';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Determinación de Edad'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildElevatedButton('Determinar Edad', () {
              _getAge();
            }),
            if (isLoading)
              const CircularProgressIndicator()
            else if (age > 0)
              Column(
                children: [
                  Text('Edad: $age', style: const TextStyle(fontSize: 20)),
                  Text('Grupo de Edad: $ageGroup',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class UniversidadesPorPaisScreen extends StatefulWidget {
  const UniversidadesPorPaisScreen({Key? key}) : super(key: key);

  @override
  _UniversidadesPorPaisScreenState createState() => _UniversidadesPorPaisScreenState();
}

class _UniversidadesPorPaisScreenState extends State<UniversidadesPorPaisScreen> {
  String countryName = "";
  List<University> universities = [];
  bool isLoading = false;

  void _getUniversities() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$countryName'));
    final data = json.decode(response.body) as List;

    List<University> tempUniversities = data.map((item) {
      return University(
        name: item['name'],
        domains: List<String>.from(item['domains']),
        webPages: List<String>.from(item['web_pages']),
      );
    }).toList();

    setState(() {
      isLoading = false;
      universities = tempUniversities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades por País'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            width: 215,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  countryName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nombre del País en Inglés',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(height: 20),
          buildElevatedButton('Obtener Universidades', () {
            _getUniversities();
          }),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (universities.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Nombre: ${universities[index].name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dominio: ${universities[index].domains.join(", ")}'),
                        Text('Sitio Web: ${universities[index].webPages.join(", ")}'),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  ElevatedButton buildElevatedButton(String label, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class University {
  final String name;
  final List<String> domains;
  final List<String> webPages;

  University({
    required this.name,
    required this.domains,
    required this.webPages,
  });
}
class ClimaEnRDScreen extends StatefulWidget {
  const ClimaEnRDScreen({Key? key}) : super(key: key);

  @override
  _ClimaEnRDScreenState createState() => _ClimaEnRDScreenState();
}

class _ClimaEnRDScreenState extends State<ClimaEnRDScreen> {
  String temperature = "";
  String condition = "";
  bool isLoading = false;

  void _getWeather() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=6451c49cf92d47bca4824033232510&q=SANTO-DOMINGO'));
    final data = json.decode(response.body);

    setState(() {
      isLoading = false;
      temperature = data['current']['temp_c'].toString();
      condition = data['current']['condition']['text'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en RD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildElevatedButton('Obtener Clima en RD', () {
              _getWeather();
            }),
            if (isLoading)
              const CircularProgressIndicator()
            else if (temperature.isNotEmpty)
              Column(
                children: [
                  Text('Temperatura: $temperature°C',
                      style: const TextStyle(fontSize: 20)),
                  Text('Condición: $condition',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class News {
  final String title;
  final String summary;
  final String imageUrl;
  final String link;

  News({required this.title, required this.summary, required this.imageUrl, required this.link});
}

class BlogMozillaScreen extends StatefulWidget {
  const BlogMozillaScreen({Key? key}) : super(key: key);

  @override
  _BlogMozillaScreenState createState() => _BlogMozillaScreenState();
}

class _BlogMozillaScreenState extends State<BlogMozillaScreen> {
  List<News> newsList = [];
  bool isLoading = false;

  void _getNews() async {
    setState(() {
      isLoading = true;
    });

    final response = await http
        .get(Uri.parse('https://blog.mozilla.org/wp-json/wp/v2/posts?_embed'));
    final data = json.decode(response.body);

    List<News> tempNewsList = [];
    for (var item in data) {
      News news = News(
        title: item['title']['rendered'],
        summary: item['excerpt']['rendered'],
        imageUrl: item['_embedded']['wp:featuredmedia'][0]['source_url'],
        link: item['link'],
      );
      tempNewsList.add(news);
      if (tempNewsList.length >= 3) {
        break;
      }
    }

    setState(() {
      isLoading = false;
      newsList = tempNewsList;
    });
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo abrir el enlace $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Mozilla'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildElevatedButton('Obtener Noticias de Mozilla', () {
              _getNews();
            }),
            if (isLoading)
              const CircularProgressIndicator()
            else if (newsList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.network(
                          newsList[index].imageUrl,
                          height: 100,
                        ),
                        ListTile(
                          title: Text(newsList[index].title),
                          subtitle: Text(newsList[index].summary),
                          onTap: () {
                            _launchURL(newsList[index].link);
                          },
                        ),
                        const Divider(height: 3.0, color: Colors.red,),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/foto_perfil.jpg'),
              ),
              SizedBox(height: 16),
              Text(
                'Franklin J. Valdez',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Desarrollador de software',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Habilidades:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'C#, Java, CSS, HTML, Git, JavaScript, MySQL, Flutter',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Experiencia:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Estudio en el Instituto Tecnológico de Las Américas (ITLA) '
                    'y he trabajado en varios proyectos personales relacionados '
                    'con desarrollo de software. Aunque no tengo experiencia '
                    'como programador profesional, he adquirido habilidades '
                    'valiosas durante mis estudios y proyectos personales.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Contacto:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Email: franklinjoel1809@gmail.com',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                'Teléfono: +1 829-580-4557',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
