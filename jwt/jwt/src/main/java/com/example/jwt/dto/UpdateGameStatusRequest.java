package com.example.jwt.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateGameStatusRequest {
    private int gameNumber; // 1 또는 2
}
