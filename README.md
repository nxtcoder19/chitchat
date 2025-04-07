# chitchat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 🌟 What is Flutter?

Flutter is an open-source UI software development toolkit created by Google. It allows developers to build natively compiled applications for:
- Mobile (Android, iOS)
- Web
- Desktop (Windows, macOS, Linux)
- - Flutter is built for 60+ FPS animations — Dart’s memory management keeps apps smooth.

—all from a single codebase using the Dart programming language.

# 🧠 What is Dart?
Dart is a client-optimized programming language developed by Google for building fast apps on any platform (mobile, web, desktop, and server).

- Object-Oriented
- Syntax is familiar (like Java, JavaScript, Kotlin)
- Strongly typed (with null safety)
- Supports async (Future, Stream)
- Compiles to native machine code (mobile) or JavaScript (web)
- Fast Compilation: JIT + AOT
- JIT (Just-in-Time)	During development	Enables Hot Reload ⚡
- AOT (Ahead-of-Time)	Production build	Fast native performance ⚡

# 🧱 Building Blocks of Flutter

- Widget:	UI structure (Stateful and stateless)
- Element:	Instance of a widget 
- RenderObject:	Handles layout & paint
- Material/Cupertino:	Pre-built design components
- State Management:	UI updates based on data
- Dart:	Programming language used with Flutter

# 🚀 Flutter App Workflow: From main.dart to Screen
- Every Flutter app starts from the main() function which is the entry point of the app.
  ```bash
      void main() {
        runApp(MyApp());
      }
  ```
- It calls runApp() and passes a widget (usually your root widget).
- runApp() – Starts the Flutter Engine and attaches the widget tree to the Flutter rendering engine.
- It tells Flutter to inflate (render) the widget you pass into it and creates a root element to starts the build process.
- Root Widget (MyApp): MyApp is usually a StatelessWidget that returns MaterialApp or CupertinoApp in which we can set up Theme, Navigation, Routes and Home Screen
  ```bash
      class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'My App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: HomePage(),
        );
      }
    }
  ```
- home Widget (like HomePage()): This is the actual screen that the user sees where you build your UI tree.
- Flutter walks through this tree and paints it using the rendering engine.

# 🛡️ Null Safety
Flutter uses Dart, which now supports null safety — meaning:

Variables must be non-nullable by default, unless you say otherwise.

  ```bash
    int a;                           // a is initialized with null value.    
    a ??= 10;     
    print(a);                      // It will print 10.  
    print(5 ?? 10);            // It will print 5.   
    print(null ?? 10);       // It will print 10.   
  ```

- ❗ What is the Null Check Operator (!)?
  - The ! operator is called the null assertion operator.
  - “I’m 100% sure this value is not null, so treat it as non-null.”
  - If the value is null, it will crash your app with a runtime error.
  - Use it only when you're absolutely sure that a nullable variable will never be null at that point.
  
  ```bash
    String? name = getUserName();
    print(name!); // Force Dart to treat it as non-null
    
    # Instead prefer
    
    if (value != null)
    value ?? defaultValue
    value?.doSomething()

  ```

# 🔹 Hot Reload, Hot Restart and Full Restart

- ## 🔄 Hot Reload
  - Injects updated Dart code into the running app without restarting the entire app.
  - Preserves App state (e.g., form inputs, counter values) and current screen
  - Best for UI changes (design tweaks, layout updates) and small logic changes
  - Faster than restart
  - EX: You update the color of a button → Hot Reload → the change appears immediately without losing the current state.
- ## 🔄 Hot Restart
  - Restarts the Dart VM and rebuilds the app from the main() function but does not recompile native code.
  - Resets App state, variable, counter, etc
  - Preserves Compilation of native code (still faster than full restart)
  - Best for Major code changes (like state structure or global variables) and After updating initState() or changing        constructors
  - EX: You add a new stateful widget or modify initial state → Hot Restart is needed to reflect the changes.
- ## 🔄 Full Restart
  - Completely rebuilds the app, recompiles native code, and restarts the app as if it was freshly launched.
  - Used when: Native platform code changes (e.g., adding a new plugin) and Android/iOS-specific changes (manifest, permissions, etc.)
  - takes longer time

# 🧭 Axis Overview

- ## 🔹 MainAxisAlignment
  Controls how children are aligned along the main axis (horizontal in Row, vertical in Column).
- ## 🔸 CrossAxisAlignment
  Controls how children are aligned along the main axis (vertical in Row, horizontal in Column).
  
