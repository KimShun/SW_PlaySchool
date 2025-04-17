package com.example.jwt.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

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

    @Column(nullable = false)
    private int exp = 0;

    @Column(nullable = false)
    private int level = 1;

    @OneToOne
    @JoinColumn(name = "userUID")
    private GamePlay gamePlay;

    // UUID 자동 생성
    public User() {
        this.userUID = UUID.randomUUID().toString();
    }
}
