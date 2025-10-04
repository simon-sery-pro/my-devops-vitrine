package com.devops.vitrine.controller;

import com.devops.vitrine.model.Task;
import com.devops.vitrine.service.TaskService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Contrôleur REST pour la gestion des tâches
 * API CRUD complète
 */
@RestController
@RequestMapping("/api/tasks")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // À sécuriser en production
public class TaskController {

    private final TaskService taskService;

    /**
     * GET /api/tasks - Récupérer toutes les tâches
     */
    @GetMapping
    public ResponseEntity<List<Task>> getAllTasks() {
        return ResponseEntity.ok(taskService.getAllTasks());
    }

    /**
     * GET /api/tasks/{id} - Récupérer une tâche par ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<Task> getTaskById(@PathVariable Long id) {
        return taskService.getTaskById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * POST /api/tasks - Créer une nouvelle tâche
     */
    @PostMapping
    public ResponseEntity<Task> createTask(@Valid @RequestBody Task task) {
        Task createdTask = taskService.createTask(task);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdTask);
    }

    /**
     * PUT /api/tasks/{id} - Mettre à jour une tâche
     */
    @PutMapping("/{id}")
    public ResponseEntity<Task> updateTask(@PathVariable Long id, @Valid @RequestBody Task task) {
        try {
            Task updatedTask = taskService.updateTask(id, task);
            return ResponseEntity.ok(updatedTask);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * DELETE /api/tasks/{id} - Supprimer une tâche
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        taskService.deleteTask(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * GET /api/tasks/status/{completed} - Filtrer par statut
     */
    @GetMapping("/status/{completed}")
    public ResponseEntity<List<Task>> getTasksByStatus(@PathVariable boolean completed) {
        return ResponseEntity.ok(taskService.getTasksByStatus(completed));
    }

    /**
     * GET /api/tasks/search?q=titre - Rechercher par titre
     */
    @GetMapping("/search")
    public ResponseEntity<List<Task>> searchTasks(@RequestParam String q) {
        return ResponseEntity.ok(taskService.searchTasksByTitle(q));
    }
}
