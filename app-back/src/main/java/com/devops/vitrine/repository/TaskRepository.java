package com.devops.vitrine.repository;

import com.devops.vitrine.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour l'entité Task
 * Interface JPA avec méthodes CRUD automatiques
 */
@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {

    /**
     * Trouver toutes les tâches complétées
     */
    List<Task> findByCompleted(boolean completed);

    /**
     * Rechercher des tâches par titre (contient)
     */
    List<Task> findByTitleContainingIgnoreCase(String title);
}
