import { Component, OnInit, EventEmitter, Output } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from "@angular/forms";

@Component({
  selector: 'app-plant-search',
  templateUrl: './plant-search.component.html',
  styleUrls: ['./plant-search.component.sass']
})
export class PlantSearchComponent implements OnInit {
  @Output() getPlantsFromSearch = new EventEmitter<string>();
  searchForm:FormGroup;
  loading:boolean = false;
  success:boolean = false;
  
  constructor(private fb:FormBuilder) { }

  ngOnInit(): void {
    this.searchForm = this.fb.group({
      name: ["", [ Validators.required ]],
    });
  }

  get name() { return this.searchForm.get("name") }

  submitHandler() {
    this.loading = true;
    console.log(this.searchForm.value);
    this.getPlantsFromSearch.emit(this.searchForm.value["name"]);
  }
}
