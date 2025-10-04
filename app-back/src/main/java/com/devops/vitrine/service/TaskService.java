package com.devops.vitrine.service;

import com.devops.vitrine.model.Task;
import com.devops.vitrine.repository.TaskRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service métier pour la gestion des tâches
 */
@Service
@RequiredArgsConstructor
public class TaskService {

    private final TaskRepository taskRepository;

    /**
     * Récupérer toutes les tâches
     */
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    /**
     * Récupérer une tâche par ID
     */
    public Optional<Task> getTaskById(Long id) {
        return taskRepository.findById(id);
    }

    /**
     * Créer une nouvelle tâche
     */
    @Transactional
    public Task createTask(Task task) {
        return taskRepository.save(task);
    }

    /**
     * Mettre à jour une tâche existante
     */
    @Transactional
    public Task updateTask(Long id, Task taskDetails) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Tâche non trouvée avec l'id: " + id));

        task.setTitle(taskDetails.getTitle());
        task.setDescription(taskDetails.getDescription());
        task.setCompleted(taskDetails.isCompleted());

        return taskRepository.save(task);
    }

    /**
     * Supprimer une tâche
     */
    @Transactional
    public void deleteTask(Long id) {
        taskRepository.deleteById(id);
    }

    /**
     * Rechercher des tâches par statut
     */
    public List<Task> getTasksByStatus(boolean completed) {
        return taskRepository.findByCompleted(completed);
    }

    /**
     * Rechercher des tâches par titre
     */
    public List<Task> searchTasksByTitle(String title) {
        return taskRepository.findByTitleContainingIgnoreCase(title);
    }
}
