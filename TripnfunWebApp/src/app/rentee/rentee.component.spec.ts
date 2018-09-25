import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RenteeComponent } from './rentee.component';

describe('RenteeComponent', () => {
  let component: RenteeComponent;
  let fixture: ComponentFixture<RenteeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RenteeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RenteeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
