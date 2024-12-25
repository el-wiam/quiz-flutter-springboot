package com.example.quizz.Repositories;

import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.quizz.models.Quiz;
import com.example.quizz.models.Category;


public interface QuizRepo extends JpaRepository<Quiz, Integer>{

    public Set<Quiz> findBycategory(Category category);
    // Get quizzes whose active status are true
    public Set<Quiz> findByActive(Boolean active);
    // get quizzes by category whose active status are true
    public Set<Quiz> findByCategoryAndActive(Category c,Boolean active);

}

