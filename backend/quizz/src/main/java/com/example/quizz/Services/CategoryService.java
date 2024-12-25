package com.example.quizz.Services;

import com.example.quizz.models.Category;

import java.util.Set;

public interface CategoryService {
    public Category addCategory(Category category);

    public Category updateCategory(Category category);

    public Set<Category> getCategories();

    public Category getCategory(int catid);

    public void deleteCategory(int catid);
}
