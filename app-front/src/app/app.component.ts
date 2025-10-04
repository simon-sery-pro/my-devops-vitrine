import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TaskService } from './task.service';
import { Task } from './task.model';

/**
 * Composant principal de l'application
 * Interface CRUD pour la gestion des tâches
 */
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'DevOps Vitrine - Task Manager';
  tasks: Task[] = [];
  newTask: Task = { title: '', description: '', completed: false };
  editingTask: Task | null = null;

  constructor(private taskService: TaskService) {}

  ngOnInit(): void {
    this.loadTasks();
  }

  /**
   * Charger toutes les tâches depuis l'API
   */
  loadTasks(): void {
    this.taskService.getAllTasks().subscribe({
      next: (tasks) => this.tasks = tasks,
      error: (error) => console.error('Erreur lors du chargement des tâches:', error)
    });
  }

  /**
   * Créer une nouvelle tâche
   */
  createTask(): void {
    if (!this.newTask.title.trim()) {
      return;
    }

    this.taskService.createTask(this.newTask).subscribe({
      next: (task) => {
        this.tasks.push(task);
        this.newTask = { title: '', description: '', completed: false };
      },
      error: (error) => console.error('Erreur lors de la création:', error)
    });
  }

  /**
   * Mettre à jour une tâche existante
   */
  updateTask(task: Task): void {
    if (task.id) {
      this.taskService.updateTask(task.id, task).subscribe({
        next: () => {
          this.editingTask = null;
          this.loadTasks();
        },
        error: (error) => console.error('Erreur lors de la mise à jour:', error)
      });
    }
  }

  /**
   * Supprimer une tâche
   */
  deleteTask(id: number): void {
    this.taskService.deleteTask(id).subscribe({
      next: () => this.tasks = this.tasks.filter(t => t.id !== id),
      error: (error) => console.error('Erreur lors de la suppression:', error)
    });
  }

  /**
   * Toggle le statut completed d'une tâche
   */
  toggleComplete(task: Task): void {
    task.completed = !task.completed;
    this.updateTask(task);
  }

  /**
   * Démarrer l'édition d'une tâche
   */
  startEdit(task: Task): void {
    this.editingTask = { ...task };
  }

  /**
   * Annuler l'édition
   */
  cancelEdit(): void {
    this.editingTask = null;
  }

  /**
   * Sauvegarder l'édition
   */
  saveEdit(): void {
    if (this.editingTask) {
      this.updateTask(this.editingTask);
    }
  }
}
