/*
	want to be able to goal seek around things:
		1. goal weight
		2. goal date
		
	what does that mean? well, if i have a fixed goal date
	how much weight could i lose with a deficit of 200.
	solve for goalWeight
	
	if i have a fixed goal weight and i want to lose it before
	a fixed end date.
	solve for dailyCalorieNeed
	
	if i have a fixed goal weight and i want to know how long
	that will take to achieve.
	solve for goalDate
	
	i want to lose 2kg in 3 weeks. so, relative loss rather than
	absolute target.
*/

function Height(height_string) {
	this.raw_string = height_string;
	this.normalized = null;
	this.normalized_string = null;
	this.normalize_height();
}

Height.prototype.normalize_height = function() {
	var cm = /([\d\s]+)(cm|centimetres|centimeters)/;
	var m = /([\d\.\s]+)(m|metres|meters)/;
	var ft = /([\d\s]+)(feet|ft|')([\D\s]*([\d\s]*)(inches|in|")?)?/;
	var inch = /([\d\s]+)(inches|inch|in|")/;
	var catchAll = /([\d\.]+).*/;
	var r = null;
	if( r = cm.exec(this.raw_string) ) {				
		this.normalized = parseFloat(r[1]) / 100;
		this.normalized_string = r[1].replace(/ /g, "") + " centimeters";
	} else if( r = m.exec(this.raw_string) ) {
		this.normalized = parseFloat(r[1]);
		this.normalized_string = this.normalized + " meters";
	} else if( (r = ft.exec(this.raw_string)) || (r = catchAll.exec(this.raw_string)) ) {
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
		throw new InvalidArgumentException("Height: Invalid Argument", this.raw_string);
	}
}

Height.prototype.normalized_as_centimetres = function() {
	return this.normalized * 100;
}

function Weight(weight_string) {
	this.raw_string = weight_string;
	this.normalized = null;
  this.normalized_string = null;
	this.isKg = false;
	this.normalize_weight();
}

Weight.prototype.normalize_weight = function() {
	var kg = /(.*)(kg|kilos|kilograms)/;
	var lbs = /(.*)(lbs|lb|l)/;
	var catchAll = /(\d+).*/;
	var r = null;
	if( r = kg.exec(this.raw_string) ) {
		this.normalized = parseFloat(r[1]);
		this.normalized_string = this.normalized + " kilograms";
		this.isKg = true;
	} else if( r = lbs.exec(this.raw_string) ) {
		var pounds = parseFloat(r[1]);
		this.normalized = Math.round(pounds * 0.45359237 * 10) / 10;
		this.normalized_string = pounds + " pounds"
	} else if(r = catchAll.exec(this.raw_string)) {
		// treat this as pounds
		var pounds = parseFloat(r[1]);
		this.normalized = Math.round(pounds * 0.45359237 * 10) / 10;
		this.normalized_string = pounds + " pounds"
	} else {
		throw new InvalidArgumentException("Weight: Invalid Argument", this.raw_string);
	}	
}

function InvalidArgumentException(message, originalArgument) {
	this.message = message;
	this.originalArgument = originalArgument;
}

function BasalMetabolicRate(isMale, weight, height, age) {
	this.isMale = isMale;
	this.weight = weight;
	this.height = height;
	this.age = age;
	this.value = null;
	this.calculate();	
};

BasalMetabolicRate.prototype.calculate = function() {
	if(this.isMale) {	
		this.value = 66 + 13.7 * this.weight + 5 * this.height - 6.8 * this.age;
	} else {
		this.value = 655.1 + 9.563 * this.weight + 1.850 * this.height - 4.676 * this.age;
	}
};

function TotalEnergyExpediture(bmr, activityLevel, isMale) {
	this.bmr = bmr;
	this.activityLevel = this.interpretActivityLevelString(activityLevel, isMale);
	this.value = null;
	this.calculate();
};

TotalEnergyExpediture.prototype.calculate = function() {
	this.value = this.bmr * this.activityLevel;
};

TotalEnergyExpediture.prototype.calculate = function() {
	this.value = this.bmr * this.activityLevel;
};

TotalEnergyExpediture.prototype.interpretActivityLevelString = function(activityLevel, isMale) {
	var activityLevels = {
		sedentary:[1.15, 1.15],
		light:[1.4, 1.35],
		moderate:[1.5, 1.45],
		very:[1.85, 1.7],
		exceptional:[2.1, 2]
	}
	return activityLevels[activityLevel][(isMale ? 0 : 1)];
};

function DailyCalorieNeed(startDate, goalDate, weight, goalWeight, height, age, isMale, activityLevel) {
	this.startDate = Date.parse(startDate);
	this.goalDate = Date.parse(goalDate);
	this.weight = weight;
	this.goalWeight = goalWeight;
	this.height = height;
	this.age = age;
	this.isMale = isMale;
	this.activityLevel = activityLevel;
	this.value = null;
	this.daysUntilGoal = null;
	this.totalCaloriesToLose = null;
	this.bmr = new BasalMetabolicRate(this.isMale, this.weight, this.height, this.age);
	this.tee = new TotalEnergyExpediture(this.bmr.value, this.activityLevel, this.isMale);
	this.calculate();
};

DailyCalorieNeed.CAL_IN_KG_OF_HUMAN_FAT = 7800;
DailyCalorieNeed.MILLISECONDS_IN_A_DAY = (24 * 60 * 60 * 1000);

DailyCalorieNeed.prototype.calculate = function() {
	this.daysUntilGoal = (this.goalDate - this.startDate) / DailyCalorieNeed.MILLISECONDS_IN_A_DAY;
	var totalWeightDifference = this.weight - this.goalWeight;
	this.totalCaloriesToLose = totalWeightDifference * DailyCalorieNeed.CAL_IN_KG_OF_HUMAN_FAT;
	this.value = this.tee.value - (this.totalCaloriesToLose / this.daysUntilGoal);
};

DailyCalorieNeed.prototype.setGoalDate = function(goalDate) {
	this.goalDate = Date.parse(goalDate);
	this.calculate();
}

DailyCalorieNeed.prototype.setGoalWeight = function(goalWeight) {
	this.goalWeight = goalWeight;
	this.calculate();
}

DailyCalorieNeed.prototype.getTotalEnergyExpediture = function() {
	return (this.tee.value).round();
}

DailyCalorieNeed.prototype.getDailyCalorieDeficit = function() {
	return (this.tee.value - this.value).round();
}

DailyCalorieNeed.prototype.getKgPerWeek = function() {
	return (((this.tee.value - this.value) * 7) / 7800).round();
}

DailyCalorieNeed.prototype.getLbsPerWeek = function() {
	return ((((this.tee.value - this.value) * 7) / 7800) * 2.20462262).round();
}

DailyCalorieNeed.prototype.getMassPerWeek = function(isKg) {
	return isKg ? (this.getKgPerWeek() + " kg") : (this.getLbsPerWeek() + " lbs");
}

Number.prototype.round = function() {
	return Math.round(this * 100) / 100;
}

function process() {
	resetErrors();
	clearResults();
	var isError = false;
	try {
		var height = new Height(document.forms['calculator_form']['height'].value);
	} catch(heightError) {
		isError = true;
		markError(document.forms['calculator_form']['height']);
	}
	try {
		var weight = new Weight(document.forms['calculator_form']['weight'].value);
	} catch(weightError) {
		isError = true;
		markError(document.forms['calculator_form']['weight']);
	}
	var age = document.forms['calculator_form']['age'].value;
	if(!/(\d+)/.exec(age)) {
		isError = true;
		markError(document.forms['calculator_form']['age']);
	}
	for (var i=0; i < document.forms['calculator_form']['is_male'].length; i++) {
		if (document.forms['calculator_form']['is_male'][i].checked) {
			var isMale = ("true" == document.forms["calculator_form"]['is_male'][i].value) ? true : false;
		}
	}
	var startDate = document.forms['calculator_form']['start_date'].value;
	if(!/(\d+\/\d+\/\d\d+)/.exec(startDate)) {
		isError = true;
		markError(document.forms['calculator_form']['start_date']);
	}
	var goalDate = document.forms['calculator_form']['goal_date'].value;
	if(!/(\d+\/\d+\/\d\d+)/.exec(goalDate)) {
		isError = true;
		markError(document.forms['calculator_form']['goal_date']);
	}

	try {
		var goalWeight = new Weight(document.forms['calculator_form']['goal_weight'].value);
	} catch(weightError) {
		isError = true;
		markError(document.forms['calculator_form']['goal_weight']);
	}		
	var activityLevel = document.forms['calculator_form']['activity_level'].value;
		
	if(!isError) {
		var dcn = new DailyCalorieNeed(startDate, goalDate, weight.normalized, goalWeight.normalized, height.normalized_as_centimetres(), age, isMale, activityLevel);
 
		var resultDiv = document.getElementById('result');
		resultDiv.innerHTML = "<strong>	<ul><li><p>You burn about " + dcn.getTotalEnergyExpediture() + " calories per day.</p></li>" +
		                      "<li><p>To meet your goal weight you should eat " + dcn.value.round() + " calories per day.</p></li>" +
													"<li><p>That's " + dcn.getDailyCalorieDeficit() + " fewer calories than you burn " +
													"or a weight loss of " + dcn.getMassPerWeek(weight.isKg) + " per week until your goal date.</p></li>" + 
													"<li><p>Always check with your doctor that your goals are within safe limits.</p></li></ul></strong>";
	}
	return false;
}

function markError(element) {
	document.getElementById("error_message").style.display = "block";
	element.className = "error";
}

function clearResults() {
	var resultDiv = document.getElementById('result');
	resultDiv.innerHTML = "";
}

function resetErrors() {
	document.getElementById("error_message").style.display = "none";
	var calculatorForm = document.forms["calculator_form"];
	for(var i = 0; i < calculatorForm.elements.length; i++) {
		calculatorForm.elements[i].className = "";
	}
}

function setup() {
	var calculatorForm = document.forms["calculator_form"];
	calculatorForm.onsubmit = process;
}

window.onload = setup




