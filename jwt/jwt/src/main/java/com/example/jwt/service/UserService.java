package com.example.jwt.service;

import com.example.jwt.dto.SignupRequestDto;
import com.example.jwt.entity.GamePlay;
import com.example.jwt.entity.User;
import com.example.jwt.repository.GamePlayRepository;
import com.example.jwt.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final GamePlayRepository gamePlayRepository;
    private final PasswordEncoder passwordEncoder;

    public void signup(SignupRequestDto requestDto) {
        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(requestDto.getPassword());

        // User 객체 생성
        User user = User.builder()
                .email(requestDto.getEmail())
                .password(encodedPassword)
                .nickname(requestDto.getNickname())
                .birthDate(requestDto.getBirthDate())
                .gender(requestDto.getGender())
                .createdAt(LocalDateTime.now())
                .todayGame1(false)
                .todayGame2(false)
                .exp(0)
                .level(1)
                .build();

        userRepository.save(user); // 먼저 저장해야 ID 생성됨

        // GamePlay 객체 생성 및 연결
        GamePlay gamePlay = GamePlay.builder()
                .userUID(user.getUserUID())
                .wordGame(0)
                .findWrongGame(0)
                .danceGame(0)
                .paintGame(0)
                .makeBookGame(0)
                .build();

        gamePlayRepository.save(gamePlay);

        // user에도 반영
        user.setGamePlay(gamePlay);
        userRepository.save(user); // 관계 저장
    }
}