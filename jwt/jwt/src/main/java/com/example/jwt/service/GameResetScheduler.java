package com.example.jwt.service;

import com.example.jwt.entity.User;
import com.example.jwt.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class GameResetScheduler {

    private final UserRepository userRepository;

    // 매일 자정에 실행됨 (cron = "초 분 시 일 월 요일")
    @Scheduled(cron = "0 0 0 * * *")
    public void resetTodayGames() {
        log.info("⏰ 오늘의 게임 클리어 여부 초기화 시작");

        List<User> users = userRepository.findAll();

        for (User user : users) {
            user.setTodayGame1(false);
            user.setTodayGame2(false);
        }

        userRepository.saveAll(users);
        log.info("✅ 모든 사용자 게임 초기화 완료");
    }
}
