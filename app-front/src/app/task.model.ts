/**
 * Modèle de données pour une tâche
 */
export interface Task {
  id?: number;
  title: string;
  description?: string;
  completed: boolean;
  createdAt?: Date;
  updatedAt?: Date;
}
