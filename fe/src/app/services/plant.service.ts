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
    return this.http.post<Plant>("/api/plants", body, this.httpOptions)
  }

  deletePlant = (_id:string):Observable<any> => {
    return this.http.delete(`/api/plants/${_id}`);
  }

  getPlants = (page=1, name?:string):Observable<any> => {
    var endpoint = `?page=${page}&per_page=5`
    if (name) { endpoint += `&name=${name}` }

    return this.http.get(`/api/plants${endpoint}`);
  }

  getPlant = (_id:string):Observable<Plant> => {
    return this.http.get<Plant>(`/api/plants/${_id}`);
  }
}
