class Car {
	// Static (class) attributes
	static manufacturer = "Toyota";
	static wheels = 4;

	// Instance attributes
	model: string;
	year: number;

	constructor(model: string, year: number) {
		this.model = model;
		this.year = year;
	}
}

const car1 = new Car("Corolla", 2022);
const car2 = new Car("Camry", 2024);

console.log(Car.manufacturer); // Toyota
console.log(car1.model); // Corolla
console.log(car2.model); // Camry
