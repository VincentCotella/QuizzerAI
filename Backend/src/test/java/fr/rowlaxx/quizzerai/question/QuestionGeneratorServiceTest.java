package fr.rowlaxx.quizzerai.question;

import fr.rowlaxx.quizzerai.game.GameDifficulty;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class QuestionGeneratorServiceTest {

    private static final Logger log = LoggerFactory.getLogger(QuestionGeneratorServiceTest.class);
    @Autowired
    private QuestionGeneratorService service;

    @Test
    public void a() {
        log.info(service.generateQuestions("Francais", GameDifficulty.HARD, 5).toString());
    }

}