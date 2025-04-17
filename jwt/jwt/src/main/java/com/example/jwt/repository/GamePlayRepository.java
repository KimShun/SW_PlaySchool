package com.example.jwt.repository;

import com.example.jwt.entity.GamePlay;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GamePlayRepository extends JpaRepository<GamePlay, Long> {
    GamePlay findByUserUID(String userUID);
}
