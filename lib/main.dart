import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

//part 'main.g.dart';

@riverpod
final testProvider = StateProvider<String>((ref) => 'Test');
final testProvider2 = StateProvider<List<String>>((ref) => List.filled(12, 'Test_2'),);
final testProvider3 = StateProvider<int>((ref) => 12);

//String helloWorld(HelloWorldRef ref) {
//  return 'Hello world';
//}
                           

// Процедура асинхронной рвботы методом async - await
Future<void> do_Asinc(BuildContext context, List sp2) async
{

String messageF = await sFile(sp2); // вызов процедуры ваводв списка в файл
_popupDialog(context);              // вызов процедуры вывода сообщения
}


// Процедура вывода списка в файл
Future<String> sFile(List sp2) 
async
{
String text = "Список  \n";
File file0 = File("test.txt");
await file0.writeAsString(text); //создание файла
for (int i = 0; i < sp2.length; i++)
{
   text=sp2[i]+"\n";   
   await file0.writeAsString(text,mode : FileMode.append); // Добавление в файл одной записи
}
return Future.delayed(Duration(seconds: 3), ()=> "Запись завершена"); // пауза 3 секунды
}

// Процедура вывода сообщения об окончании
void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Подтверждение записи'),
            content: Text('Запись завершена'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),
            ],
          );
        });
}





void main() {

runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
return MaterialApp(
    routes: {
      '/': (context) => MainScreen(),
    },
  );
}
}


class MainScreen extends ConsumerWidget {

  const MainScreen({super.key});

  @override

  Widget build(BuildContext context, WidgetRef ref) {

 final test = ref.watch(testProvider);

    return Scaffold(

      appBar: AppBar(title: Text('Главное окно')),

      body: new Column( children: [ 
        Container ( color: Colors.white,   height:30,
          child: 
        new Text( ' Дополнительное задание ', style: TextStyle(fontSize: 25, color: Colors.indigo) )),

        Container ( color: Colors.cyan,   height:400,

	child: Center(child: Column(children: [

        new Text('  '),
	CachedNetworkImage(
        	imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFvYnevTpW6ZalCiz1grTyy2HmoU7kjeFcg&s",
	        placeholder: (context, url) => CircularProgressIndicator(),
	        errorWidget: (context, url, error) => Icon(Icons.error),
	     ),
        new Text('  '),
        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen_4()));}, child: Text('Riverpod, внутреннее хранилище и асинхронная работа',style: TextStyle(fontSize: 20, color: Colors.indigo[700]) )),
        new Text('  '),
        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen_5()));}, child: Text('Проверка передачи через внутреннее хранилище',style: TextStyle(fontSize: 20, color: Colors.indigo[700]) )),
        new Text('  '),
        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen_7()));}, child: Text('Кэширование изображений из сети',style: TextStyle(fontSize: 22, color: Colors.indigo[700]) )),
        new Text('  '),
        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen_8()));}, child: Text('Загрузка данных из сети (Get запрос)',style: TextStyle(fontSize: 22, color: Colors.indigo[700]) ))

      ],)),)]

    )
    );

  }

}






class Screen_4 extends ConsumerWidget {

  const Screen_4({super.key});

  @override

