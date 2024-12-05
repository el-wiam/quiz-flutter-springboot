package com.example.quizz.Repositories;


import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.quizz.models.Question;
import com.example.quizz.models.Quiz;

public interface QuestionRepo extends JpaRepository<Question, Integer> {

    Set<Question> findByQuiz(Quiz quiz);
}
