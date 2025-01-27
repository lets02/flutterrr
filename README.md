# **GERENCIAMENTO DE ESTADO - TEMA 4**

- **Introdução**

    **Objetivo:** Vamos criar um aplicativo de Lista de Tarefas usando Flutter. O foco é o gerenciamento de estado e a persistência de dados, ou seja, como manter as tarefas salvas mesmo após fechar o aplicativo. Utilizaremos `SharedPreferences` para salvar as tarefas e o `setState` para gerenciar as mudanças no estado do aplicativo.

---

- **Passo 1**

    **Criação do Projeto:** Abra o terminal e siga os passos abaixo para criar o projeto To-Do List:

    - **Criar um projeto Flutter:**  
      No terminal, crie o projeto com o comando:
        
        ```bash
        flutter create todo_list_app
        ```
        
      Em seguida, entre no diretório do projeto:
        
        ```bash
        cd todo_list_app
        code .
        ```

    - **Adicionar a biblioteca `shared_preferences`:**  
      Abra o arquivo `pubspec.yaml` e adicione a dependência:
        
        ```yaml
        dependencies:
          flutter:
            sdk: flutter
          shared_preferences: ^2.0.6
        ```
        
      Instale as dependências:

        ```bash
        flutter pub get
        ```

---

- **Passo 2**

    ### **Implementando o Código**

    Agora vamos trabalhar no arquivo `main.dart`. Adicione o seguinte código para criar o to-do list:

    ```dart
    import 'package:flutter/material.dart';
    import 'package:shared_preferences/shared_preferences.dart'; // Importação da biblioteca para persistência de dados

    void main() {
      runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Lista de Tarefas',
          theme: ThemeData(primarySwatch: Colors.blue), // Tema do aplicativo
          home: TaskListScreen(), // Tela inicial do aplicativo
        );
      }
    }

    class TaskListScreen extends StatefulWidget {
      @override
      _TaskListScreenState createState() => _TaskListScreenState();
    }

    class _TaskListScreenState extends State<TaskListScreen> {
      List<String> tasks = []; // Lista de tarefas que será gerenciada
      final TextEditingController _controller = TextEditingController(); // Controlador do campo de texto

      @override
      void initState() {
        super.initState();
        loadTasks(); // Carregar as tarefas salvas ao iniciar o app
      }

      Future<void> loadTasks() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          tasks = prefs.getStringList('tasks') ?? []; // Carrega a lista salva ou inicia uma nova lista
        });
      }

      Future<void> saveTasks() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('tasks', tasks); // Salva a lista atualizada de tarefas
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Lista de Tarefas'), // Título da barra de aplicativos
          ),
          body: ListView.builder(
            itemCount: tasks.length, // Número de tarefas
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index]), // Exibe a tarefa
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red), // Botão para excluir a tarefa
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index); // Remove a tarefa
                      saveTasks(); // Atualiza a lista salva
                    });
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Nova Tarefa'), // Título do diálogo
                    content: TextField(
                      controller: _controller, // Campo de entrada de nova tarefa
                      decoration: InputDecoration(hintText: 'Digite a tarefa'), // Placeholder no campo de texto
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            tasks.add(_controller.text); // Adiciona a tarefa à lista
                            saveTasks(); // Salva a lista atualizada
                            _controller.clear(); // Limpa o campo de entrada
                            Navigator.of(context).pop(); // Fecha o diálogo
                          });
                        },
                        child: Text('Adicionar'), // Botão para adicionar a tarefa
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add), // Ícone do botão flutuante
          ),
        );
      }
    }
    ```

---

- **Passo 3**

    ### **Explicação do Código**

    1. **Função `main()`**:
        - Esta função inicializa o aplicativo. O widget `MyApp` é o ponto de entrada e define o título e o tema.
    
    2. **Classe `MyApp`**:
        - A classe `MyApp` é um `StatelessWidget` que define a estrutura do aplicativo. Ele define que a tela inicial será a classe `TaskListScreen`.
    
    3. **Classe `TaskListScreen`**:
        - Aqui, utilizamos `StatefulWidget` para gerenciar o estado da lista de tarefas.
        - No método `initState()`, usamos `loadTasks()` para carregar as tarefas salvas usando `SharedPreferences`.
    
    4. **Gerenciamento de Estado**:
        - A função `setState()` é usada para notificar o Flutter de que o estado mudou, forçando a reconstrução da interface para refletir as mudanças.
    
    5. **Persistência de Dados com `SharedPreferences`**:
        - `SharedPreferences` permite salvar os dados localmente no dispositivo. No código, usamos `getStringList()` para carregar as tarefas salvas e `setStringList()` para salvá-las.
    
    6. **Adicionar e Excluir Tarefas**:
        - As tarefas são adicionadas através de um `AlertDialog`, que contém um `TextField` para inserir a nova tarefa. Quando o botão "Adicionar" é pressionado, a tarefa é adicionada à lista e salva.
        - As tarefas podem ser removidas clicando no ícone de lixeira ao lado da tarefa, e a lista atualizada é salva automaticamente.

---

- **Passo 4**

    ### **Rodando o Projeto**

    No terminal, execute o aplicativo com o comando:

    ```bash
    flutter run
    ```

---

- **Passo 5**

    ### **Testando o Aplicativo**

    1. **Adicionar uma tarefa**:
        - Clique no botão flutuante de "+" e digite uma tarefa. Veja que a nova tarefa é adicionada à lista.
    
    2. **Excluir uma tarefa**:
        - Pressione o ícone de lixeira para excluir uma tarefa da lista.
    
    3. **Verificar persistência de dados**:
        - Feche o aplicativo e abra novamente. As tarefas ainda estarão lá, graças à persistência com `SharedPreferences`.

---

- **Passo 6**

    ### **Conclusão**

    - **O que aprendemos:**
        - Criamos uma lista de tarefas com Flutter, gerenciamos o estado das tarefas com `setState` e salvamos os dados localmente com `SharedPreferences`.

    Esse é o fim do nosso tutorial. Não se esqueça de experimentar mais funcionalidades e personalizações no seu aplicativo de To-Do List!
#   f l u t t e r r r  
 