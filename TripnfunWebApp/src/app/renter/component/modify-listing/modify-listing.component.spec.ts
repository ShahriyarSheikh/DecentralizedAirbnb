import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ModifyListingComponent } from './modify-listing.component';

describe('ModifyListingComponent', () => {
  let component: ModifyListingComponent;
  let fixture: ComponentFixture<ModifyListingComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ModifyListingComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ModifyListingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
