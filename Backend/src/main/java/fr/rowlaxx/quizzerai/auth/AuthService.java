package fr.rowlaxx.quizzerai.auth;

import fr.rowlaxx.quizzerai.player.Player;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
@AllArgsConstructor
public class AuthService {

    private final Map<String, Player> players = new HashMap<>();

    public Player getOrCreatePlayer(String token) {
        if (AuthUtils.isTokenValid(token) && players.containsKey(token)) {
            return players.get(token);
        }

        var player = new Player();
        var uuid = player.getUuid().toString();
        players.put(uuid, player);
        return player;
    }

}
