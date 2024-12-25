package com.example.quizz.Repositories;

import java.util.List;

import com.example.quizz.models.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;



public interface ResultRepo extends JpaRepository<Result, Integer>{


    @Query(value ="Select * from Result where resultid=( select max(resultid) from Result)",nativeQuery  = true)
    Result findCurrentResult();

    public List<Result> findByUid(int uid);

    public void deleteByUid(int uid);

}