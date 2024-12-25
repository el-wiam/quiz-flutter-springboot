package com.example.quizz.models;

import java.util.LinkedHashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "quiz_category") // Updated table name to avoid conflicts
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int catid;

    private String title;

    private String description;

    @OneToMany(mappedBy = "category", orphanRemoval = true, cascade = CascadeType.REMOVE, fetch = FetchType.LAZY)
    @JsonIgnore
    private Set<Quiz> quizzes = new LinkedHashSet<>();

    public Category(String title, String description) {
        this.title = title;
        this.description = description;
    }

    public void addQuiz(Quiz quiz) {
        this.quizzes.add(quiz);
        quiz.setCategory(this);
    }

    public void removeQuiz(Quiz quiz) {
        this.quizzes.remove(quiz);
        quiz.setCategory(null);
    }
}