  Widget build(BuildContext context, WidgetRef ref) {

  final test = ref.watch(testProvider);
  final test2 = ref.watch(testProvider2);
//  final t2 = test2;
  List<String> t2 = [...test2];


  TextEditingController _nameController = TextEditingController();


    return Scaffold(

      appBar: AppBar(title: Text('Riverpod, внутреннее хранилище и асинхронная работа.',style: TextStyle(fontSize: 18, color: Colors.indigo))),

      body: new Column (  
	children: [
        Container ( color: Colors.cyan,   height:130,
        child: Center(child:  Column(
        children: [
          new Text('Реализация работы со списками и внутренним хранилищем с помощью Riverpod.', style: TextStyle(fontSize: 18, color: Colors.indigo)),
          new Text('А так же реализация асинхронной работы методом async-await', style: TextStyle(fontSize: 18, color: Colors.indigo)),
          new TextField(  controller: _nameController,  decoration: InputDecoration(    hintText: 'Новый эллемент списка или номер удаляемого',  ),),
          ElevatedButton(onPressed: (){ t2.add(_nameController.text); ref.watch(testProvider2.notifier).state = [...t2]; ref.read(testProvider3.state).state = t2.length;}, child: Text('Добавить в список',style: TextStyle(fontSize: 20, color: Colors.indigo))),
          ]))),

	Expanded(
        child: Container ( color: Colors.grey[800],   height:380, 
	child: ListView.builder(
            itemCount: ref.watch(testProvider3.state).state,
            itemBuilder: (BuildContext context, int index) {
              return Text(index.toString()+'  '+ref.read(testProvider2)[index], style: TextStyle(fontSize: 16, color: Colors.white));
            }),
       ),),

        Container ( color: Colors.lime,   height:120, 
       child: Center(child:  Column(
        children: [
          ElevatedButton(onPressed: (){ do_Asinc(context,ref.read(testProvider2)); }, child: Text('Записать в файл (асинхронноая работа)',style: TextStyle(fontSize: 28, color: Colors.red))),
          ElevatedButton(onPressed: (){ t2.removeAt(int.parse( _nameController.text)); ref.watch(testProvider2.notifier).state = [...t2]; ref.read(testProvider3.state).state = t2.length; }, child: Text('Удалить из списка по номеру',style: TextStyle(fontSize: 20, color: Colors.green))),
          ElevatedButton(onPressed: (){ Navigator.pop(context);}, child: Text('Назад',style: TextStyle(fontSize: 24, color: Colors.blue)))
   ])), 

       ),
    ]
    ),
    );

  }

}


class Screen_5 extends ConsumerWidget {

  const Screen_5({super.key});

  @override

  Widget build(BuildContext context, WidgetRef ref) {

  final test = ref.watch(testProvider);
  final test2 = ref.watch(testProvider2);
//  final t2 = test2;
  List<String> t2 = [...test2];


  TextEditingController _nameController = TextEditingController();


    return Scaffold(

      appBar: AppBar(title: Text('Проверка передачи через внутреннее хранилище.',style: TextStyle(fontSize: 18, color: Colors.indigo))),

      body: new Column (  
	children: [
        Container ( color: Colors.indigo,   height:130,
        child: Center(child:  Column(
        children: [
          new Text('Реализация работы со списками и внутренним хранилищем с помощью Riverpod.', style: TextStyle(fontSize: 18, color: Colors.white)),
          new Text('А так же реализация асинхронной работы методом async-await', style: TextStyle(fontSize: 18, color: Colors.white)),
          new TextField(style: TextStyle(fontSize: 18, color: Colors.yellow), controller: _nameController,  decoration: InputDecoration(    hintText: 'Новый эллемент списка или номер удаляемого', hintStyle: TextStyle(fontSize: 18, color: Colors.yellow),  ),),
          ElevatedButton(onPressed: (){ t2.add(_nameController.text); ref.watch(testProvider2.notifier).state = [...t2]; ref.read(testProvider3.state).state = t2.length;}, child: Text('Добавить в список',style: TextStyle(fontSize: 20, color: Colors.indigo))),
          ]))),

	Expanded(
        child: Container ( color: Colors.grey[800],   height:380, 
	child: ListView.builder(
            itemCount: ref.watch(testProvider3.state).state,
            itemBuilder: (BuildContext context, int index) {
              return Text(index.toString()+'  '+ref.read(testProvider2)[index], style: TextStyle(fontSize: 16, color: Colors.white));
            }),
       ),),

        Container ( color: Colors.teal,   height:120, 
       child: Center(child:  Column(
        children: [
          ElevatedButton(onPressed: (){ do_Asinc(context,ref.read(testProvider2)); }, child: Text('Записать в файл (асинхронноая работа)',style: TextStyle(fontSize: 28, color: Colors.red))),
          ElevatedButton(onPressed: (){ t2.removeAt(int.parse( _nameController.text)); ref.watch(testProvider2.notifier).state = [...t2]; ref.read(testProvider3.state).state = t2.length; }, child: Text('Удалить из списка по номеру',style: TextStyle(fontSize: 20, color: Colors.green))),
          ElevatedButton(onPressed: (){ Navigator.pop(context);}, child: Text('Назад',style: TextStyle(fontSize: 24, color: Colors.blue)))
   ])), 

       ),
    ]
    ),
    );

  }

}



