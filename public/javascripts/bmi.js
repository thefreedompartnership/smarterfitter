function Height(height_string) {
	this.raw_string = height_string;
	this.normalized = null;
	this.normalized_string = null;
	this.normalize_height();
}

Height.prototype.normalize_height = function() {
	var cm = /([\d\s]+)cm/;
	var m = /([\d\.\s]+)m/;
	var ft = /([\d\s]+)(feet|ft|')([\D\s]*([\d\s]*)(inches|in|")?)?/;
	var inch = /([\d\s]+)(inches|inch|in|")/;
	var r = null;
	if( r = cm.exec(this.raw_string) ) {				
		this.normalized = parseFloat(r[1]) / 100;
		this.normalized_string = r[1].replace(/ /g, "") + " centimeters";
	} else if( r = m.exec(this.raw_string) ) {
		this.normalized = parseFloat(r[1]);
		this.normalized_string = this.normalized + " meters";
	} else if( r = ft.exec(this.raw_string) ) {
		var feet = r[1];
		var inches = "0";
		if( r[4] ) {
			inches = r[4];
		} 
		var height_in_inches = (feet * 12) + parseInt(inches);
		this.normalized = Math.round(height_in_inches * 2.54) / 100;
		this.normalized_string = feet.replace(/ /g, "") + " feet";
		if(parseInt(inches) > 0) {
			if(parseInt(inches) == 1) {
				this.normalized_string += (" " + inches.replace(/ /g, "") + " inch");
			} else {
				this.normalized_string += (" " + inches.replace(/ /g, "") + " inches");
			}
		} 
	} else if(r = inch.exec(this.raw_string)) {
		var inches = parseInt(r[1]);
		this.normalized = Math.round(inches * 2.54) / 100;
		this.normalized_string = inches + " inches";
	} else {
		throw new InvalidArgumentException("Height: Invalid Argument");
	}
}

function Weight(weight_string) {
	this.raw_string = weight_string;
	this.normalized = null;
  this.normalized_string = null;
	this.normalize_weight();
}

Weight.prototype.normalize_weight = function() {
	var kg = /(.*)kg/;
	var lbs = /(.*)(lbs|lb)/;
	var r = null;
	if( r = kg.exec(this.raw_string) ) {
		this.normalized = parseFloat(r[1]);
		this.normalized_string = this.normalized + " kilograms";
	} else if( r = lbs.exec(this.raw_string) ) {
		var pounds = parseFloat(r[1]);
		this.normalized = Math.round(pounds * 0.45359237 * 10) / 10;
		this.normalized_string = pounds + " pounds"
	} else {
		throw new InvalidArgumentException("Weight: Invalid Argument");
	}	
}

function BodyMassIndex(height, weight) {
	this.height = height;
	this.weight = weight;
	this.value = null;
	this.interpretation = null;
	this.calculate();
	this.interpret();
}

BodyMassIndex.prototype.calculate = function() {
	var index = this.weight.normalized / Math.pow(this.height.normalized, 2);
	this.value = Math.round(index * 10) / 10;
}

BodyMassIndex.prototype.interpret = function() {
	if( this.value < 18.5 ) {
		this.interpretation = "underweight";
	} else if( this.value >= 18.5 && this.value < 25.0 ) {
		this.interpretation = "normal";
	} else if( this.value >= 25.0 && this.value < 30.0 ) {
		this.interpretation = "overweight";
	} else if( this.value >= 30 ){
		this.interpretation = "obese";
	} else {
		this.interpretation = null;
	}
}

function InvalidArgumentException(message) {
	this.message = message;
}

function process() {

	$('height').style.backgroundColor = "white";
	$('weight').style.backgroundColor = "white";
	$('error_message').style.display = "none";
	$('instructions').style.display = "block";
	
	var isHeightError = false;
	var isWeightError = false;
	
	var height = null;
	try {
		height = new Height($('height').value);
	} catch ( error ) {			
		isHeightError = true;		
	}
	var weight = null;
	try {
		weight = new Weight($('weight').value);
	} catch ( error ) {
		isWeightError = true;
	}
		
	if( !isHeightError && !isWeightError ) {
		var bmi = new BodyMassIndex(height, weight);
	
		$('bmi').innerHTML = bmi.value;
		$('weight_normalized').innerHTML = weight.normalized_string;			
		$('height_normalized').innerHTML = height.normalized_string;
		$('bmi_interpreted').innerHTML = bmi.interpretation;

	} else {
		$('instructions').style.display = "none";
		$('error_message').style.display = "block";
		
		if( isHeightError ) {
//			$('height_label').style.backgroundColor = "#FF6600";
			$('height').style.backgroundColor = "#FF6600";
		}
		if( isWeightError ) {
//			$('weight_label').style.backgroundColor = "#FF6600";
			$('weight').style.backgroundColor = "#FF6600";
		}
	}
	
	return false;
}

function $(object_id) {
	return document.getElementById(object_id)
}

function setup() {
	var calculatorForm = document.getElementById('calculator_form');
	calculatorForm.onsubmit = process;
}

window.onload = setup