package com.example.jwt.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@Builder
@Table(name = "game_play")
public class GamePlay {

    @Id
    private String userUID;

    // 게임별 플레이 횟수
    @Column(nullable = false)
    private int wordGame;

    @Column(nullable = false)
    private int findWrongGame;

    @Column(nullable = false)
    private int danceGame;

    @Column(nullable = false)
    private int paintGame;

    @Column(nullable = false)
    private int makeBookGame;

    public GamePlay() {
        this.wordGame = 0;
        this.findWrongGame = 0;
        this.danceGame = 0;
        this.paintGame = 0;
        this.makeBookGame = 0;
    }
}
