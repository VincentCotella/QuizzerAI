package fr.rowlaxx.quizzerai.player;

import com.fasterxml.jackson.annotation.JsonIgnore;
import fr.rowlaxx.quizzerai.game.Game;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.UUID;

@RequiredArgsConstructor
@Data
public class Player {

    private final UUID uuid = UUID.randomUUID();
    private String name;

    @JsonIgnore
    private Game currentGame;

    public Integer getCurrentGameCode() {
        return currentGame == null ? null : currentGame.getCode();
    }

    public boolean isInGame() {
        return currentGame != null && !currentGame.isFinished();
    }
}
