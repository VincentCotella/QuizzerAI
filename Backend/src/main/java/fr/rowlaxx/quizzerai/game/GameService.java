package fr.rowlaxx.quizzerai.game;

import fr.rowlaxx.quizzerai.player.Player;
import lombok.AllArgsConstructor;
import lombok.NonNull;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
@AllArgsConstructor
public class GameService {
    private final Random random = new Random();
    private final Map<Integer, Game> games = new HashMap<>();
    private final GameNotifier notifier;

    private int generateCode() {
        if (games.size() >= 1_000_000) {
            throw new IllegalStateException("Too many games");
        }

        int code = -1;

        while (code == -1 || games.containsKey(code)) {
            code = random.nextInt(1_000_000);
        }

        return code;
    }

    public Game createGame(Player player, int count, String theme, GameDifficulty difficulty) {
        if (player.isInGame()) {
            throw new IllegalStateException("You are already playing a game");
        }

        var code = generateCode();
        var game = new Game(code, count, theme, difficulty);
        games.put(code, game);
        joinGame(code, player);
        return game;
    }

    public Game joinGame(int code, @NonNull Player player) {
        var game = games.get(code);

        if (game == null) {
            throw new IllegalStateException("Game '" + code + "' not found");
        }
        if (game.isStarted()) {
            throw new IllegalStateException("Game is already started");
        }
        if (game.isFinished()) {
            throw new IllegalStateException("Game is finished");
        }
        if (player.isInGame()) {
            throw new IllegalStateException("You are already playing a game");
        }

        player.setCurrentGame(game);
        game.getPlayers().add(player);
        notifier.notifyAllListener(game);
        return game;
    }

    public void leaveGame(Player player) {
        if (player.isInGame()) {
            var game = player.getCurrentGame();
            player.getCurrentGame().getPlayers().remove(player);
            player.setCurrentGame(null);
            notifier.notifyAllListener(game);
        }
    }
}
