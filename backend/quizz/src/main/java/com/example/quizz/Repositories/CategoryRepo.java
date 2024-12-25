package com.example.quizz.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.quizz.models.Category;

public interface CategoryRepo extends JpaRepository<Category, Integer>{
}