- ## Diagram

  <img width="736" alt="Screenshot 2025-04-06 at 7 59 35 PM" src="https://github.com/user-attachments/assets/2d32f70e-7a70-4562-a08c-039d7c025f90" />


  
# 🧱 BuildContext?
🔹 BuildContext is like a reference to the location of a widget in the widget tree.

It gives widgets access to:
- Their position in the widget tree
- Their parent widgets
- Theme, MediaQuery, InheritedWidgets, etc.
- Use to Access Theme or MediaQuery
- Use to how Snackbar or Dialog
- Use to Navigate between pages
- Use to Read values from Provider or Bloc

# 🧭 Navigation?

Navigation in Flutter is how you Move between screens (routes/pages), Go back to previous screens, Pass data between screens and Manage app history

  ```bash
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage()),
  );
  
  # WIth arguments:
  
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => SecondPage(name: "John")),
  );


  ```
  
# 🔍 Keys
A Key is an identifier that tells Flutter which widget is which when it rebuilds the UI.

When the widget tree rebuilds (due to state change, navigation, etc.), **Flutter uses keys to:
- Match old widgets with new ones
- Preserve widget state and position
- preserve state when widgets move or get reordered
- To avoid unnecessary widget rebuilds
- To differentiate between widgets of the same type


# 🧭 Map?
In Dart, a Map is a collection of key-value pairs.
- Keys are unique
- Values can be any type: JSON APIs, Local storage and Passing data between screens
  ```bash
    Map<String, dynamic> user = {
      'name': 'Flutter Dev',
      'age': 25,
      'isActive': true,
    };
  ```
- 🔸 Map Example:
  ```bash
      Map<String, String> fruits = {
        'a': 'Apple',
        'b': 'Banana',
      };
      print(fruits['a']); // Output: Apple
      fruits['c'] = 'Cherry'; // Add
      fruits['a'] = 'Avocado'; // Update
      fruits.remove('b');
  ```
- 🔸 Loop Through Map
  ```bash
      fruits.forEach((key, value) {
        print('$key: $value');
      });

      OR

      for (var entry in fruits.entries) {
        print('${entry.key}: ${entry.value}');
      }
  ```
- 📤 Convert Object → Map (Manual)
  ```bash
      class User {
        String name;
        int age;

        User({required this.name, required this.age});

        Map<String, dynamic> toMap() {
          return {
            'name': name,
            'age': age,
          };
        }
      }
  ```
- 📥 Convert Map → Object
  ```bash
      factory User.fromMap(Map<String, dynamic> map) {
        return User(
          name: map['name'],
          age: map['age'],
        );
      } 

  ```
- 🔁 Convert Map ↔️ JSON
  ```bash
      import 'dart:convert';

      final userMap = {'name': 'Flutter', 'age': 3};
      final jsonString = jsonEncode(userMap); // → JSON string

      final parsedMap = jsonDecode(jsonString); // → Back to Map
  ```
  
# 🔁 jsonEncode vs jsonDecode

- jsonEncode()	Converts Dart object → JSON string, convert	Map, List, etc. to	JSON String
- jsonDecode()	Converts JSON string → Dart object convert	JSON String to	Map, List, etc.
- Example:
  - 🔹 jsonEncode – Dart ➝ JSON
    ```bash
      import 'dart:convert';

    void main() {
      Map<String, dynamic> user = {
        'name': 'Flutter',
        'age': 3,
        'isActive': true,
      };

      String jsonString = jsonEncode(user);
      print(jsonString); // {"name":"Flutter","age":3,"isActive":true}
    }

    ```
  - 🔹 jsonDecode – JSON ➝ Dart
    ```bash
        import 'dart:convert';

        void main() {
          String jsonString = '{"name":"Flutter","age":3,"isActive":true}';

          Map<String, dynamic> user = jsonDecode(jsonString);
          print(user['name']); // Flutter
          print(user['age']); // 3
        }

    ```


# 📦 Flutter Packages

Packages are pre-built libraries on pub.dev that you can use to:
- Add features (Firebase, HTTP, animations)
- Save development time
- Avoid writing boilerplate

# 🧱 Custom Widgets
Custom widgets help you reuse code, make UI clean, and improve modularity.

  ```bash
    class CustomButton extends StatelessWidget {
      final String label;
      final VoidCallback onTap;

      CustomButton({required this.label, required this.onTap});

      @override
      Widget build(BuildContext context) {
        return ElevatedButton(
          onPressed: onTap,
          child: Text(label),
        );
      }
    }
    
    # Use like:
    CustomButton(
      label: "Click Me",
      onTap: () {
        print("Clicked");
      },
    )


  ```

