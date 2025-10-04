import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Task } from './task.model';
import { environment } from '../environments/environment';

/**
 * Service pour interagir avec l'API backend
 */
@Injectable({
  providedIn: 'root'
})
export class TaskService {
  private apiUrl = `${environment.apiUrl}/api/tasks`;

  constructor(private http: HttpClient) {}

  /**
   * Récupérer toutes les tâches
   */
  getAllTasks(): Observable<Task[]> {
    return this.http.get<Task[]>(this.apiUrl);
  }

  /**
   * Récupérer une tâche par ID
   */
  getTaskById(id: number): Observable<Task> {
    return this.http.get<Task>(`${this.apiUrl}/${id}`);
  }

  /**
   * Créer une nouvelle tâche
   */
  createTask(task: Task): Observable<Task> {
    return this.http.post<Task>(this.apiUrl, task);
  }

  /**
   * Mettre à jour une tâche
   */
  updateTask(id: number, task: Task): Observable<Task> {
    return this.http.put<Task>(`${this.apiUrl}/${id}`, task);
  }

  /**
   * Supprimer une tâche
   */
  deleteTask(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

  /**
   * Rechercher des tâches par titre
   */
  searchTasks(query: string): Observable<Task[]> {
    return this.http.get<Task[]>(`${this.apiUrl}/search?q=${query}`);
  }
}
