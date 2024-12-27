package com.example.quizz.Services.Impl;

import java.util.List;
import java.util.Optional;

import com.example.quizz.Repositories.UserRepo;
import com.example.quizz.Services.UserService;
import com.example.quizz.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepo userRepo;

    //================ create user ======================================================================================================================
    @Override
    public User createUser(User user) throws Exception {

        User local = this.userRepo.findByUsername(user.getUsername());

        if (local != null) {
            System.out.println("\n=================================================================================================================\n"
                    + "         Message: User already present with username: " + user.getUsername() + " , try using different username...  \n"
                    + "==========================================================================================================================");

            throw new Exception("Exception: User already present with username: " + user.getUsername() + " , try using different username...");
        } else {
            // create user
            local = this.userRepo.save(user);
        }

        return local;
    }

    //================ get user by uid ======================================================================================================================

    @Override
    public User getUserByUid(int uid) throws Exception {

        Optional<User> user = this.userRepo.findById(uid);
        if (user.isPresent()) {
            return user.get();
        } else {
            System.out.println("\n====================================================================\n"
                    + "         Message: There is no User with uid: " + uid + " exists... \n"
                    + "====================================================================");

            throw new Exception("Exception: There is no User with uid: " + uid + " exists...");
        }
    }

    //================ get user by username ======================================================================================================================

    @Override
    public User getUser(String username) throws Exception {

        if (this.userRepo.findByUsername(username) == null) {
            System.out.println("\n====================================================================\n"
                    + "         Message: There is no User with username: " + username + " exists...  \n"
                    + "====================================================================");

            throw new Exception("Exception: There is no User with username: " + username + " exists...");
        }
        return this.userRepo.findByUsername(username);
    }

    //================ delete user by uid ======================================================================================================================

    @Override
    public void deleteUser(int uid) throws Exception {

        Optional<User> user = this.userRepo.findById(uid);
        if (user.isEmpty()) {
            System.out.println("\n====================================================================\n"
                    + "         Message: There is no User with uid: " + uid + " exists...  \n"
                    + "====================================================================");

            throw new Exception("Exception: There is no User with uid: " + uid + " exists...");
        }

        this.userRepo.deleteById(uid);
    }

    //================ update user ======================================================================================================================

    @Override
    public User updateUser(User user) throws Exception {

        User local;

        if (this.userRepo.getByUnameAndNouid(user.getUsername(), user.getUid()) != null) {
            System.out.println("\n=======================================================================================================================\n"
                    + "         Message: User already present with username: " + user.getUsername() + " , try using different username !! \n"
                    + "=================================================================================================================================");

            throw new Exception("Exception: User already present with username: " + user.getUsername() + " , try using different username !!");
        } else {
            // update user
            local = this.userRepo.save(user);
        }
        return local;
    }

    //========== get all users ============================================================================================================================

    @Override
    public List<User> getAllUsers() {

        return this.userRepo.findAll();
    }
    //========== user login ============================================================================================================================
    @Override
    public User login(String username, String password) throws Exception {
        User user = this.userRepo.findByUsername(username);
        if (user == null) {
            throw new Exception("User not found with username: " + username);
        }
        if (!user.getPassword().equals(password)) {
            throw new Exception("Invalid password for username: " + username);
        }
        return user;
    }
}
