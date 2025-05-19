package com.example.jwt.controller;

import com.example.jwt.dto.*;
import com.example.jwt.entity.GamePlay;
import com.example.jwt.entity.User;
import com.example.jwt.repository.GamePlayRepository;
import com.example.jwt.repository.UserRepository;
import com.example.jwt.security.JwtUtil;
import com.example.jwt.service.AuthService;

import jakarta.transaction.Transactional;
import jakarta.validation.Valid;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.security.authentication.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GamePlayRepository gamePlayRepository;

    @Autowired
    private AuthService authService;

    @Autowired
    private JwtUtil jwtUtil;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @PostMapping("/signup")
    public ResponseEntity<String> createUser(@Valid @RequestBody SignupRequestDto signupRequestDto) {

        if (userRepository.existsByEmail(signupRequestDto.getEmail())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("이미 사용 중인 이메일입니다.");
        }


        User user = new User();
        user.setEmail(signupRequestDto.getEmail());

        String encoderPW = encoder.encode(signupRequestDto.getPassword());
        user.setPassword(encoderPW);
        user.setBirthDate(signupRequestDto.getBirthDate());
        user.setNickname(signupRequestDto.getNickname());
        user.setGender(signupRequestDto.getGender());
        user.setCreatedAt(LocalDateTime.now());

        User createdUser = userRepository.save(user);

        GamePlay gamePlay = new GamePlay();
        gamePlay.setUserUID(createdUser.getUserUID());
        gamePlayRepository.save(gamePlay);

        return ResponseEntity.status(HttpStatus.CREATED).body("회원가입이 완료되었습니다.");
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequestDto request) {
        try {
            String token = authService.login(request);
            return ResponseEntity.ok(new AuthResponse(token));
        } catch (BadCredentialsException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new AuthResponse("Invalid credentials"));
        }
    }

    @GetMapping("/validate")
    public ResponseEntity<TokenValidation> validateToken(@RequestHeader("Authorization") String token) {
        String jwtToken = token.substring(7);
        boolean isValid = jwtUtil.validateToken(jwtToken);
        String message = isValid ? "토큰이 유효합니다" : "토큰이 유효하지 않습니다";

        User user = authService.getUserByToken(jwtToken);
        System.out.println("Checking!! : " + user);

        return ResponseEntity.ok(new TokenValidation(isValid, message, user));
    }

    @PatchMapping("/expup")
    @Transactional
    public ResponseEntity<?> clearGame(@RequestHeader("Authorization") String token) {
        String jwtToken = token.substring(7);
        boolean isValid = jwtUtil.validateToken(jwtToken);
        String message = isValid ? "토큰이 유효합니다" : "토큰이 유효하지 않습니다";

        User user = authService.getUserByToken(jwtToken);
        if(user.getExp() >= 5) {
            return ResponseEntity.badRequest.body("이미 경험치가 5 입니다.");
        }

        user.setExp(user.getExp() + 1);
        return ResponseEntity.ok("경험치가 1 올랐습니다.");
    }

    @PatchMapping("/levelup")
    @Transactional
    public ResponseEntity<?> level(@RequestHeader("Authorization") String token) {
        String jwtToken = token.substring(7);
        boolean isValid = jwtUtil.validateToken(jwtToken);
        String message = isValid ? "토큰이 유효합니다" : "토큰이 유효하지 않습니다";

        User user = authService.getUserByToken(jwtToken);

        if(user.getExp() < 5) {
            return ResponseEntity.badRequest.body("경험치가 부족합니다.");
        }

        user.setLevel(user.getLevel() + 1);
        user.setExp(0);
        return ResponseEntity.ok("레벨이 1 올랐습니다.");
    }
}