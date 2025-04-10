package com.example.jwt.controller;

import com.example.jwt.dto.*;
import com.example.jwt.entity.User;
import com.example.jwt.repository.UserRepository;
import com.example.jwt.security.JwtUtil;
import com.example.jwt.service.AuthService;

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
    private AuthService authService;

    @Autowired
    private JwtUtil jwtUtil;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @PostMapping("/signup")
    public ResponseEntity<User> createUser(@Valid @RequestBody SignupRequestDto signupRequestDto) {
        User user = new User();

        user.setEmail(signupRequestDto.getEmail());

        String encoderPW = encoder.encode(signupRequestDto.getPassword());
        user.setPassword(encoderPW);

        user.setBirthDate(signupRequestDto.getBirthDate());
        user.setNickname(signupRequestDto.getNickname());
        user.setGender(signupRequestDto.getGender());

        user.setCreatedAt(LocalDateTime.now());

        User createdUser = userRepository.save(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
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
}