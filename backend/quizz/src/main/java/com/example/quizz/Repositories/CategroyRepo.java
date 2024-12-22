package com.example.quizz.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.quizz.Model.Category;

public interface CategroyRepo extends JpaRepository<Category, Integer>{
}
