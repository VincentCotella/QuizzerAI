package fr.rowlaxx.quizzerai.game;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum GameDifficulty {
    BEGINNER("débutant"),
    EASY("facile"),
    INTERMEDIATE("intermédiaire"),
    HARD("difficile"),
    ADVANCED("avancé");

    private final String litteral;


}
