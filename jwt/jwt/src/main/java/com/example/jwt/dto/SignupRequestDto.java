package com.example.jwt.dto;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SignupRequestDto {
    @Email(message = "올바른 이메일 형식이 아닙니다.")
    private String email; // 이메일

    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$",
            message = "비밀번호는 영문+숫자+특수문자를 포함한 8자 이상이어야 합니다.")
    private String password;

    @NotBlank(message = "닉네임 입력")
    private String nickname;

    @Past(message = "생년월일은 과거 날짜여야 합니다.")
    private LocalDate birthDate;

    @Pattern(regexp = "^(남|여)$", message = "성별은 '남' 또는 '여'로 입력해야 합니다.")
    private String gender;
}