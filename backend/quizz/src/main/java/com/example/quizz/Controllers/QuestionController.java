package com.example.quizz.Controllers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.example.quizz.Services.QuestionService;
import com.example.quizz.Services.QuizService;
import com.example.quizz.models.Question;
import com.example.quizz.models.Quiz;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;



@RestController
@RequestMapping("/question")
@CrossOrigin(origins="*")
public class QuestionController {

    @Autowired
    private QuestionService quesServ;

    @Autowired
    private QuizService quizServ;


    //====== create Question =======================================================================
    @PostMapping("/create")
    public ResponseEntity<?> addQuestion(@RequestBody Question question)
    {
        return ResponseEntity.ok(this.quesServ.addQuestion(question));
    }

    //======== update Question =============================================================================
    @PutMapping("/update")
    public ResponseEntity<?> upadteQuestion(@RequestBody Question question)
    {
        return ResponseEntity.ok(this.quesServ.addQuestion(question));
    }

    //========= get  Questions by quiz ===============================================================================
    @GetMapping("/quiz/{quizId}")
    public ResponseEntity<?> getQuestionsOfQuiz(@PathVariable("quizId") int quizId)
    {

        // return ResponseEntity.ok(this.quesServ.getQuestionsofQuiz(quizId));

        Quiz quiz = this.quizServ.getQuiz(quizId);

        Set<Question> questions = quiz.getQuestions();

        Set<Question> questionsnew = new HashSet<>();

        List<Question> questionslist = new ArrayList<>(questions);

        questionslist.forEach((q)->{
            q.setAnswer("");				// we have here empty the answer
        });								// and this will send blank to user client
        // so we dont need to use @JsonIgnore

        Collections.shuffle(questionslist);

        Set<Question> questionsset = new HashSet<>(questionslist);


        Iterator<Question> itr = questionsset.iterator();
        int i = 0;
        while(itr.hasNext())
        {
            questionsnew.add(itr.next());
            i = i+1;
            if(i == quiz.getNumofquestions())
                break;
        }

        return ResponseEntity.ok(questionsnew);
    }


    //========= get Questions by quiz (all questions of specific quiz) ===============================================================================
    @GetMapping("/all/quiz/{quizId}")
    public ResponseEntity<?> getAllQuestionsOfQuiz(@PathVariable("quizId") int quizId)
    {

        Quiz quiz = this.quizServ.getQuiz(quizId);

        Set<Question> questions = quiz.getQuestions();

        return ResponseEntity.ok(questions);
    }

    //===========  get single Question by quesid =========================================================================================
    @GetMapping("/quesid/{quesId}")
    public ResponseEntity<?> getQuestion(@PathVariable("quesId") int quesId)
    {
        return ResponseEntity.ok(this.quesServ.getQuestion(quesId));
    }

    //=========== delete Question ====================================================================================================
    @DeleteMapping("/delete/{quesId}")
    public void delete(@PathVariable("quesId") int quesId) throws Exception
    {
        this.quesServ.deleteQuestion(quesId);
    }

    //============ get all Questions ===========================================================================================
    @GetMapping("/all")
    public ResponseEntity<?> getAllQuestions()
    {
        return ResponseEntity.ok(this.quesServ.getQuestions());
    }



}

