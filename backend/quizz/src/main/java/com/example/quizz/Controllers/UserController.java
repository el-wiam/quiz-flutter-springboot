package com.example.quizz.Controllers;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import com.example.quizz.Services.UserService;
import com.example.quizz.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/user")
@CrossOrigin(origins = "*")
public class UserController {
    @Autowired
    private UserService userServ;

    //================ create user ======================================================================================================================
    @PostMapping("/create")
    public User createUser(@RequestParam("username") String username,
                           @RequestParam("password") String password,
                           @RequestParam("firstname") String firstName,
                           @RequestParam("lastname") String lastName,
                           @RequestParam("email") String email,
                           @RequestParam("phone") String phone,
                           @RequestParam(value = "profile", required = false) MultipartFile profileImage) throws Exception {

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFirstname(firstName);
        user.setLastname(lastName);
        user.setEmail(email);
        user.setPhone(phone);

        // Handle profile image (if available)
        if (profileImage != null) {
            String profileImageName = saveProfileImage(profileImage); // Method to save the image and get the path
            user.setProfile(profileImageName);
        } else {
            user.setProfile("defaultProfile.png"); // Default profile image name
        }

        return userServ.createUser(user);
    }

    // Helper method to save the profile image
    private String saveProfileImage(MultipartFile file) throws IOException {
        // Save the file to a specific location and return the filename
        Path path = Paths.get("uploads/" + file.getOriginalFilename());
        Files.write(path, file.getBytes());
        return path.toString();
    }


    //========== get user by uid ======================================================================================================================
    @GetMapping("/uid/{uid}")
    public User getUser(@PathVariable("uid") int uid) throws Exception {
        return this.userServ.getUserByUid(uid);
    }

    //========== get user by username ======================================================================================================================
    @GetMapping("/username/{username}")
    public User getUser(@PathVariable("username") String username) throws Exception {
        return this.userServ.getUser(username);
    }

    //========== get all users ======================================================================================================================
    @GetMapping("/all")
    public List<User> getAllUsers() {
        return this.userServ.getAllUsers();
    }

    //=========== delete user by uid ======================================================================================================================
    @DeleteMapping("/delete/{uid}")
    public void deleteUser(@PathVariable("uid") int uid) throws Exception {
        this.userServ.deleteUser(uid);
    }

    //========= update user ======================================================================================================================
    @PutMapping("/update")
    public User updateUser(@RequestBody User user) throws Exception {
        return this.userServ.updateUser(user);
    }
    //========== user login ============================================================================================================================
    @PostMapping("/login")
    public User login(@RequestBody User user) throws Exception {
        return this.userServ.login(user.getUsername(), user.getPassword());
    }

}