# 🔍 Http Vs Dio
- ## 🔹 HTTP
  - Official, simple HTTP client for Flutter/Dart
  - Simplicity	✅ Very simple
  - Interceptors	❌ Not built-in
  - Request Cancellation	❌ Not supported
  - Timeout Control	✅ Yes (basic)
  - Retry Policy	❌ Manual
  - Response Data	response.body (String)
  ```bash
      import 'package:http/http.dart' as http;

      final response = await http.get(Uri.parse('https://api.example.com/data'));

      if (response.statusCode == 200) {
        print(response.body);
      }

  ```

- ## 🔹 Dio
  - Powerful, feature-rich 3rd-party HTTP client
  - Simplicity	🔸 Slightly complex
  - Interceptors	✅ Yes (e.g., logging, auth tokens)
  - Request Cancellation	✅ Yes
  - Timeout Control	✅ Yes (detailed)
  - Retry Policy	✅ Plugin support (dio_retry)
  - Response Data	response.data (Typed)

  ```bash
    import 'package:dio/dio.dart';

    final dio = Dio();
    final response = await dio.get('https://api.example.com/data');

    print(response.data);


  ```

# 🔍 What are Interceptors?

Interceptors are like middleware that allow you to intercept, modify, or log requests and responses in your network layer before they’re sent or received.

Useful for:
- Adding auth tokens (e.g. JWT)
- Logging API calls
- Handling errors globally
- Showing loaders/spinners
- Retrying failed requests

  ```bash
      final dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("Request: ${options.uri}");
          options.headers["Authorization"] = "Bearer YOUR_TOKEN";
          return handler.next(options); // continue
        },
        onResponse: (response, handler) {
          print("Response: ${response.statusCode}");
          return handler.next(response); // continue
        },
        onError: (DioError e, handler) {
          print("Error: ${e.message}");
          return handler.next(e); // continue
        },
      ),
    );

  ```


# 🎞️ Flutter Animation

Flutter animations allow you to make your UI more dynamic and interactive — e.g., button press animations, loading spinners, transitions, etc.

- ## ✅ Implicit Animation

  You just change a value — Flutter handles the animation automatically.
  ```bash
      AnimatedContainer(
        duration: Duration(seconds: 1),
        color: isRed ? Colors.red : Colors.blue,
      )
  ```

- ## ✅ Explicit Animation

  You control the animation using controllers, tweens, and listeners.
  ```bash
      AnimationController controller = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
      );
  ```
  
- ## 🔁 Ticker
  A Ticker is like a metronome — it sends a tick (frame callback) on every screen refresh (~60 times/sec).
  - Used under the hood by AnimationController
  - Keeps track of time passed to calculate animation progress
  ```bash
      class MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
      late AnimationController _controller;

      @override
      void initState() {
        super.initState();
        _controller = AnimationController(
          vsync: this, // uses Ticker
          duration: Duration(seconds: 2),
        )..repeat();
      }
    }
  ```

- ## 🎨 CustomPainter
  CustomPainter allows you to draw directly on the canvas, giving you full control over how the UI looks.
  - Drawing charts, graphs
  - Custom shapes, paths
  - Game UI, animations

  ```bash
      class MyPainter extends CustomPainter {
      @override
      void paint(Canvas canvas, Size size) {
        final paint = Paint()
          ..color = Colors.blue
          ..strokeWidth = 4;

        canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
      }

      @override
      bool shouldRepaint(CustomPainter oldDelegate) => true;
    }
    
    To Use it:
    CustomPaint(
      size: Size(200, 200),
      painter: MyPainter(),
    )

  ```

- ## 🔄 Tween
  Tween defines the start and end values for an animation and interpolates between them over time.
  - You can use ColorTween, SizeTween, etc.
  - Combined with AnimationController for custom animations.
  ```bash
      Tween<double>(begin: 0, end: 1).animate(controller);
  ```

- ## 🧱 AnimatedBuilder
  A widget that listens to an animation and rebuilds UI as the animation progresses.
  ```bash
      AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2 * pi,
          child: child,
        );
      },
      child: Icon(Icons.refresh),
    );

  ```

- ## 📦 6. AnimationController
  Controls the animation (start, stop, reverse, repeat).
  - use with Tween for defining values
  - AnimatedBuilder or addListener() for UI updates

  ```bash
    AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

  ```
  
 -  ## 🧠 Summary Table

