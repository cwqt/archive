import { Component, OnInit, Output, Input, EventEmitter } from '@angular/core';
import { Plant } from "../../models/Plant";
import { Sorts } from "../../models/Sorts";

@Component({
  selector: 'app-plant-filter',
  templateUrl: './plant-filter.component.html',
  styleUrls: ['./plant-filter.component.sass']
})
export class PlantFilterComponent implements OnInit {
  @Input() plants: Plant[];
  @Output() sorter = new EventEmitter<number>();
  
  menuIsOpen = false;
  current_sort = Sorts.creation_newest;
  sorts = [
    ["Creation date (newest)", Sorts.creation_newest],
    ["Creation date (oldest)", Sorts.creation_oldest]
  ]
  
  constructor() { }

  ngOnInit(): void {}

  ngOnChanges(changes):void {
    this.useFilter(this.current_sort);
  }

  toggleOpen() {
    this.menuIsOpen = !this.menuIsOpen
  }

  closeMenu() {
    if (this.menuIsOpen) { this.menuIsOpen = false }
  }

  useFilter(filter_type:number) {
    this.current_sort = filter_type;
    this.sorter.emit(filter_type)
  }
}
