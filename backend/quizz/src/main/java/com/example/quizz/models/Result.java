package com.example.quizz.models;

import java.util.Date;
import java.util.List;
import java.util.Set;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.example.quizz.models.UserQNA;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Result {

    @Id
    @GeneratedValue(strategy =  GenerationType.AUTO)
    private int resultid;
    private int uid;
    private int quizid;
    private int numofquestions;
    private int correctanswers;
    private int marksgot;
    private int attempted;
    private String date;

    @Transient
    private String title;
    @Transient
    private String imagefile;

    @OneToMany(mappedBy ="result",fetch = FetchType.LAZY,cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<UserQNA> userqnas;

}