- Animation	Represents a changing value over time	Moving UI, opacity, transitions
- Ticker	Emits ticks (frames) to sync animation	Base for animations
- Tween	Defines start & end values	Animate between values
- AnimationController	Controls the animation	Start, stop, reverse, repeat
- AnimatedBuilder	Widget that listens to animation	Rebuilds widgets on change
- CustomPainter	Allows drawing directly on the canvas	Custom shapes, charts, games

# 🔍 Flutter Inspector?
The Flutter Inspector is a visual debugging tool available in Android Studio, VS Code, or DevTools (browser). It helps you examine, analyze, and debug your widget tree and UI layout.
  - Open Flutter Inspector(Dart: DevTools).
  - Inspector shows Its position in the widget tree
  - Padding/margin/constraints
  - What it’s parent and children are
  - You adjust your widget tree accordingly.

# State?
State is simply data that can change over time in your app — and when it changes, the UI should update. For EX: Button clicks, User input in a form, API response data and Theme toggle, etc.

- ## 🔄 State Management?
  State management is how you manage and update the state (data) of your app in a structured way so that your UI stays in sync.
  - Ephemeral (local) state	Simple state within a single widget (e.g., TextField, counter)
  - App (shared/global) state	Data shared across many widgets or screens (e.g., user login, cart)

- ## 🚀 BLoC State Management?
  - BLoC helps you separate UI (presentation) from business logic (state changes, events) by using Streams.
  - The UI sends events, the BLoC handles them and emits new states, which the UI listens to and rebuilds.
  - ### BlocConsumer
    - BlocConsumer is a widget that combines both BlocBuilder – rebuilds the UI based on state and BlocListener – listens for side effects (snackbars, navigation, etc.)
    - You use BlocConsumer when you want to both update UI and trigger side effects based on state changes.
    ```bash
        BlocConsumer<BlocType, StateType>(
          listener: (context, state) {
            // Side effects (e.g., show snackbar, navigate, dialog)
          },
          builder: (context, state) {
            // Return UI based on state
            return YourWidget();
          },
        )
    ```
  - ### Blocbuilder
    - Rebuilds the UI whenever the state changes.
    - Should be pure (no side effects like navigation or snackbars).
    ```bash
        BlocBuilder<BlocType, StateType>(
          listener: (context, state) {
            // Side effects (e.g., show snackbar, navigate, dialog)
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return CircularProgressIndicator();
            } else if (state is LoadedState) {
              return Text('Data: ${state.data}');
            } else {
              return Container();
            }
          }

        )
    ```
  - ### Bloclistener
    - It does not build UI.
    - Used for one-time effects like: Showing a Snackbar, Navigating to another screen or Showing a Dialog
    ```bash
        BlocListener<BlocType, StateType>(
          listener: (context, state) {
            if (state is ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }
        )
    ```
    
- ## 🚀 Provider State Management?
  - Provider is a wrapper around InheritedWidget that allows you to Share state/data across your widget tree
  - Listen and rebuild widgets when the state changes
  - ChangeNotifier	A class that holds data and notifies listeners
  - ChangeNotifierProvider	Provides access to the notifier to the widget tree
  - Consumer	Listens to changes and rebuilds when notified
  - context.watch()	Rebuilds widget when value changes
  - context.read()	Reads value without rebuild

# 🔁 Stream?
A Stream is a sequence of asynchronous data events. Think of it as a pipe that sends data over time, and you can listen to it.

- 🔊 Real-World Analogy:
  Like a radio station broadcasting songs — you "listen" to the stream and react whenever a new song (event/data) plays.
- Types of Streams
  - Single-subscription:	Default stream — one listener at a time
  - Broadcast:	Multiple listeners can listen to the stream
- ✅ Common Use Cases
  - Fetching data from an API continuously (e.g., news feed)
  - Listening to sensor data (accelerometer, GPS)
  - Chat messages or notifications
  - UI animations or countdown timers
- 🧱 Stream Workflow
  - yield sends data
  - You can listen to this stream using await for, StreamBuilder, or listen()
  ```bash
    void main() {

      Stream<int> numberStream() async* {
      for (int i = 1; i <= 5; i++) {
        await Future.delayed(Duration(seconds: 1));
        yield i; // Emit value
      }
    }


      final stream = numberStream();

      stream.listen((value) {
        print("New value: $value");
      });
    }
  ```
