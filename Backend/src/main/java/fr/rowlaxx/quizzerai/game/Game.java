package fr.rowlaxx.quizzerai.game;

import com.fasterxml.jackson.annotation.JsonIgnore;
import fr.rowlaxx.quizzerai.player.Player;
import fr.rowlaxx.quizzerai.question.Question;
import lombok.Data;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Data
public class Game {

    private final int code;
    private final int count;
    private final String theme;
    private final GameDifficulty difficulty;
    private final Player owner;

    private boolean generating = true;
    private boolean started = false;
    private boolean finished = false;
    private List<Player> players = new ArrayList<>();

    private final List<Question> questions = new ArrayList<>();
    private GameState state = GameState.GENERATING;
    private Instant stateSince = Instant.now();
    private int currentQuestionIndex;
    private int countdown;

    @JsonIgnore
    public Question getCurrentQuestion() {
        return questions.get(currentQuestionIndex);
    }

    public void setState(GameState state) {
        this.state = state;
        this.stateSince = Instant.now();
    }

    public Map<UUID, Integer> getPoints() {
        return questions.stream().flatMap(e -> e.getAnswers().entrySet().stream())
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        e -> e.getValue().getPoint(),
                        Integer::sum
                ));
    }
}
