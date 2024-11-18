package fr.rowlaxx.quizzerai.player;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@AllArgsConstructor
@RequestMapping("/player")
@CrossOrigin(allowCredentials = "true", originPatterns = "*", allowedHeaders = "*")
public class PlayerController {

    @PostMapping("/name")
    public Player setName(Player player, @RequestParam(name = "value") String value) {
        player.setName(value);
        return player;
    }

    @GetMapping
    public Player getPlayer(Player player) {
        return player;
    }

}