- ✅ Example 2: StreamBuilder in UI (Flutter Widget)

  ```bash
      class CounterStreamWidget extends StatelessWidget {
        Stream<int> countStream() async* {
          for (int i = 1; i <= 5; i++) {
            await Future.delayed(Duration(seconds: 1));
            yield i;
          }
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: Text("Stream Example")),
            body: Center(
              child: StreamBuilder<int>(
                stream: countStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return Text("Value: ${snapshot.data}", style: TextStyle(fontSize: 24));
                  } else {
                    return Text("Stream ended");
                  }
                },
              ),
            ),
          );
        }
      }

  ```
  
- 🔧 Example 3: StreamController (Manual Stream Control)
  - .sink.add() – to send data
  - .stream.listen() – to listen for data
  - Don't forget to close it: controller.close();

  ```bash
      final controller = StreamController<int>();

      // Add data manually
      controller.sink.add(1);
      controller.sink.add(2);

      // Listen
      controller.stream.listen((val) {
        print("Received: $val");
      });

  ```
  
# ⏳ Future?
A Future in Dart represents a value that will be available later, after a delay or asynchronous operation.

Think of it like "a promise to deliver a value later" 📦⏰
- ## ✅ Common Use Cases
  - Fetching data from the internet (APIs)
  - Reading files
  - Delaying an action (Future.delayed)
  - Database operations
  - Anything that takes time

# 🔁 async* vs async

- async
Used when Used when a function returns Future<> a single value that will be available in the future.
   ```bash
       Future<String> getName() async {
      await Future.delayed(Duration(seconds: 1));
      return "Flutter";
    }
   ```
  
- async*
Used when a function returns a Stream<> — a sequence of values over time.
  
You also need to use the keyword yield to emit each value individually.
  
  ```bash
    Stream<int> numberStream() async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }
  ```
- Yield
  - yield is used inside async* to emit values one-by-one
  - Each time the stream is listened to, it waits, executes, and yields next item

# 🔹 FutureBuilder vs StreamBuilder
Both widgets let you build UI based on asynchronous data, but there's a key difference:
- ## FutureBuilder
  - Used for	One-time async call (like API)
  - Emits	Single value
  - Rebuilds UI	Once (when future completes)
  - Common with	APIs, file loading
- ## StreamBuilder
  - Used for Continuous data (like sockets, chat)
  - Emits Multiple values over time
  - Rebuilds UI Every time stream emits a value
  - Common with Chat apps, sensors, timer, sockets

# 🧬 Mixin?
A mixin is a way to reuse code across multiple classes without using inheritance.

It allows you to “mix in” methods and properties from one class into another class.

- ## Key Points
  - A mixin is a class-like structure, but it cannot be instantiated.
  - Used with the with keyword.
  - You can mix in multiple mixins into a class.
  - Common in Flutter for things like TickerProviderStateMixin, etc.
  - Use TickerProviderStateMixin for animation

  ```bash
      # Define mixin
      mixin Logger {
        void log(String message) {
          print("[LOG]: $message");
        }
      }
      
      Use Mixin:
      class MyService with Logger {
        void fetchData() {
          log("Fetching data from server...");
        }
      }

    # Output:
    final service = MyService();
    service.fetchData(); // [LOG]: Fetching data from server...


  ```

# 🚀 Flutter Build Modes
- ## 🔧 Debug Mode
  - Used while developing and testing your app.
  - Feature: Hot Reload, Debug banners, Assertions enabled, Dev tools (inspector, logs, etc.), Error messages & stack traces
  - Use When: You're actively building, debugging, or testing your UI and logic.
- ## 🔬 Profile Mode
  - Used for performance profiling – to measure app speed, CPU/GPU usage, memory, etc.
  - Features: Disables debugging features, Keeps some tooling for profiling and Mimics release performance (almost)
  - Use When: You want to analyze app performance before releasing.
- ## 🏁 Release Mode
  - Used when you're releasing the app to the Play Store, App Store, or publishing to the web.
  - Features: Full optimizations, Code obfuscation (optional), No debugging logs or banners, Smallest build size and Fastest runtime
  - Use When: You're deploying to users in production.

# 🏗️ Flutter Framework Architecture – Overview
Flutter's architecture is layered, starting from your code (widgets) down to the native platform.
It has four main layers:

