import { Component, OnInit, Output, Input, EventEmitter } from '@angular/core';
import { Plant } from "../../models/Plant";
import { Sorts } from "../../models/Sorts";

@Component({
  selector: 'app-plant-filter',
  templateUrl: './plant-filter.component.html',
  styleUrls: ['./plant-filter.component.sass']
})
export class PlantFilterComponent implements OnInit {
  filter_parameter:string;
  open = false;
  Sorts = Sorts;
  current_sort:number;

  sorts = [
    ["Creation date (newest)", Sorts.creation_newest],
    ["Creation date (oldest)", Sorts.creation_oldest]
  ]

  @Output() sorter = new EventEmitter<number>();

  constructor() { }

  ngOnInit(): void {
  }

  toggleOpen() {
    this.open = !this.open
  }

  closeMenu() {
    if (this.open) { this.open = false }
  }

  useFilter(filter_type:number) {
    this.current_sort = filter_type;
    this.sorter.emit(filter_type)
  }
}
