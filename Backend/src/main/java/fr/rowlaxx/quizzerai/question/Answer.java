package fr.rowlaxx.quizzerai.question;

import fr.rowlaxx.quizzerai.player.Player;
import lombok.Data;

import java.time.Duration;

@Data
public class Answer {

    private int choice;
    private int point;
    private Duration duration;

}
