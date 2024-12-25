package com.example.quizz.Services;

import com.example.quizz.models.User;

import java.util.List;

public interface UserService {
    // create user
    public User createUser(User user) throws Exception;

    // get user by username
    public User getUser(String username) throws Exception;

    // get user by uid
    public User getUserByUid(int uid) throws Exception;

    // delete user by uid
    public void deleteUser(int uid) throws Exception;

    // update user
    public User updateUser(User user) throws Exception;

    // get all users
    public List<User> getAllUsers();
}