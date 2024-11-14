package fr.rowlaxx.quizzerai.game;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum GameDifficulty {
    BEGINNER("débutant"),
    EASY("facile"),
    INTERMEDIATE("intermédiaire"),
    HARD("difficile"),
    ADVANCED("avancé");

    private final String litteral;


}