- ## 🔹 Framework Layer (Dart Code) – Top Layer
  This is where you write your app.It's implemented in Dart and provides all the tools needed to build the UI.
  - ### Key Parts     
      - Widgets: UI building blocks (StatelessWidget, StatefulWidget)
      - Rendering: Lays out and paints widgets
      - Animation: Built-in support for motion
      - Gestures: Touch input detection
  - 🧠 This is the highest level, easy to use, and most customizable.
  
- ## 🔸 Engine Layer (C++)
  This is the core rendering layer, written in C++.
    - ### Responsibilities:
        - Skia: 2D rendering engine that draws the UI.
        - Text Rendering
        - Compositing
        - Image Decoding
        - Plugin Architecture
    - 🧠 It converts Dart UI instructions into native instructions for iOS/Android/Web.

- ## 🔹 Embedder Layer
  This is the platform-specific code (C/C++/Java/Obj-C/Kotlin/Swift) that hosts the Flutter app.
    - ### Examples:
        - iOS: Uses Objective-C/Swift
        - Android: Uses Java/Kotlin
        - Web/Desktop: Uses appropriate platform code
    - ### Responsibilities:
        - Platform views
        - Keyboard, mouse, touch inputs
        - App lifecycle (pause, resume, etc.)
        - Native plugins (camera, GPS, etc.)
    - 🧠 It acts as the bridge between native OS and Flutter.

- ## 🔸 Native Platform (iOS, Android, Web, etc.)
  This is your actual device's OS. It interacts with the Flutter engine via platform channels.
  

- ## 📊 Diagram Representation (Top to Bottom)

<img width="731" alt="Screenshot 2025-04-06 at 10 31 09 AM" src="https://github.com/user-attachments/assets/32178357-c0e5-4e64-a58a-c0a6e1d32275" />


- ## 🔁 How it Works (Simplified Flow):
  - You write widgets using Dart.
  - Widgets → Elements → RenderObjects.
  - Rendering code passes layout info to Skia engine.
  - Engine draws UI on the screen via native canvas.
  - Input from user (like touch) goes up from native → Flutter engine → Dart code.

# 🧱 LifeCycle 

The lifecycle of a Flutter widget depends on whether it is a Stateless or Stateful widget.

- ## 🔹 StatelessWidget Lifecycle

  A StatelessWidget is immutable – once it's built, it cannot change during the app's runtime.
  StatelessWidget has a very simple lifecycle because it doesn’t hold any mutable state.
  
  ### ✅ Use When:
  - UI does not depend on user interaction or data that can change.
  - Example: Icons, Texts, Static Screens.
  - State Maintenance:	No
  - Lifecycle Methods: Only build()
  
  ```bash
      class MyWidget extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          return Text('Hello');
        }
      }
  ```
  ### ✅ Lifecycle Method:
  - **build():** Called once when the widget is created and when it's rebuilt from above in the widget tree.
  - So, StatelessWidget is built once and re-built only when its parent rebuilds it with different inputs.

- ## 🔸 StatefulWidget Lifecycle
  A StatefulWidget is mutable – it can change over time based on user actions, timers, or data updates.
  A StatefulWidget can change over time, so its lifecycle has more steps.
  
  
  ### ✅ Use When:
  - UI needs to update dynamically.
  - Example: Forms, Buttons, Counters, Animations, API data.
  - State Maintenance: Yes (through State object)
  - Lifecycle Methods: Full lifecycle (initState(), etc.)
  
  ```bash
      class MyWidget extends StatefulWidget {
        @override
        _MyWidgetState createState() => _MyWidgetState();
      }

      class _MyWidgetState extends State<MyWidget> {
        @override
        void initState() {
          super.initState();
          print('initState');
        }

        @override
        Widget build(BuildContext context) {
          print('build');
          return Text('Hello Stateful');
        }

        @override
        void didUpdateWidget(MyWidget oldWidget) {
          super.didUpdateWidget(oldWidget);
          print('didUpdateWidget');
        }

        @override
        void dispose() {
          print('dispose');
          super.dispose();
        }
      }
  ```
  ### 🔁 StatefulWidget Lifecycle (Step-by-step):
  - **createState():**	Called when the widget is inserted into the tree. Creates the State object.
  - **initState():**	Called once when the State is initialized. Used for one-time setup (e.g., API calls, listeners).
  - **didChangeDependencies():**	Called after initState(), and when dependencies change (like InheritedWidget).
  - **build()**	Called to render the UI. Runs multiple times (e.g., after setState()).
  - **didUpdateWidget()**	Called when the parent widget updates and needs to pass new data to the child.
  - **deactivate()**	Called when the widget is removed from the tree temporarily.
  - **dispose()**	Called when the widget is permanently removed. Clean up (e.g., controllers, listeners).

  ### 🧠 Summary Diagram:
  
  <img width="749" alt="Screenshot 2025-04-06 at 9 54 11 AM" src="https://github.com/user-attachments/assets/b1b3ae62-40ca-4e7d-b61d-90927d8c60da" />

