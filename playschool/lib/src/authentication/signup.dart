import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// 포커스 상태에 따라 label과 hint를 바꾸는 커스텀 텍스트 필드 위젯
class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final double width;
  final double height;
  final double fontSize;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.width = 300,
    this.height = 50,
    this.fontSize = 18,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(fontSize: widget.fontSize),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelStyle: TextStyle(color: Colors.grey[500],fontSize: widget.fontSize),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),

            // 포커스되면 라벨, 그렇지 않으면 힌트 표시
            labelText: _isFocused ? widget.labelText : null,
            hintText: _isFocused ? null : widget.hintText,
            hintStyle: TextStyle(fontSize: widget.fontSize),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 각 텍스트 필드에 연결할 컨트롤러들
  final _nicknameController = TextEditingController();
  final _birthdayController = TextEditingController();
  // 성별은 컨트롤러 대신 선택 변수로 관리
  String? _selectedGender;
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  // 버튼 활성화 여부
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // 컨트롤러마다 리스너를 추가하여 입력 여부 확인
    _nicknameController.addListener(_checkInputs);
    _birthdayController.addListener(_checkInputs);
    _idController.addListener(_checkInputs);
    _passwordController.addListener(_checkInputs);
  }

  // 모든 필드가 채워졌는지 확인하는 함수
  void _checkInputs() {
    final allFilled = _nicknameController.text.isNotEmpty &&
        _birthdayController.text.isNotEmpty &&
        _selectedGender != null &&
        _idController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;

    setState(() {
      isButtonEnabled = allFilled;
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthdayController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget genderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(
              "  성별 선택",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            value: _selectedGender,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            dropdownColor: Colors.brown[50],
            borderRadius: BorderRadius.circular(15),
            elevation: 10,
            items: [
              DropdownMenuItem(
                value: "여자",
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "여자",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "남자",
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "남자",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
              _checkInputs();
            },
          ),
        ),
      ),
    );
  }









  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 터치 시 키보드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // 배경 이미지
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/background/login_bg.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 회원가입 UI
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 마법 아이콘
                    Image.asset(
                      "assets/icon/magic.png",
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    // 제목 텍스트
                    const Text(
                      "너의 정체를 알려줘!",
                      style: TextStyle(
                        color: Color(0xFF5C4033),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 애칭 필드: 영어, 한글, 숫자만 입력 가능
                    CustomTextField(
                      hintText: "너의 애칭은?",
                      labelText: "애칭",
                      controller: _nicknameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9ㄱ-힣]'),
                        ),
                      ],
                    ),

                    // 생일 필드: 숫자와 '.'만 입력 가능, 형식 예: 02.12.13
                    CustomTextField(
                      hintText: "생일 - 02.12.13",
                      labelText: "생일",
                      controller: _birthdayController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(

                          RegExp(r'[\d.]'),
                        ),
                      ],
                    ),

                    // 성별은 드롭다운으로 선택
                    genderDropdown(),

                    // 아이디 필드
                    CustomTextField(
                      hintText: "아이디",
                      labelText: "아이디",
                      controller: _idController,
                    ),

                    // 비밀번호 필드
                    CustomTextField(
                      hintText: "비밀번호",
                      labelText: "비밀번호",
                      controller: _passwordController,
                      obscureText: true,
                    ),

                    const SizedBox(height: 30),

                    // 버튼: 모든 필드가 채워졌을 때만 활성화
                    GestureDetector(
                      onTap: () {
                        if (isButtonEnabled) {
                          context.go('/login');
                        }
                      },
                      child: Container(
                        height: 55,
                        width: 250,
                        decoration: BoxDecoration(
                          color: isButtonEnabled
                              ? const Color(0xFF5C4033)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Center(
                          child: Text(
                            "정체 밝히기",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
