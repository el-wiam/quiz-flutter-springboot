package com.example.quizz.models;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.*;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@JsonAutoDetect(fieldVisibility = Visibility.ANY)
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int quizid;

    private String title;

    //  @Column(length=5000)
    private String description;

    private int maxmarks;

    private int numofquestions;

    private String image;

    private boolean active=false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JsonIgnore
    private Category category;

    @OneToMany(mappedBy = "quiz",fetch = FetchType.LAZY,orphanRemoval = true,cascade = CascadeType.REMOVE)
    @JsonIgnore
    private Set<Question> questions = new HashSet<>();

    @Transient
    private String imagefile;

}
