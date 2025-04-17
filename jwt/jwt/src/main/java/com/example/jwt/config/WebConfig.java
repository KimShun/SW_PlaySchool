//CORS 요청 설정 flutter에서 명령 받고 실행하거나 하기 위해서 설정
package com.example.jwt.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**") // 모든 경로에 대해
                .allowedOrigins("*") // 모든 origin 허용 (Flutter 앱 IP로 바꾸는 게 안전)
                // 나중에 배포시에는 .allowedOrigins("http://ourflutterapp.com")과 같이 작성하는게 안정
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*");
//                .allowCredentials(true); // 필요시
    }
}
