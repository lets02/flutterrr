import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // Biblioteca para salvar dados localmente no dispositivo

// Função principal que inicializa o aplicativo
void main() {
  runApp(MyApp()); // Executa o widget principal do aplicativo
}

// Widget principal do app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retorna o MaterialApp que define a estrutura geral do app
    return MaterialApp(
      title: 'Lista de Tarefas', // Título do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor primária do tema do app
      ),
      home: TaskListScreen(), // Define a tela inicial do app como TaskListScreen
    );
  }
}

// Tela principal que exibe a lista de tarefas
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState(); // Cria o estado do widget Stateful
}

// Estado da tela principal
class _TaskListScreenState extends State<TaskListScreen> {
  List<String> tasks = []; // Lista de tarefas que será exibida
  final TextEditingController _controller = TextEditingController(); // Controlador de texto para o campo de nova tarefa

  @override
  void initState() {
    super.initState();
    loadTasks(); // Carrega as tarefas salvas ao iniciar o app
  }

  // Função assíncrona para carregar as tarefas salvas do armazenamento local
  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Obtém a instância de SharedPreferences
    setState(() {
      tasks = prefs.getStringList('tasks') ?? []; // Carrega a lista de tarefas ou inicializa uma lista vazia
    });
  }

  // Função assíncrona para salvar as tarefas localmente
  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Obtém a instância de SharedPreferences
    await prefs.setStringList('tasks', tasks); // Salva a lista de tarefas atualizada no armazenamento local
  }

  @override
  Widget build(BuildContext context) {
    // Estrutura da tela principal
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'), // Título exibido na barra superior
      ),
      body: ListView.builder(
        itemCount: tasks.length, // Define o número de itens na lista (quantidade de tarefas)
        itemBuilder: (context, index) {
          // Cada item da lista é representado por um ListTile
          return ListTile(
            title: Text(tasks[index]), // Exibe o texto da tarefa
            trailing: IconButton( // Botão para excluir a tarefa
              icon: Icon(Icons.delete, color: Colors.red), // Ícone de lixeira, com cor vermelha
              onPressed: () {
                setState(() {
                  tasks.removeAt(index); // Remove a tarefa na posição 'index'
                  saveTasks(); // Salva a lista de tarefas atualizada
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quando o botão de adicionar é pressionado, abre um diálogo para inserir nova tarefa
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Nova Tarefa'), // Título do diálogo
                content: TextField(
                  controller: _controller, // Campo de texto para entrada da nova tarefa
                  decoration: InputDecoration(hintText: 'Digite a tarefa'), // Texto de dica no campo de entrada
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tasks.add(_controller.text); // Adiciona o texto digitado à lista de tarefas
                        saveTasks(); // Salva a lista de tarefas atualizada
                        _controller.clear(); // Limpa o campo de entrada após adicionar a tarefa
                        Navigator.of(context).pop(); // Fecha o diálogo após adicionar
                      });
                    },
                    child: Text('Adicionar'), // Botão para confirmar a adição da nova tarefa
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add), // Ícone de "+" no botão flutuante para adicionar nova tarefa
      ),
    );
  }
}
