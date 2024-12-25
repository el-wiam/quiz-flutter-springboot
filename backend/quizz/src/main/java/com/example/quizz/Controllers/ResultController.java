package com.example.quizz.Controllers;

import java.util.List;

import com.example.quizz.Services.QuizService;
import com.example.quizz.Services.ResultService;
import com.example.quizz.models.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/result")
@CrossOrigin(origins = "*")
public class ResultController {

    @Autowired
    private ResultService resultServ;

    @Autowired
    private QuizService quizServ;

    @PostMapping("/create")
    public ResponseEntity<?> addResult(@RequestBody Result result) throws Exception {
        System.out.println("============================================================================================================================================");
        System.out.println("uid: " + result.getUid());
        System.out.println("quizid: " + result.getQuizid());
        System.out.println("numofquestions: " + result.getNumofquestions());
        System.out.println("quesid: " + result.getUserqnas().get(0).getQuesid());
        System.out.println("answer: " + result.getUserqnas().get(0).getAnswer());
        System.out.println("============================================================================================================================================");

        return ResponseEntity.ok(this.resultServ.addResult(result));
    }

    @GetMapping("/current")
    public ResponseEntity<?> getCurrentResult() throws Exception {
        return ResponseEntity.ok(this.resultServ.getCurrentResult());
    }

    @GetMapping("/all/{uid}")
    public ResponseEntity<List<Result>> getAllResultsofUser(@PathVariable("uid") int uid) throws Exception {
        return ResponseEntity.ok(this.resultServ.getResultsofUser(uid));
    }

    @DeleteMapping("/deleteall/{uid}")
    public void deleteAllResultsofUser(@PathVariable("uid") int uid) {
        this.resultServ.deleteAllResultOfUser(uid);
    }

    @DeleteMapping("/delete/{resultid}")
    public void deleteResult(@PathVariable("resultid") int resultid) {
        this.resultServ.deleteResult(resultid);
    }
}
