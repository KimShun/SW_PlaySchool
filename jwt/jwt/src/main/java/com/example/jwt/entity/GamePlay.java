package com.example.jwt.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "game_play")
public class GamePlay {
    @Id
    private String userUID;

    // 게임별 플레이 횟수
    @Column(nullable = false)
    private int wordGame = 0;

    @Column(nullable = false)
    private int findWrongGame = 0;

    @Column(nullable = false)
    private int danceGame = 0;

    @Column(nullable = false)
    private int paintGame = 0;

    @Column(nullable = false)
    private int makeBookGame = 0;
}
