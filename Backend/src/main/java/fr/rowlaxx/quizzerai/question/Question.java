package fr.rowlaxx.quizzerai.question;

import lombok.Data;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Data
public class Question {

    private String question;
    private List<String> options;
    private double multiplicator;
    private int answer;

    private Map<UUID, Answer> answers;
}
