import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'dart:math';
import 'signup_page.dart';
import 'profile_page.dart';
import 'package:confetti/confetti.dart';


// ✅ Make sure this file exists
 // ✅ Your home screen where the game is

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TicTacToeApp());
}


class TicTacToeApp extends StatefulWidget {
  const TicTacToeApp({super.key});

  @override
  State<TicTacToeApp> createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp> {
  bool isDarkTheme = true;

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: HomePage(
        isDark: isDarkTheme,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}
// ⬅️ Added import for ProfilePage

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomePage({super.key, required this.isDark, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? updatedUser) {
      setState(() {
        user = updatedUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: user != null
                ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: user!.photoURL != null
                    ? ClipOval(
                  child: Image.network(
                    user!.photoURL!,
                    fit: BoxFit.cover,
                    width: 36,
                    height: 36,
                  ),
                )
                    : const Icon(Icons.person, size: 20, color: Colors.black),
              ),
            )
                : const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/pic.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // dark overlay
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 4),
                    // Player vs AI Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GamePage(vsAI: true, boardSize: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Player vs AI 🤖',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5x5 Player vs AI Button (Middle button)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GamePage(vsAI: true, boardSize: 4),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '4x4 Player vs AI 🎯',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Player vs Player Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GamePage(vsAI: false, boardSize: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Player vs Player 🧑‍🤝‍🧑',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            },
                            icon: Image.asset(
                              'assets/google_icon.png',
                              height: 20,
                            ),
                            label: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignupPage()),
                              );
                            },
                            icon: Image.asset(
                              'assets/google_icon.png',
                              height: 20,
                            ),
                            label: const Text('Sign Up'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedOptionButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AnimatedOptionButton({super.key, required this.label, required this.color, required this.onTap});

  @override
  State<AnimatedOptionButton> createState() => _AnimatedOptionButtonState();
}

class _AnimatedOptionButtonState extends State<AnimatedOptionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _hovered ? 270 : 250,
          height: 60,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_hovered ? 0.9 : 0.7),
            borderRadius: BorderRadius.circular(20),
            boxShadow: _hovered
                ? [
              BoxShadow(
                color: widget.color.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ]
                : [],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _hovered ? Colors.black : Colors.white,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}



class GamePage extends StatefulWidget {
  final bool vsAI;
  final int boardSize;

  const GamePage({super.key, required this.vsAI, required this.boardSize});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<String> board;
  bool xTurn = true;
  String winner = '';
  bool gameOver = false;

  int xScore = 0;
  int oScore = 0;
  int drawScore = 0;
  List<int> winningLine = [];

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    resetGame();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void resetGame() {
    setState(() {
      board = List.filled(widget.boardSize * widget.boardSize, '');
      xTurn = true;
      winner = '';
      gameOver = false;
      winningLine = [];
    });
    if (widget.vsAI && !xTurn) {
      Future.delayed(const Duration(milliseconds: 500), () {
        aiMove();
      });
    }
  }

