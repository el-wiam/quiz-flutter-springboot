package com.example.quizz.Controllers;

import java.util.List;

import com.example.quizz.Services.UserService;
import com.example.quizz.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
@CrossOrigin(origins = "*")
public class UserController {
    @Autowired
    private UserService userServ;

    //================ create user ======================================================================================================================
    @PostMapping("/create")
    public User createUser(@RequestBody User user) throws Exception {
        user.setProfile("profile.png");
        return this.userServ.createUser(user);
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
}
