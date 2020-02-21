import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from "@angular/forms";
import { PlantService } from "../../services/plant.service";
import { Plant } from 'src/app/models/Plant';

@Component({
  selector: 'app-add-plant',
  templateUrl: './add-plant.component.html',
  styleUrls: ['./add-plant.component.sass']
})
export class AddPlantComponent implements OnInit {
  @Output() newPlantEvent = new EventEmitter<Plant>();
  plantForm:FormGroup;
  loading:boolean = false;
  success:boolean = false;
  
  constructor(private plantService:PlantService, private fb:FormBuilder) { }

  ngOnInit(): void {
    this.plantForm = this.fb.group({
      name: ["", [
        Validators.required
      ]],
      image: ["", [
        Validators.required,
      ]]
    });
    // this.plantForm.valueChanges.subscribe(console.log)
  }

  get name() { return this.plantForm.get("name") }
  get image() { return this.plantForm.get("image") }

  submitHandler() {
    this.loading = true;
    this.plantService.createPlant(this.plantForm.value).subscribe(
      res => {
        this.success = true;
        this.newPlantEvent.emit(res);
      },
      err => {
        this.success = false;
      },
      () => { this.loading = false; }
    )
  }
}
