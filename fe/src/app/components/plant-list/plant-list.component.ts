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

  current_page:number;
  page_count:number;
  name_filter:string;

  showAddPlant:boolean = false;
  showApiKeys:boolean = false;

  constructor(
    private plantService: PlantService
  ) { }

  ngOnInit(): void {
    this.getPlantPage(1);
  }
  
  getPlantPage(page:number, name?:string):void {
    this.loading = true;
    this.plantService.getPlants(page, name || this.name_filter).subscribe(
      res => {
        this.plants = res["data"];
        this.success = true;
        this.current_page = page;
        this.page_count = res["page_count"];
      },
      err => {
        this.success = false;
      },
      () => { this.loading = false } 
    )
  }

  toggleAddPlantForm() {
    this.showAddPlant = !this.showAddPlant;
    this.showApiKeys = false;
  }
  toggleApiKeysForm() {
    this.showApiKeys = !this.showApiKeys;
    this.showAddPlant = false;
  }
  
  receiveNewPlant($event) {
    this.plants = [...this.plants, $event ]
  }

  recieveGetPlantsFromSearch($event) {
    this.name_filter = $event
    this.getPlantPage(1, $event)
  }
}
