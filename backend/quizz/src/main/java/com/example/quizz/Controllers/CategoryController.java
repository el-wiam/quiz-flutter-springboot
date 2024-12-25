package com.example.quizz.Controllers;

import com.example.quizz.Services.CategoryService;
import com.example.quizz.models.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/category")
@CrossOrigin(origins = "*")
public class CategoryController {

    @Autowired
    private CategoryService catServ;

    //======= add category ==========================================================================
    @PostMapping("/create")
    public ResponseEntity<?> addCategory(@RequestBody Category category)
    {
        Category cat = this.catServ.addCategory(category);

        return ResponseEntity.ok(cat);

    }


    //========= get single category ============================================================================
    @GetMapping("/catid/{catId}")
    public Category getCategory(@PathVariable("catId") int catId )
    {
        return this.catServ.getCategory(catId);
    }

//====== get all categories ==================================================================================

    @GetMapping("/all")
    public ResponseEntity<?> getCategories()
    {
        return ResponseEntity.ok(this.catServ.getCategories());
    }

//======== update category =======================================================================

    @PutMapping("/update")
    public Category updateCategory(@RequestBody Category category)
    {
        return this.catServ.updateCategory(category);
    }

//========= delete category =======================================================================

    @DeleteMapping("/delete/{catId}")
    public void deleteCategory(@PathVariable int catId)
    {
        this.catServ.deleteCategory(catId);
    }

//===============================================================================================


}

