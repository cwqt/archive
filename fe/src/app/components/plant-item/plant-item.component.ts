import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { Plant } from "../../models/Plant";

@Component({
  selector: 'app-plant-item',
  templateUrl: './plant-item.component.html',
  styleUrls: ['./plant-item.component.sass']
})
export class PlantItemComponent implements OnInit {
  @Input() plant:Plant;
  @Output() deletePlant = new EventEmitter<string>();

  constructor() { }

  ngOnInit(): void {
  }

  deleteSelf() {
    this.deletePlant.emit(this.plant._id)
  }
}
