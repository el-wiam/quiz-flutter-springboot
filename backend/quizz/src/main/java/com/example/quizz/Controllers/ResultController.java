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

    // Add a new result
    @PostMapping("/create")
    public ResponseEntity<Result> addResult(@RequestBody Result result) {
        return ResponseEntity.ok(this.resultServ.addResult(result));
    }

    // Get all results
    @GetMapping("/all")
    public ResponseEntity<List<Result>> getAllResults() {
        return ResponseEntity.ok(this.resultServ.getResults());
    }

    // Get a single result by its ID
    @GetMapping("/{resultid}")
    public ResponseEntity<Result> getResultById(@PathVariable("resultid") int resultid) {
        return ResponseEntity.ok(this.resultServ.getResult(resultid));
    }

    // Get the current result
    @GetMapping("/current")
    public ResponseEntity<Result> getCurrentResult() {
        return ResponseEntity.ok(this.resultServ.getCurrentResult());
    }

    // Delete a result by its ID
    @DeleteMapping("/delete/{resultid}")
    public ResponseEntity<Void> deleteResult(@PathVariable("resultid") int resultid) {
        this.resultServ.deleteResult(resultid);
        return ResponseEntity.noContent().build();
    }

    // Delete all results
    @DeleteMapping("/deleteall")
    public ResponseEntity<Void> deleteAllResults() {
        this.resultServ.deleteAllResult();
        return ResponseEntity.noContent().build();
    }

    // Get all results of a specific user
    @GetMapping("/all/{uid}")
    public ResponseEntity<List<Result>> getAllResultsOfUser(@PathVariable("uid") int uid) {
        return ResponseEntity.ok(this.resultServ.getResultsofUser(uid));
    }

    // Delete all results of a specific user
    @DeleteMapping("/deleteall/{uid}")
    public ResponseEntity<Void> deleteAllResultsOfUser(@PathVariable("uid") int uid) {
        this.resultServ.deleteAllResultOfUser(uid);
        return ResponseEntity.noContent().build();
    }
}
