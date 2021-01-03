import { Component, OnInit } from '@angular/core';

import { Plant } from "../../models/Plant";
import { PlantService } from "../../services/plant.service"
import { Sorts } from "../../models/Sorts";

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

  total_doc_count:number;
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
  
  removePlant(_id:string) {
    this.plantService.deletePlant(_id).subscribe(
      res => {
        this.plants = this.plants.filter(plant => plant._id !== _id);
        this.total_doc_count -= 1;
      },
      err => {
        this.err_message = "Couldn't remove plant"
      },
      () => {}
    )
  }

  getPlantPage(page:number, name?:string):void {
    this.loading = true;
    this.plantService.getPlants(page, name || this.name_filter).subscribe(
      res => {
        this.plants = res["data"];
        this.success = true;
        this.current_page = page;
        this.page_count = res["page_count"];
        this.total_doc_count = res["total_docs"]
      },
      err => {
        this.success = false;
      },
      () => { this.loading = false } 
    )
  }

  sortPlantsByParameter(filter_type:number) {
    console.log("sorting...")
    switch(filter_type) {
      case Sorts.creation_oldest:
        this.plants = this.plants.sort((a,b) => a.created_at - b.created_at)
        break;
      case Sorts.creation_newest:
        this.plants = this.plants.sort((a,b) => b.created_at - a.created_at)
        break;
    }
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
    this.total_doc_count += 1;
  }

  recieveGetPlantsFromSearch($event) {
    this.name_filter = $event;
    this.getPlantPage(1, $event)
  }
}