# 🧪 Testing in Flutter
- ✅ Unit Test:	Test individual functions or classes
  ```bash
      test('adds two numbers', () {
        final sum = add(2, 3);
        expect(sum, 5);
      });

  ```
- ✅ Widget Test:	Test UI + interaction
   ```bash
      testWidgets('Counter increments smoke test', (tester) async {
        await tester.pumpWidget(MyApp());
        expect(find.text('0'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
        expect(find.text('1'), findsOneWidget);
      });

   ```
- ✅ Integration Test:	Test full app (UI + backend + flow)
- ✅ bloc_test:
  - bloc_test is a package that simplifies writing tests for BLoC classes
  - it helps you to Trigger events, Expect emitted states aand Avoid boilerplate code
  
    ```bash
        import 'package:flutter_test/flutter_test.dart';
        import 'package:bloc_test/bloc_test.dart';
        import 'counter_bloc.dart';
        import 'counter_event.dart';
        import 'counter_state.dart';

        void main() {
          group('CounterBloc', () {
            blocTest<CounterBloc, CounterState>(
              'emits [CounterState(1)] when IncrementEvent is added',
              build: () => CounterBloc(),
              act: (bloc) => bloc.add(IncrementEvent()),
              expect: () => [CounterState(1)],
            );
          });
        }
    ```

# 🔁 Architecture Pattern

- ## 🧱 Clean Architecture
    Clean Architecture separates code into layers for better scalability and testability:

    Benefits: Easy to test, Modular and Clean separation of concerns

    - ### Diagram
      <img width="754" alt="Screenshot 2025-04-07 at 8 15 26 AM" src="https://github.com/user-attachments/assets/21588311-7536-4f59-979f-90e2d4e05205" />

      
- ## 🧱 MVC – Model View Controller
  - Model     →  Handles data, business logic
  - View      →  UI layer (Widgets in Flutter)
  - Controller → Handles user input, updates model & view
  - EX: Model: User class, View: UserScreen widget and Controller: A class/method that fetches user data and updates state
  - Issues: Tight coupling between View & Controller
  - Issues: Doesn't scale well for large apps

- ## 🧱 MVP – Model View Presenter
  - Model     → Data layer (API, DB)
  - View      → UI layer (Stateless/Stateful Widgets)
  - Presenter → Handles logic, updates View via interface
  - The Presenter is more testable and independent of the UI framework.
  - Difficult to separate View & Presenter because Flutter heavily integrates UI with logic in widgets.

- ## 🧱 MVVM – Model View ViewModel
  - Model       → API/data classes
  - View        → UI widgets
  - ViewModel   → Acts as bridge; holds logic/state and notifies the View
  - Ex: Model: User, View: UserScreen and ViewModel: UserProvider (extends ChangeNotifier)

- ## 🔁 Architecture Comparison

  <img width="767" alt="Screenshot 2025-04-07 at 8 55 52 AM" src="https://github.com/user-attachments/assets/dddfffc1-04d0-4af0-aa66-a242ad6f013b" />



# 1️⃣ SOLID Principles

SOLID is an acronym for 5 core object-oriented design principles that make your code clean, scalable, and maintainable.

- S – Single Responsibility: A class should do one thing.
  - Example: Don’t mix API logic with UI. Keep your UserRepository, UserBloc, and UserScreen separate.
- O – Open/Closed: Code should be open for extension, but closed for modification.
  - Example: Add new UI themes using ThemeData, don’t modify the base app.
- L – Liskov Substitution:	Subclasses should be usable wherever parent is expected.
  - Example: If Bird has fly(), a Penguin shouldn't extend Bird if it can't fly.
- I – Interface Segregation:	Don’t force classes to implement unused interfaces.
  - Example: Use small, focused abstract classes or mixins.
- D – Dependency Inversion:	High-level modules shouldn’t depend on low-level ones. Both should depend on abstractions.
  - Example: Use abstract AuthService and inject concrete FirebaseAuthService via Provider/DI.

# 2️⃣ Singleton Class in Dart

A singleton ensures only one instance of a class exists during the app lifecycle.

