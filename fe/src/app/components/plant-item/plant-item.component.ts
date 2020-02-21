import { Component, OnInit, Input } from '@angular/core';
import { Plant } from "../../models/Plant";

@Component({
  selector: 'app-plant-item',
  templateUrl: './plant-item.component.html',
  styleUrls: ['./plant-item.component.sass']
})
export class PlantItemComponent implements OnInit {
  @Input() plant:Plant;

  constructor() { }

  ngOnInit(): void {
  }

}
