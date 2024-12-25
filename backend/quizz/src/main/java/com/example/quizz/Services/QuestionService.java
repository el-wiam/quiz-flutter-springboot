package com.example.quizz.Services;

import com.example.quizz.models.Question;

import java.util.Set;

public interface QuestionService {

    public Question addQuestion(Question question);

    public Question updateQuestion(Question question);

    public Set<Question> getQuestions();

    public Question getQuestion(int quesId);

    public void deleteQuestion(int quesId);

    public Set<Question> getQuestionsofQuiz(int quizId);

}
