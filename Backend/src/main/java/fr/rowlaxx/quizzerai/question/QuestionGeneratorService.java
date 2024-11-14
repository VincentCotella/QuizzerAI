package fr.rowlaxx.quizzerai.question;

import fr.rowlaxx.quizzerai.game.GameDifficulty;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.List;

@Service
@AllArgsConstructor
public class QuestionGeneratorService {
    private static final String URL = "https://flask-app-176267413620.us-central1.run.app";

    private RestTemplateBuilder restTemplateBuilder;

    @Data
    private static class Request {
        private String theme;
        private String niveau_difficulte;
        private int nbquestion;
    }

    @Data
    private static class Response {
        private List<ResponseQuestion> questions;
    }

    @Data
    private static class ResponseQuestion {
        private List<String> answers;
        private int correct;
        private String question;
    }

    public List<Question> generateQuestions(String theme, GameDifficulty gameDifficulty, int count) {
        var request = new Request();
        request.theme = theme;
        request.niveau_difficulte = gameDifficulty.getLitteral();
        request.nbquestion = count;

        var body = restTemplateBuilder
                .setReadTimeout(Duration.ofMinutes(3))
                .setConnectTimeout(Duration.ofSeconds(10))
                .build()
                .postForEntity(URL + "/generer", request, Response.class).getBody();

        if (body == null) {
            return List.of();
        }

        return body.questions.stream()
                .map(q -> new Question()
                        .setQuestion(q.getQuestion())
                        .setAnswer(q.getCorrect())
                        .setOptions(q.getAnswers())
                        .setMultiplicator(Math.random() < 0.1 ? 2 : 1))
                .toList();
    }

}
