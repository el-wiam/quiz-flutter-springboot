package com.example.quizz.Services;

import com.example.quizz.models.Result;

import java.util.List;

public interface ResultService {
    public Result addResult(Result result) ;

    public List<Result> getResults();

    public Result getResult(int resultid);

    public Result getCurrentResult() ;

    public void deleteResult(int resultid);

    public void deleteAllResult();

    public List<Result> getResultsofUser(int uid) ;

    public void deleteAllResultOfUser(int uid);
}
