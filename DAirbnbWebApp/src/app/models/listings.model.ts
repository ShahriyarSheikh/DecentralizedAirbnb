import { FormGroup, FormBuilder, Validators, FormControl } from '@angular/forms';
import { Injectable } from "@angular/core";

@Injectable()
export class Listings {

    listingOfRenter: FormGroup;

    constructor(private fb: FormBuilder) {

        this.listingOfRenter = fb.group({
            'destination': [null, Validators.compose([Validators.required])],
            'date_start': [null, Validators.compose([Validators.required])],
            'date_end': [null, Validators.compose([Validators.required])],
            'guests': [null, Validators.compose([Validators.required])],
            'bedrooms': [null, Validators.compose([Validators.required])],
            'beds': [null, Validators.compose([Validators.required])],
            'washrooms': [null, Validators.compose([Validators.required])],
            'price': [null, Validators.compose([Validators.required])],
            'rooms': [null, Validators.compose([Validators.required])],
            'facility': [null, Validators.compose([Validators.required])],
            'aments': [null, Validators.compose([Validators.required])],
            'rule': [null, Validators.compose([Validators.required])],
            'proper': [null, Validators.compose([Validators.required])],
            'lang': [null, Validators.compose([Validators.required])],
        });

    }
}
