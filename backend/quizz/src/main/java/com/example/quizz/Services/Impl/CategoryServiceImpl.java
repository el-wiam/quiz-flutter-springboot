package com.example.quizz.Services.Impl;

import com.example.quizz.Services.CategoryService;
import com.example.quizz.models.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.quizz.Repositories.CategoryRepo;

import java.util.LinkedHashSet;
import java.util.Set;

@Service
public class CategoryServiceImpl implements CategoryService {


    @Autowired
    private CategoryRepo catRepo;

    @Override
    public Category addCategory(Category category) {

        return this.catRepo.save(category);
    }

    @Override
    public Category updateCategory(Category category) {

        return this.catRepo.save(category);
    }

    @Override
    public Set<Category> getCategories() {

        return  new LinkedHashSet<>(this.catRepo.findAll());
    }

    @Override
    public Category getCategory(int catid) {

//		Optional<Category> category = this.catRepo.findById(catid);
//		if(category.isPresent())
//		{
//			return category.get();
//		}
//		return null;

        //	return this.catRepo.getById(catid);

        return this.catRepo.findById(catid).get();
    }

    @Override
    public void deleteCategory(int catid) {

        this.catRepo.deleteById(catid);


    }
}

