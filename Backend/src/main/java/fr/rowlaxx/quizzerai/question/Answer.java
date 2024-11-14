package fr.rowlaxx.quizzerai.question;

import fr.rowlaxx.quizzerai.player.Player;
import lombok.Data;

import java.time.Duration;

@Data
public class Answer {

    private Player player;
    private int choice;
    private Duration duration;

}
