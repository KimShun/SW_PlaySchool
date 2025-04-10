package com.example.jwt.dto;

import lombok.*;
import com.example.jwt.entity.User;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TokenValidation {
    private boolean isValid;
    private String message;
    private User user;
}