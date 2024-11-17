package fr.rowlaxx.quizzerai.game;

import fr.rowlaxx.quizzerai.player.Player;
import fr.rowlaxx.quizzerai.question.Answer;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.util.concurrent.CompletableFuture;

@Service
@AllArgsConstructor
public class GameplayService {
    private final GameNotifier notifier;

    public void start(Game game) {
        if (game.isGenerating()) {
            throw new IllegalStateException("Game is still generating");
        }
        if (game.isStarted()) {
            throw new IllegalStateException("Game is already started");
        }

        CompletableFuture.runAsync(() -> {
            game.setStarted(true);
            game.setState(GameState.STARTING);
            game.setCountdown(6);

            while (!game.isFinished()) {
                loop(game);
            }
        });
    }

    @SneakyThrows
    private void loop(Game game) {
        var countdown = game.getCountdown();
        var state = game.getState();
        var currentQuestion = game.getCurrentQuestionIndex();
        var countQuestion = game.getQuestions().size();

        if (countdown > 1) {
            game.setCountdown(countdown - 1);
            notifier.notifyAllListener(game);
            Thread.sleep(1000);
            return;
        }

        if (state == GameState.STARTING) {
            state = GameState.QUESTION;
            countdown = 3;
        }
        else if (state == GameState.QUESTION) {
            state = GameState.ANSWERS;
            countdown = 10;
        }
        else if (state == GameState.ANSWERS) {
            state = GameState.POINTS;
            countdown = 5;
        }
        else if (state == GameState.POINTS) {
            if (currentQuestion + 1 >= countQuestion) {
                state = GameState.ENDING;
                countdown = 0;
                game.setFinished(true);
            }
            else {
                state = GameState.QUESTION;
                countdown = 3;
            }
        }

        game.setState(state);
        game.setCountdown(countdown);
        notifier.notifyAllListener(game);

        if (game.isFinished()) {
            notifier.closeAllListener(game.getCode());
        }
    }

    public void answer(Player player, int choice) {
        if (!player.isInGame()) {
            throw new IllegalStateException("Player is not in a game");
        }

        var game = player.getCurrentGame();

        if (game.getState() != GameState.ANSWERS) {
            throw new IllegalStateException("Cannot answer right now");
        }

        var question = game.getCurrentQuestion();
        var answers = question.getAnswers();
        var uuid = player.getUuid();

        if (answers.containsKey(uuid)) {
            throw new IllegalStateException("You already answered");
        }

        var duration = Duration.between(Instant.now(), game.getStateSince());
        var answer = new Answer();

        answer.setDuration(duration);
        answer.setChoice(choice);

        var point = question.getAnswer() == choice ?
                1000 - (duration.toMillis() / 10) :
                0;

        answer.setPoint((int)(point * question.getMultiplicator()));
        answers.put(uuid, answer);
        notifier.notifyAllListener(game);
    }
}