class Screen_6 extends ConsumerWidget {

  const Screen_6({super.key});

  @override

  Widget build(BuildContext context, WidgetRef ref) {

  final test = ref.watch(testProvider);
  TextEditingController _nameController = TextEditingController();

    return Scaffold(

      appBar: AppBar(title: Text('Работа с Riverpod',style: TextStyle(fontSize: 20, color: Colors.red))),

      body: Center(  
               child:
        Container ( color: Colors.cyan[700],  
        child:  new Column(
        children: [
          new Text('  '),
          new Text(test, style: TextStyle(fontSize: 28, color: Colors.white)),
          new Text('  '),
	  ElevatedButton(onPressed: (){ ref.read(testProvider.notifier).state=ref.read(testProvider.notifier).state.toUpperCase();}, child: Text('Изменить на заглавные  ',style: TextStyle(fontSize: 24, color: Colors.indigo))),
          new Text('  '),
	  ElevatedButton(onPressed: (){ ref.read(testProvider.notifier).state=ref.read(testProvider.notifier).state.toLowerCase();}, child: Text('Изменить на строчные ',style: TextStyle(fontSize: 24, color: Colors.indigo))),
          new Text('  '),
          new TextFormField(initialValue: test,  controller: _nameController,style: TextStyle(fontSize: 24, color: Colors.white), decoration: InputDecoration(hintText: 'Введите текст',),),
          Text(' ', style: TextStyle(fontSize: 22, color: Colors.green)),
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen_5()));}, child: Text('Переход на второе окно (работа со списком)',style: TextStyle(fontSize: 24, color: Colors.indigo[700]) )),
          new Text('  '),
	  ElevatedButton(onPressed: (){ Navigator.pop(context);}, child: Text('Назад',style: TextStyle(fontSize: 32, color: Colors.cyan[700])))
   ]))),
    
    );

  }

}


class Screen_7 extends StatelessWidget {

  const Screen_7({super.key});

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text('Второе окно',style: TextStyle(fontSize: 20, color: Colors.blue))),

      body: Center(child:  new Column(

        children: [
          new Text('Второе окно ', style: TextStyle(fontSize: 20, color: Colors.blue)),
          new Text('  ', style: TextStyle(fontSize: 20)),
	CachedNetworkImage(
        	imageUrl: "https://flutter.su/data/f8f8cabc67a5a9642134a5fdb3a55a45.png?w=200",
	        placeholder: (context, url) => CircularProgressIndicator(),
	        errorWidget: (context, url, error) => Icon(Icons.error),
	     ),
          new Text('  ', style: TextStyle(fontSize: 20)),
	CachedNetworkImage(
        	imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJynNHLq6BI5vyh7ep0LtgqZ2oZqjpq9ktgQ&s",
	        placeholder: (context, url) => CircularProgressIndicator(),
	        errorWidget: (context, url, error) => Icon(Icons.error),
	     ),
          new Text('  ', style: TextStyle(fontSize: 20)),
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Screen_6()));}, child: Text('Открыть дополнительное окно',style: TextStyle(fontSize: 20, color: Colors.indigo[700]) )),
          new Text('  ', style: TextStyle(fontSize: 20)),
	  ElevatedButton(onPressed: (){ Navigator.pop(context);}, child: Text('Назад',style: TextStyle(fontSize: 32, color: Colors.blue)))
   ])),
    
    );

  }

}



class Screen_8 extends StatefulWidget {

  const Screen_8({super.key});
 
  @override
  _Screen_8s createState() => _Screen_8s();
}


class _Screen_8s extends State<Screen_8>{

 var jsonUsers;

getUsers() async {

final response = await http.get(Uri.parse(
    'https://randomuser.me/api/?results=20'));
setState(() {
  var jsonBody = json.decode(response.body);
  jsonUsers = jsonBody['results'];
});
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON запрос  https://randomuser.me/api/?results=20 '),
        actions: [
          ElevatedButton(
            onPressed: getUsers,
            child: const Text('Загрузить список из 20 пользователей'),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(jsonUsers[index]['name']['first']+' '+jsonUsers[index]['name']['last'] +' Email: '+jsonUsers[index]['email']),
            ),
          );
        },
        itemCount: jsonUsers == null ? 0 : jsonUsers.length,
      ),
    );
  }
}