✅ Use singleton for: Caching, Global services (e.g., Logger, Analytics, AppConfig)

  ```bash
      class MyService {
        static final MyService _instance = MyService._internal();

        factory MyService() => _instance;

        MyService._internal(); // private constructor
      }
      final service = MyService();
  ```
  
# 3️⃣ Dependency Injection (DI)

DI is when a class gets the objects it depends on from outside, rather than creating them itself.

✅ Benefits: Loose coupling, Easier to test and Better architecture

✅ In Flutter, use DI with: Provider, get_it and riverpod

# 🔍 Serialization?
Serialization is the process of converting a Dart object into a format like JSON or Map so it can be:
- Sent over the network (e.g., via API)
- Stored (e.g., in SharedPreferences, SQLite)
- Deserialization is the reverse — converting JSON/Map back to a Dart object.

  ```bash
  flutter pub run build_runner build
  ```
# 🧠 What is OOP (Object-Oriented Programming)?

OOP is a programming paradigm based on the concept of "objects", which contain: Properties (fields/variables) and Methods (functions/behavior)

Dart is a pure object-oriented language — even functions are objects!

- ## 🔑 4 Pillars of OOP in Dart
  - Encapsulation	Hiding internal details and exposing only what’s needed
  - Inheritance	Reusing properties and methods from another class
  - Polymorphism	One interface, multiple implementations
  - Abstraction	Showing only essential details, hiding complexity

- ## ✅ 1. Encapsulation
  - Keeping data safe and private inside a class using access modifiers.
  - _balance is private (starts with _)
  - Accessed only through getter/setter
  - Example:
    ```bash
      class BankAccount {
        double _balance = 0; // private variable

        double get balance => _balance;

        void deposit(double amount) {
          _balance += amount;
        }
      }
    ```
- ## ✅ 2. Inheritance
  - Allows one class to inherit from another.
  - Dog gets sound() from Animal
  - Example:
    ```bash
        class Animal {
          void sound() => print("Animal sound");
        }

        class Dog extends Animal {
          void bark() => print("Woof!");
        }
    ```
- ## ✅ 3. Polymorphism
  - Same method name, different behavior based on the object.
  - Example:
    ```bash
        class Animal {
          void sound() => print("Generic sound");
        }

        class Cat extends Animal {
          @override
          void sound() => print("Meow");
        }

        void main() {
          Animal animal = Cat();  // Polymorphism
          animal.sound();         // Output: Meow
        }
    ```
- ## ✅ 4. Abstraction
  - Use abstract classes or interfaces to hide complex logic.
  - Vehicle defines what to do
  - Car defines how to do it
  - Example:
    ```bash
        abstract class Vehicle {
          void start();
        }

        class Car implements Vehicle {
          @override
          void start() => print("Car started");
        }
    ```
- ## 🧱 Dart OOP Keywords Recap
  - class	Defines an object structure
  - extends	Inheritance
  - implements	Interface implementation
  - abstract	Define a contract, can’t be instantiated
  - @override	Override methods from base class
  - this	Refers to current instance
  - super	Access parent class constructor/method

- ## 🧱 1. Abstract Class
  An abstract class is a class that can’t be instantiated directly.
  
  It is meant to be inherited by other classes and usually contains abstract methods (methods without implementation).
  
  ```bash
      abstract class Animal {
      void makeSound(); // abstract method (no body)
    }

    class Dog extends Animal {
      @override
      void makeSound() {
        print("Woof!");
      }
    }
    
    
    // Error ❌
    final animal = Animal(); // Abstract class can't be instantiated
  ```
- ## 🧩 2. Interface in Dart
  Dart doesn’t have a separate interface keyword like Java. 
  
  Instead, every class in Dart is also an interface by default.
  
  ```bash
      class Flyable {
        void fly() {
          print("Flying...");
        }
      }

      class Swimmable {
        void swim() {
          print("Swimming...");
        }
      }

      class Duck implements Flyable, Swimmable {
        @override
        void fly() => print("Duck flies");

        @override
        void swim() => print("Duck swims");
      }
  ```
- ## 🙋‍♂️ 3. this Keyword
  this refers to the current instance of a class. It helps you:
  - Access class variables/methods
  - Disambiguate between local and instance variables

  ```bash
    class User {
      String name;

      User(this.name); // Uses 'this' implicitly

      void printName() {
        print(this.name); // Can also write just 'name'
      }
    }

    OR
    
    class User {
      String name;

      User(String name) {
        this.name = name; // using 'this' to differentiate
      }
    }

  ```
  
