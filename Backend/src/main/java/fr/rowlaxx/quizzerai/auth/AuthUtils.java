package fr.rowlaxx.quizzerai.auth;

import lombok.experimental.UtilityClass;

import java.util.UUID;

@UtilityClass
public class AuthUtils {

    public boolean isTokenValid(String token) {
        if (token == null)
            return false;

        try {
            UUID.fromString(token);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

}
