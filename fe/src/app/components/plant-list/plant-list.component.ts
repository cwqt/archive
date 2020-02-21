import { Component, OnInit } from '@angular/core';

import { Plant } from "../../models/Plant";
import { PlantService } from "../../services/plant.service"

@Component({
  selector: 'app-plant-list',
  templateUrl: './plant-list.component.html',
  styleUrls: ['./plant-list.component.sass']
})
export class PlantListComponent implements OnInit {
  plants:Plant[] = [];
  err_message:string;
  loading:boolean = false;
  success:boolean;

  showAddPlant:boolean = true;
  showApiKeys:boolean = false;

  constructor(
    private plantService: PlantService
  ) { }

  ngOnInit(): void {
    this.loading = true;
    this.plantService.getPlants()
      .subscribe(
        res => {
          this.plants = res;
          this.success = true;
          this.loading = false;
          this.err_message = "";
        },
        err => {
          this.loading = false;
          this.success = false;
          this.err_message = err.statusText;
        }
      );
  }

  toggleAddPlantForm() { this.showAddPlant = !this.showAddPlant; }
  toggleApiKeysForm() { this.showApiKeys = !this.showApiKeys; }
  
  receiveNewPlant($event) {
    this.plants = [...this.plants, $event ]
  }
}
