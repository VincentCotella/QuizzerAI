package fr.rowlaxx.quizzerai.game;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.*;

@Slf4j
@Component
@AllArgsConstructor
public class GameNotifier extends TextWebSocketHandler {
    private final Map<Integer, List<WebSocketSession>> sessions = new HashMap<>();
    private final ObjectMapper objectMapper;

    public void notifyAllListener(Game game) {
        var gameCode = game.getCode();
        var listeners = sessions.get(gameCode);

        if (listeners != null && !listeners.isEmpty()) {
            var message = objectMapper.valueToTree(game).toString();

            for (var listener : listeners) {
                try {
                    listener.sendMessage(new TextMessage(message));
                } catch (IOException e) {
                    log.error("Unable to send the message to the listener", e);
                }
            }
        }
    }

    public void closeAllListener(int gameCode) {
        var listeners = sessions.get(gameCode);

        if (listeners != null && !listeners.isEmpty()) {
            for (var listener : listeners) {
                try {
                    listener.close(CloseStatus.NORMAL);
                } catch (IOException e) {
                    log.error("Unable to close listener", e);
                }
            }
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        try {
            var code = getCode(session);
            sessions.computeIfAbsent(code, k -> new LinkedList<>()).add(session);
        } catch (IllegalStateException e) {
            session.close(CloseStatus.NOT_ACCEPTABLE);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        try {
            var code = getCode(session);
            var list = sessions.get(code);

            if (list != null) {
                list.remove(session);
            }
        } catch (IllegalStateException ignored) {}
    }

    private int getCode(WebSocketSession session) {
        var headers = session.getHandshakeHeaders();
        var code = headers.get("X-GameCode").stream().findFirst();

        try {
            return Integer.parseInt(code.orElseThrow());
        } catch (NoSuchElementException | NumberFormatException e) {
            throw new IllegalStateException("X-GameCode must be present and valid");
        }
    }
}
