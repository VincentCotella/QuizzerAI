package fr.rowlaxx.quizzerai.player;

import fr.rowlaxx.quizzerai.auth.AuthService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import java.time.Duration;

@Slf4j
@Component
@AllArgsConstructor
public class PlayerArgumentResolver implements HandlerMethodArgumentResolver {
    private static final String NAME = "auth";

    private final AuthService authService;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.getParameterType() == Player.class;
    }

    @Override
    public Player resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) {
        var cookieHeader = webRequest.getHeader("Cookie");
        var auth = isValid(cookieHeader) ? cookieHeader.replaceFirst(NAME + "=", "") : null;
        var player = authService.getOrCreatePlayer(auth);
        var response = webRequest.getNativeResponse(HttpServletResponse.class);

        if (response != null) {
            var uuid = player.getUuid().toString();
            var cookie = new Cookie(NAME, uuid);

            cookie.setMaxAge((int) Duration.ofDays(1).toSeconds());
            cookie.setPath("/");
            cookie.setAttribute("SameSite", "None");
            cookie.setSecure(true);

            response.addCookie(cookie);
        }

        return player;
    }

    private boolean isValid(String cookie) {
        if (cookie == null)
            return false;

        return cookie.matches("^" + NAME + "=[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
    }
}
