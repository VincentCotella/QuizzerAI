package fr.rowlaxx.quizzerai.game;

import fr.rowlaxx.quizzerai.player.Player;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/game")
@AllArgsConstructor
@CrossOrigin
public class GameController {
    private final GameService gameService;
    private final GameplayService gameplayService;

    @PostMapping
    public Game createGame(
            Player player,
            @RequestParam(name = "difficulty") GameDifficulty difficulty,
            @RequestParam(name = "theme") String theme,
            @RequestParam(name = "count") int count) {
        return gameService.createGame(player, count, theme, difficulty);
    }

    @PostMapping("/join")
    public Game joinGame(
            Player player,
            @RequestParam(name = "code") int code) {
        return gameService.joinGame(code, player);
    }

    @DeleteMapping
    public void leaveGame(Player player) {
        gameService.leaveGame(player);
    }

    @GetMapping
    public Game getGame(Player player) {
        if (!player.isInGame()) {
            throw new IllegalStateException("You are not in a game");
        }
        return player.getCurrentGame();
    }

    @PostMapping("/start")
    public void startGame(Player player) {
        gameService.startGame(player);
    }

    @PostMapping("/answer")
    public void answerQuestion(Player player, @RequestParam(name = "choice") int choice) {
        gameplayService.answer(player, choice);
    }
}
