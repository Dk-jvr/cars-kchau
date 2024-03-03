import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:image_picker/image_picker.dart';


void main(){
  //YandexMap();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeerCar',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurpleAccent[200],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _surnameController = TextEditingController();
    final TextEditingController _patronymicController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(Icons.person_add, size: 100.0, color: Colors.white70),
                const SizedBox(height: 40.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: 'Фамилия',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _patronymicController,
                  decoration: const InputDecoration(
                    labelText: 'Отчество',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Номер телефона',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Повторите пароль',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  child: const Text('Зарегистрироваться'),
                  onPressed: () {
                    if (_passwordController.text == _confirmPasswordController.text) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage(
                          selectedIndex: 0,
                          profilePage: ProfilePage(
                            name: _nameController.text,
                            surname: _surnameController.text,
                            patronymic: _patronymicController.text,
                            phone: _phoneController.text,
                          ),
                        )),
                            (Route<dynamic> route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final int selectedIndex;
  final Widget profilePage;

  const MainPage({this.selectedIndex = 1, this.profilePage = const ProfilePage(), Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentTabIndex = 0;

  List<Widget> widgetOptions = <Widget>[
    ProfilePage(),
    HomePage(),
    ChatPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    widgetOptions[0] = widget.profilePage;
    currentTabIndex = widget.selectedIndex;
  }

  void onItemTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('PeerCar'),
        actions: <Widget>[],
      ),
      body: Center(
        child: widgetOptions.elementAt(currentTabIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чат',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        currentIndex: currentTabIndex,
        onTap: onItemTapped,
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _chatData = [
    {'name': 'Пользователь 1', 'message': 'Привет! Как дела?', 'avatar': Icons.account_circle, 'messages': <String>[]},
    {'name': 'Пользователь 2', 'message': 'Все отлично, спасибо!', 'avatar': Icons.account_circle, 'messages': <String>[]},
    {'name': 'Пользователь 3', 'message': 'Что нового?', 'avatar': Icons.account_circle, 'messages': <String>[]},
    {'name': 'Пользователь 4', 'message': 'Да вот, изучаю Flutter. А у тебя?', 'avatar': Icons.account_circle, 'messages': <String>[]},
    {'name': 'Пользователь 5', 'message': 'Тоже учу Flutter, очень интересно!', 'avatar': Icons.account_circle, 'messages': <String>[]}
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Поиск...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: ListView.builder(
          itemCount: _chatData.where((user) => user['name'].toLowerCase().contains(_searchText.toLowerCase())).toList().length,
          itemBuilder: (context, index) {
            final user = _chatData.where((user) => user['name'].toLowerCase().contains(_searchText.toLowerCase())).toList()[index];
            return ListTile(
              leading: CircleAvatar(
                child: Icon(user['avatar']),
              ),
              title: Text(user['name']),
              subtitle: Text(user['messages'].isNotEmpty ? user['messages'].last : ''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IndividualChatPage(chatUser: user, onNewMessage: (newMessage) {
                    setState(() {
                      user['messages'].add(newMessage);
                    });
                  })),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Удалить чат'),
                      content: Text('Вы уверены, что хотите удалить этот чат?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Отмена'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Удалить'),
                          onPressed: () {
                            setState(() {
                              _chatData.remove(user);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class IndividualChatPage extends StatefulWidget {
  final Map<String, dynamic>? chatUser;
  final Function(String)? onNewMessage;

  const IndividualChatPage({Key? key, this.chatUser, this.onNewMessage}) : super(key: key);

  @override
  _IndividualChatPageState createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser?['name'] ?? ''),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.chatUser?['messages'].length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.chatUser?['messages'][index] ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      hintStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.grey[800],
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      widget.onNewMessage?.call(_controller.text);
                      _controller.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Car {
  final String name;
  final String photoUrl;
  final int price;

  Car(this.name, this.photoUrl, this.price);
}

List<Car> myCars = [
  Car('Tesla Model S', 'https://example.com/tesla_model_s.jpg', 75000),
  Car('BMW i8', 'https://example.com/bmw_i8.jpg', 140000),
  Car('Audi R8', 'https://example.com/audi_r8.jpg', 170000),
];

void _showMyCarsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 90% ширины экрана
          height: MediaQuery.of(context).size.height * 0.8, // 80% высоты экрана
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // два элемента по оси X
            ),
            itemCount: myCars.length, // количество машин
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Image.network(
                        myCars[index].photoUrl, // фотография машины
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(myCars[index].name), // название машины
                    Text('${myCars[index].price}'), // цена машины
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // логика удаления машины
                            },
                            child: Text('Удалить'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // логика изменения машины
                            },
                            child: Text('Изменить'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

class ProfilePage extends StatefulWidget {
  final String name;
  final String surname;
  final String patronymic;
  final String phone;

  const ProfilePage({
    super.key,
    this.name = 'Не указано',
    this.surname = 'Не указано',
    this.patronymic = 'Не указано',
    this.phone = 'Не указано',
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String? _currentCity;
  String? _currentPhone;
  String? _vehicle;
  String? _passid;

  String currentBrand = '';
  String currentModel = '';
  int currentPrice = 0;


  void addCar() {
    String name = '$currentBrand $currentModel';
    String photoUrl = 'https://example.com/$name.jpg';

    Car newCar = Car(name, photoUrl, currentPrice); // создаем новую машину

    setState(() {
      myCars.add(newCar); // добавляем новую машину в список
    });
  }

  @override
  void initState() {
    super.initState();
    _currentCity = 'Не указано';
    _currentPhone = widget.phone;
    _vehicle = 'Не указано';
    _passid = 'Не указано';
  }

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showEditPopup(String title, String? currentValue,
      ValueChanged<String> onSubmitted) async {
    TextEditingController _textEditingController = TextEditingController(
        text: currentValue);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Изменить $title на:'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Введите здесь',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Сохранить'),
              onPressed: () {
                onSubmitted(_textEditingController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: getImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _image == null
                                ? NetworkImage(
                                'https://example.com/user_photo.jpg') as ImageProvider<
                                Object>
                                : FileImage(_image!) as ImageProvider<Object>,
                          ),
                        ),
                        SizedBox(width: 10),
                        // Добавляем пространство между аватаром и текстом
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center, // Центрируем текст по оси Y
                            children: <Widget>[
                              Text('Фамилия: ${widget.surname}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Имя: ${widget.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Отчество: ${widget.patronymic}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.account_balance_wallet), // Иконка бумажника
                          onPressed: () {
                            // логика кнопки "Мои доходы"
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Телефон: $_currentPhone', style: TextStyle()),
                          Text('Город: $_currentCity', style: TextStyle()),
                        ],
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Водительское удостоверение: $_passid', style: TextStyle()),
                          Text('Транспортное средство: $_vehicle', style: TextStyle()),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60.0, // Увеличиваем высоту кнопки
                  margin: const EdgeInsets.all(5.0), // Добавляем отступы
                  child: ElevatedButton(
                    onPressed: () => _showMyCarsPopup(context),
                    child: Text('Мои машины'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60.0, // Увеличиваем высоту кнопки
                  margin: const EdgeInsets.all(5.0), // Добавляем отступы,
                ),
                Expanded(
                  child: Container(), // Пустой контейнер
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(child: Text('Подтвердить личность')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15), // Делает кнопку более объемной
                                  ),
                                  onPressed: () async {
                                    var image = await ImagePicker().getImage(source: ImageSource.camera);
                                    // Ваш код для обработки изображения
                                  },
                                  child: Text('Подтвердить паспортные данные'),
                                ),
                                SizedBox(height: 10), // Добавляет отступ в 10 пикселей
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15), // Делает кнопку более объемной
                                  ),
                                  onPressed: () async {
                                    var image = await ImagePicker().getImage(source: ImageSource.camera);
                                    // Ваш код для обработки изображения
                                  },
                                  child: Text('Подтвердить водительское удостоверение'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Подтвердить личность'),
            ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Добавить машину на аренду'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Марка',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Модель',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Год выпуска',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Цена',
                                    ),
                                  ),
                                ),
                                // Добавьте больше полей, если нужно
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              var image = await ImagePicker().getImage(source: ImageSource.camera);
                                              // Ваш код для обработки изображения
                                            },
                                            child: Text(
                                              'Фота',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10), // Добавьте пространство между кнопками
                                        Container(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 15),
                                            ),
                                            onPressed: addCar
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(builder: (context) => VehiclePhoto()),
                                              // );
                                            ,
                                            child: Text(
                                              'Далее',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Добавить машину на аренду'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _showEditPopup('город', _currentCity, (newCity) {
                          setState(() {
                            _currentCity = newCity;
                          });
                        }),
                    child: Text('Изменить город'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _showEditPopup(
                            'номер телефона', _currentPhone, (newPhone) {
                          setState(() {
                            _currentPhone = newPhone;
                          });
                        }),
                    child: Text('Изменить номер телефона'),
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, bool> _filters = {
    'Эконом': true,
    'Комфорт': true,
    'Бизнес': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Поиск...',
            border: InputBorder.none,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (_) {},
            icon: Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              return _filters.keys.map((String key) {
                return PopupMenuItem<String>(
                  value: key,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return CheckboxListTile(
                        title: Text(key),
                        value: _filters[key]!,
                        onChanged: (bool? value) {
                          setState(() {
                            _filters[key] = value!;
                          });
                        },
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 500,
            child: YandexMap(
              onMapCreated: (YandexMapController yandexMapController) {

              },
            ),
          ),
          // GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Image.network(
                        'https://example.com/image.jpg',
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Название элемента ${index + 1}\nЦена: ${index + 1}00 руб.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Забронировать'),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationsEnabled = true;
  bool isDarkModeEnabled = true;
  bool isLocationEnabled = true;
  bool isSoundEnabled = true;
  bool isAutoUpdateEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('Включить уведомления'),
              value: isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Включить темный режим'),
              value: isDarkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Включить геопозицию'),
              value: isLocationEnabled,
              onChanged: (bool value) {
                setState(() {
                  isLocationEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Включить звук'),
              value: isSoundEnabled,
              onChanged: (bool value) {
                setState(() {
                  isSoundEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Автоматическое обновление'),
              value: isAutoUpdateEnabled,
              onChanged: (bool value) {
                setState(() {
                  isAutoUpdateEnabled = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Вызов технической поддержки');
                      },
                      child: Text('Тех. Поддержка'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Вызов экстренной службы');
                      },
                      child: Text('Экстренная Служба'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _loginController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(Icons.lock_outline, size: 100.0, color: Colors.white70),
                const SizedBox(height: 40.0),
                TextFormField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  child: const Text('Войти'),
                  onPressed: () {
                    if (_loginController.text == '123' && _passwordController.text == '123') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MainPage()),
                      );
                    }
                  },
                ),
                TextButton(
                  child: const Text('Нет аккаунта?'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VehiclePhoto extends StatefulWidget {
  const VehiclePhoto({Key? key}) : super(key: key);

  @override
  _VehiclePhotoState createState() => _VehiclePhotoState();
}

class _VehiclePhotoState extends State<VehiclePhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить фотографию машины'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () {
                    // Откройте камеру
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
