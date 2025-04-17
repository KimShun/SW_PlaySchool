package com.example.jwt.controller;

import com.example.jwt.entity.User;
import com.example.jwt.repository.UserRepository;
import com.example.jwt.security.JwtUtil;
import com.example.jwt.service.AuthService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/game")
@RequiredArgsConstructor
public class GameController {
    @Autowired
    private AuthService authService;

    @Autowired
    private JwtUtil jwtUtil;

    private final UserRepository userRepository;

    @PatchMapping("/todayclear")
    @Transactional
    public ResponseEntity<?> clearGame(
            @RequestHeader("Authorization") String token,
            @RequestParam int selectToday) {

        String jwtToken = token.substring(7);
        boolean isValid = jwtUtil.validateToken(jwtToken);
        String message = isValid ? "토큰이 유효합니다" : "토큰이 유효하지 않습니다";

        User user = authService.getUserByToken(jwtToken);

        if (selectToday == 1) {
            user.setTodayGame1(true);
        } else if (selectToday == 2) {
            user.setTodayGame2(true);
        } else {
            return ResponseEntity.badRequest().body("올바른 게임 번호(1 또는 2)를 입력해주세요.");
        }

        return ResponseEntity.ok("게임 클리어 상태가 업데이트되었습니다.");
    }
}
