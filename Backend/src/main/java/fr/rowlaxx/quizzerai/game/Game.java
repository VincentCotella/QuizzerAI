package fr.rowlaxx.quizzerai.game;

import fr.rowlaxx.quizzerai.player.Player;
import fr.rowlaxx.quizzerai.question.Question;
import lombok.Data;

import java.util.*;

@Data
public class Game {

    private final int code;
    private final int count;
    private final String theme;
    private final GameDifficulty difficulty;

    private boolean generating = true;
    private boolean started = false;
    private boolean finished = false;
    private List<Player> players = new ArrayList<>();

    private final List<Question> questions = new ArrayList<>();
    private int currentQuestion;

}
