import { bootstrapApplication } from '@angular/platform-browser';
import { provideHttpClient } from '@angular/common/http';
import { AppComponent } from './app/app.component';

/**
 * Point d'entrée de l'application Angular
 */
bootstrapApplication(AppComponent, {
  providers: [
    provideHttpClient()
  ]
}).catch(err => console.error(err));
