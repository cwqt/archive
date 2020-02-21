import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, of } from 'rxjs';

import { Plant } from "../models/Plant";

@Injectable({
  providedIn: 'root'
})
export class PlantService {
  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type':  'application/json',
    })
  };

  constructor(private http: HttpClient) { }

  createPlant = (body):Observable<Plant> => {
    console.log(body)
    return this.http.post<Plant>("http://localhost:3000/plants", body, this.httpOptions)
  }

  deletePlant = (_id:string):Observable<any> => {
    return this.http.delete(`http://localhost:3000/plants/${_id}`);
  }

  getPlants = ():Observable<Plant[]> => {
    return this.http.get<Plant[]>("http://localhost:3000/plants");
  }

  getPlant = (_id:string):Observable<Plant> => {
    return this.http.get<Plant>(`http://localhost:3000/plants/${_id}`);
  }
}
