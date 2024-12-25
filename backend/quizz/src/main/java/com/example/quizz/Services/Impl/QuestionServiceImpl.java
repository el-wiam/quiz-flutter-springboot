package com.example.quizz.Services.Impl;

import java.util.HashSet;
import java.util.Set;

import com.example.quizz.Services.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.quizz.models.Question;
import com.example.quizz.models.Quiz;
import com.example.quizz.Repositories.QuestionRepo;
import com.example.quizz.Repositories.QuizRepo;


@Service
public class QuestionServiceImpl implements QuestionService {

    @Autowired
    private QuestionRepo quesRepo;

    @Autowired
    private QuizRepo quizRepo;


    //======= create Question ==========================================================
    public Question addQuestion(Question question)
    {
        return this.quesRepo.save(question);
    }

    //======== update Question ===============================================================
    public Question updateQuestion(Question question)
    {
        return this.quesRepo.save(question);
    }

    //========= get all Questions ===========================================================
    public Set<Question> getQuestions()
    {
        return new HashSet<>(this.quesRepo.findAll());
    }

    //========== get single Question by quesid =================================================
    public Question getQuestion(int quesId) {

        return this.quesRepo.findById(quesId).get();
    }

    //========== get Questions by Quiz ===================================================
    public Set<Question> getQuestionsofQuiz(int quizId)
    {
        Quiz quiz = new Quiz();
        quiz = this.quizRepo.getById(quizId);
        Set<Question> questions = this.quesRepo.findByQuiz(quiz);

        return questions;
    }
    //========= delete Question ===============================================================
    @Override
    public void deleteQuestion(int quesId) {

        this.quesRepo.deleteById(quesId);

    }
//============================================================================================
}