  void makeMove(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = xTurn ? 'X' : 'O';
        xTurn = !xTurn;
      });
      checkWinner();
      if (widget.vsAI && !xTurn && !gameOver) {
        Future.delayed(const Duration(milliseconds: 500), () {
          aiMove();
        });
      }
    }
  }

  void aiMove() {
    int bestScore = -9999;
    int move = -1;
    int maxDepth = widget.boardSize == 3 ? 10 : 3; // LIMIT DEPTH for 4x4

    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = minimax(board, 0, false, -10000, 10000, maxDepth);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }
    if (move != -1) {
      makeMove(move);
    }
  }

  int minimax(List<String> newBoard, int depth, bool isMaximizing, int alpha, int beta, int maxDepth) {
    String result = getWinner(newBoard);
    if (result != '') {
      if (result == 'O') return 1000 - depth;
      if (result == 'X') return depth - 1000;
      return 0;
    }

    if (!newBoard.contains('') || depth >= maxDepth) {
      return 0; // Draw or reached max depth
    }

    if (isMaximizing) {
      int maxEval = -9999;
      for (int i = 0; i < newBoard.length; i++) {
        if (newBoard[i] == '') {
          newBoard[i] = 'O';
          int eval = minimax(newBoard, depth + 1, false, alpha, beta, maxDepth);
          newBoard[i] = '';
          maxEval = max(maxEval, eval);
          alpha = max(alpha, eval);
          if (beta <= alpha) break; // Beta cut-off
        }
      }
      return maxEval;
    } else {
      int minEval = 9999;
      for (int i = 0; i < newBoard.length; i++) {
        if (newBoard[i] == '') {
          newBoard[i] = 'X';
          int eval = minimax(newBoard, depth + 1, true, alpha, beta, maxDepth);
          newBoard[i] = '';
          minEval = min(minEval, eval);
          beta = min(beta, eval);
          if (beta <= alpha) break; // Alpha cut-off
        }
      }
      return minEval;
    }
  }

  void checkWinner() {
    String result = getWinner(board);
    if (result != '') {
      setState(() {
        winner = result;
        gameOver = true;
        if (result == 'X') xScore++;
        if (result == 'O') oScore++;
        winningLine = getWinningLine(board);
        _confettiController.play();
      });
    } else if (!board.contains('')) {
      setState(() {
        winner = 'Draw';
        gameOver = true;
        drawScore++;
      });
    }
  }

  String getWinner(List<String> b) {
    int size = widget.boardSize;
    List<List<int>> winPositions = [];

    for (int i = 0; i < size; i++) {
      winPositions.add(List.generate(size, (index) => i * size + index));
    }
    for (int i = 0; i < size; i++) {
      winPositions.add(List.generate(size, (index) => i + index * size));
    }
    winPositions.add(List.generate(size, (i) => i * (size + 1)));
    winPositions.add(List.generate(size, (i) => (i + 1) * (size - 1)));

    for (var pos in winPositions) {
      if (b[pos[0]] != '' && pos.every((index) => b[index] == b[pos[0]])) {
        return b[pos[0]];
      }
    }
    return '';
  }

  List<int> getWinningLine(List<String> b) {
    int size = widget.boardSize;
    List<List<int>> winPositions = [];

    for (int i = 0; i < size; i++) {
      winPositions.add(List.generate(size, (index) => i * size + index));
    }
    for (int i = 0; i < size; i++) {
      winPositions.add(List.generate(size, (index) => i + index * size));
    }
    winPositions.add(List.generate(size, (i) => i * (size + 1)));
    winPositions.add(List.generate(size, (i) => (i + 1) * (size - 1)));

    for (var pos in winPositions) {
      if (b[pos[0]] != '' && pos.every((index) => b[index] == b[pos[0]])) {
        return pos;
      }
    }
    return [];
  }

  Widget buildCell(int index) {
    bool isWinningCell = winningLine.contains(index);
    return GestureDetector(
      onTap: () => makeMove(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isWinningCell
              ? Colors.greenAccent.withOpacity(0.7)
              : board[index] == ''
              ? Colors.transparent
              : board[index] == 'X'
              ? Colors.blue.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: board[index] == '' ? 0 : 1,
            curve: Curves.bounceOut,
            child: Text(
              board[index],
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: board[index] == 'X' ? Colors.blue : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget scoreBox(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          '$score',
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.vsAI ? 'Player vs AI 🤖' : 'Player vs Player 👥'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      scoreBox('X', xScore, Colors.blue),
                      scoreBox('O', oScore, Colors.red),
                      scoreBox('Draw', drawScore, Colors.grey),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: board.length,
                    padding: const EdgeInsets.all(24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.boardSize,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) => buildCell(index),
                  ),
                ),
                Text(
                  gameOver
                      ? winner == 'Draw'
                      ? "It's a Draw!"
                      : '$winner Wins!'
                      : xTurn
                      ? 'X\'s Turn'
                      : 'O\'s Turn',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
