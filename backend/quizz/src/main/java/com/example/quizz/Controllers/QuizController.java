package com.example.quizz.Controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Set;


import jakarta.servlet.ServletContext;

import com.example.quizz.Services.CategoryService;
import com.example.quizz.Services.QuizService;
import com.example.quizz.models.Quiz;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/quiz")
@CrossOrigin(origins="*")
public class QuizController {

    @Autowired
    private ServletContext context;

    @Autowired
    private QuizService quizServ;

    @Autowired
    private CategoryService catServ;

    @PostMapping("/create")
    public ResponseEntity<?> add(@RequestParam("title") String title,
                                 @RequestParam("description") String description,
                                 @RequestParam("maxmarks") String maxmarks,
                                 @RequestParam("numofquestions") String numofquestions,
                                 @RequestParam(name="active",defaultValue = "false") String active,
                                 @RequestParam("catid") String catid,
                                 @RequestParam(name="imagefile",required=false) MultipartFile file) throws Exception {

        Quiz quiz = new Quiz();

        String title2= title.substring(1,title.length()-1);
        String title3 = title2.replaceAll("\\\\", "");

        String description2 = description.substring(1,description.length()-1);
        String description3 = description2.replaceAll("\\\\","");

        quiz.setTitle(title3);
        quiz.setDescription(description3);

        quiz.setMaxmarks(Integer.parseInt(maxmarks));

        if(active.equals("true"))
            quiz.setActive(true);
        if(active.equals("false"))
            quiz.setActive(false);

        quiz.setNumofquestions(Integer.parseInt(numofquestions));

        quiz.setCategory(this.catServ.getCategory(Integer.parseInt(catid)));

        ArrayList <String> ext=new ArrayList<>();
        ext.add(".jpg");ext.add(".bmp");ext.add(".jpeg");ext.add(".png");ext.add(".webp");

        try {
            if(file == null || file.isEmpty()) {
                System.out.println("File is empty");
                quiz.setImage("Quiz.png");
            } else {
                String imageName = file.getOriginalFilename();
                String fileExtension = imageName.substring(imageName.lastIndexOf("."));

                if(!ext.contains(fileExtension)) {
                    throw new IllegalArgumentException("Unsupported format, please upload image files with Extensions (jpg, jpeg, png, bmp, webp) only.");
                }

                String newImageName = quiz.getTitle().replaceAll("[^a-zA-Z0-9]","");
                String newImgName = newImageName.concat(fileExtension);
                quiz.setImage(newImgName);

                String path="src/main/resources/static/image";
                String filePath = path+File.separator+newImgName;

                File f = new File(path);
                if(!f.exists()) {
                    f.mkdir();
                }

                Files.copy(file.getInputStream(), Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("Quiz image uploaded successfully");
            }

        } catch(Exception e) {
            throw new IllegalStateException("Error occurred: " + e.getMessage(), e);
        }
        return ResponseEntity.ok(this.quizServ.addQuiz(quiz));
    }

    @PutMapping("/update")
    public ResponseEntity<?> update(@RequestParam("quizid") String quizid,
                                    @RequestParam("title") String title,
                                    @RequestParam("description") String description,
                                    @RequestParam("maxmarks") String maxmarks,
                                    @RequestParam("numofquestions") String numofquestions,
                                    @RequestParam(name ="active" ,required=false) boolean active,
                                    @RequestParam("catid") String catid,
                                    @RequestParam(name="imagefile",required=false) MultipartFile file) throws Exception {

        Quiz quiz = new Quiz();

        quiz.setQuizid(Integer.parseInt(quizid));

        String title2= title.substring(1,title.length()-1);
        String title3 = title2.replaceAll("\\\\", "");

        String description2 = description.substring(1,description.length()-1);
        String description3 = description2.replaceAll("\\\\","");

        quiz.setTitle(title3);
        quiz.setDescription(description3);

        quiz.setMaxmarks(Integer.parseInt(maxmarks));

        quiz.setActive(active);

        quiz.setNumofquestions(Integer.parseInt(numofquestions));

        quiz.setCategory(this.catServ.getCategory(Integer.parseInt(catid)));

        Quiz oldQuiz = this.quizServ.getQuiz(quiz.getQuizid());

        ArrayList <String> ext=new ArrayList<>();
        ext.add(".jpg");ext.add(".bmp");ext.add(".jpeg");ext.add(".png");ext.add(".webp");

        try {
            if(file == null || file.isEmpty()) {
                quiz.setImage(oldQuiz.getImage());
            } else {
                String path="src/main/resources/static/image";

                if(!oldQuiz.getImage().equals("Quiz.png")) {
                    try {
                        String oldFilePath = path+File.separator+oldQuiz.getImage();
                        Files.delete(Paths.get(oldFilePath));
                    } catch(Exception e) {
                        System.out.println("Failed to delete old image: " + e.getMessage());
                    }
                }

                String imageName = file.getOriginalFilename();
                String fileExtension = imageName.substring(imageName.lastIndexOf("."));

                if(!ext.contains(fileExtension)) {
                    throw new IllegalArgumentException("Unsupported format, please upload image files with Extensions (jpg, jpeg, png, bmp, webp) only.");
                }

                String newImageName = quiz.getTitle().replaceAll("[^a-zA-Z0-9]","");
                String newImgName = newImageName.concat(fileExtension);
                quiz.setImage(newImgName);

                String filePath = path+File.separator+newImgName;

                File f = new File(path);
                if(!f.exists()) {
                    f.mkdir();
                }

                Files.copy(file.getInputStream(), Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
            }

        } catch(Exception e) {
            throw new IllegalStateException("Error occurred: " + e.getMessage(), e);
        }

        return ResponseEntity.ok(this.quizServ.addQuiz(quiz));
    }

    @GetMapping("/all")
    public ResponseEntity<Set<Quiz>> getQuizzes() throws IOException {
        String filePath = "src/main/resources/static/image/";
        File fileFolder = new File(filePath);

        if(fileFolder != null) {
            for(Quiz q : this.quizServ.getQuizzes()) {
                File file = new File(filePath + q.getImage());
                if(file.exists()) {
                    try {
                        String extension = FilenameUtils.getExtension(q.getImage());
                        FileInputStream fileInputStream = new FileInputStream(file);
                        byte[] bytes = new byte[(int)file.length()];
                        fileInputStream.read(bytes);
                        String encodeBase64 = Base64.getEncoder().encodeToString(bytes);
                        q.setImagefile("data:image/" + extension + ";base64," + encodeBase64);
                        fileInputStream.close();
                    } catch(Exception e) {
                        throw new IllegalStateException("Error occurred: " + e.getMessage(), e);
                    }
                }
            }
        }
        return ResponseEntity.ok(this.quizServ.getQuizzes());
    }
    // Get quizzes by category
    @GetMapping("/category/{categoryId}")
    public ResponseEntity<Set<Quiz>> getQuizzesOfCategory(@PathVariable int categoryId) {
        Set<Quiz> quizzes = this.quizServ.getQuizzesOfCategory(categoryId);
        return ResponseEntity.ok(quizzes);
    }

    // Get active quizzes
    @GetMapping("/active")
    public ResponseEntity<Set<Quiz>> getActiveQuizzes(@RequestParam Boolean active) {
        Set<Quiz> activeQuizzes = this.quizServ.getActiveQuizzes(active);
        return ResponseEntity.ok(activeQuizzes);
    }

    // Get active quizzes by category
    @GetMapping("/category/{categoryId}/active")
    public ResponseEntity<Set<Quiz>> getActiveQuizzesOfCategory(
            @PathVariable int categoryId,
            @RequestParam Boolean active) {
        Set<Quiz> activeQuizzes = this.quizServ.getActiveQuizzesOfCategory(categoryId, active);
        return ResponseEntity.ok(activeQuizzes);
    }

}
