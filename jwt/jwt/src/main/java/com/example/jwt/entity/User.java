package com.example.jwt.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@Builder
@Table(name = "users")
public class User {

    @Id
    @Column(name = "userUID", nullable = false, unique = true)
    private String userUID;

    @Column(nullable = false, length = 255, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false, length = 50)
    private String nickname;

    @Column(name = "birth_date", nullable = false)
    private LocalDate birthDate;

    @Column(nullable = false)
    private String gender;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private boolean todayGame1 = false;

    @Column(nullable = false)
    private boolean todayGame2 = false;

    // 게임 이름별 플레이 횟수 저장용 Map
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "user_game_count", joinColumns = @JoinColumn(name = "user_uid"))
    @MapKeyColumn(name = "game_name")
    @Column(name = "count")
    private Map<String, Integer> countPerGame = new HashMap<>();

    // UUID 자동 생성
    public User() {
        this.userUID = UUID.randomUUID().toString();
    }

}
