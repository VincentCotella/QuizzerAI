package fr.rowlaxx.quizzerai.game;

import fr.rowlaxx.quizzerai.player.Player;
import fr.rowlaxx.quizzerai.question.QuestionGeneratorService;
import lombok.AllArgsConstructor;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.CompletableFuture;

@Slf4j
@Service
@AllArgsConstructor
public class GameService {
    private final Random random = new Random();
    private final Map<Integer, Game> games = new HashMap<>();
    private final GameNotifier notifier;
    private final QuestionGeneratorService questionGenerator;
    private final GameplayService gameplay;

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
        var game = new Game(code, count, theme, difficulty, player);

        CompletableFuture.runAsync(() -> {
            try {
                log.info("Generating {} questions for the theme {}", count, theme);
                game.getQuestions().addAll(questionGenerator.generateQuestions(theme, difficulty, count));
                log.info("Questions generated");
            } finally {
                game.setGenerating(false);
                game.setState(GameState.WAITING_FOR_PLAYER);
                notifier.notifyAllListener(game);
            }
        });

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

    public void startGame(Player player) {
        if (!player.isInGame()) {
            throw new IllegalStateException("You are not in a game");
        }

        var game = player.getCurrentGame();

        if (game.getOwner() != player) {
            throw new IllegalStateException("You are not the owner of this game");
        }

        gameplay.start(game);
    }
}
