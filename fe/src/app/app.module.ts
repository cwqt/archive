import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ReactiveFormsModule } from "@angular/forms";

import { AppComponent } from './app.component';
import { PlantListComponent } from './components/plant-list/plant-list.component';
import { PageNotFoundComponent } from './components/page-not-found/page-not-found.component';
import { PlantItemComponent } from './components/plant-item/plant-item.component';
import { AddPlantComponent } from './components/add-plant/add-plant.component';
import { ApiKeysComponent } from './components/api-keys/api-keys.component';
import { ArraySortPipe } from './pipes/sort.pipe';
import { ReversePipeSort } from './pipes/reverse-sort.pipe';

@NgModule({
  declarations: [
    AppComponent,
    PlantListComponent,
    PageNotFoundComponent,
    PlantItemComponent,
    AddPlantComponent,
    ApiKeysComponent,
    ArraySortPipe,
    ReversePipeSort
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    HttpClientModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
