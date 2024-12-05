package com.example.quizz.Repositories;

import com.example.quizz.models.UserQNA;
import org.springframework.data.jpa.repository.JpaRepository;

import com.model.outcome.Userqna;

public interface UserQnARepo extends JpaRepository<UserQNA, Integer>{

}
