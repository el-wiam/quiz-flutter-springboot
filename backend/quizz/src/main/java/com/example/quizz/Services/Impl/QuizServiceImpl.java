package com.example.quizz.Services.Impl;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;



import com.example.quizz.Repositories.QuizRepo;
import com.example.quizz.Services.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.quizz.models.Category;
import com.example.quizz.models.Quiz;
import com.example.quizz.Repositories.CategoryRepo;

@Service
public class QuizServiceImpl implements QuizService {

    @Autowired
    private QuizRepo quizRepo;

    @Autowired
    private CategoryRepo catRepo;

    //========= create quiz ==========================================
    @Override
    public Quiz addQuiz(Quiz quiz) {
        return this.quizRepo.save(quiz);
    }

    //========== update quiz ====================================================
    @Override
    public Quiz updateQuiz(Quiz quiz) {
        return this.quizRepo.save(quiz);
    }

    //============ get all quizzes ===============================================
    @Override
    public Set<Quiz> getQuizzes() {
        return new HashSet<>(this.quizRepo.findAll());
    }

    //========== get single quiz ==================================================
    @Override
    public Quiz getQuiz(int quizid) {
        return this.quizRepo.findById(quizid).orElse(null);
    }

    //========== delete quiz =====================================================
    @Override
    public void deleteQuiz(int quizid) throws Exception {
        Optional<Quiz> quiz = this.quizRepo.findById(quizid);
        if (quiz.isEmpty()) {
            System.out.println("\n=================================================================================================================\n"
                    + "          Message: There is no Quiz with quizId: " + quizid + " exists...  \n"
                    + "==========================================================================================================================");

            throw new Exception("Message: There is no Quiz with quizId: " + quizid + " exists...");
        }
        this.quizRepo.deleteById(quizid);
    }

    //========== get quizzes by category ======================================================
    @Override
    public Set<Quiz> getQuizzesOfCategory(int categoryId) {
        Category category = this.catRepo.getById(categoryId);
        return this.quizRepo.findBycategory(category);
    }

    //========== get active quizzes=============================================================================
    @Override
    public Set<Quiz> getActiveQuizzes(Boolean active) {
        return new HashSet<>(this.quizRepo.findByActive(active));
    }

    //=========== get active quizzes by category ============================================================================
    @Override
    public Set<Quiz> getActiveQuizzesOfCategory(int categoryId, Boolean active) {
        Category category = this.catRepo.getById(categoryId);
        return this.quizRepo.findByCategoryAndActive(category, active);
    }

    //=======================================================================================

}
