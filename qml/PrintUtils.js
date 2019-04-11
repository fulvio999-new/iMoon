

/*
  Print info about sun calculated values for SUN
*/
function printSunReport(chosenDate, times, sunPosition) {

    console.log("---------- SUN INFO REPORT: ----------- ");
    console.log("----> ChosenDate is: "+chosenDate );
    console.log("Sunrise (formatted): "+getTimeFromDate(times.sunrise));
    console.log("Sunset (formatted): "+getTimeFromDate(times.sunset));

    //solarNoonsun is the time when the sun is in the highest position
    console.log("Sun solarNoon: "+times.solarNoon);

    console.log("Sun altitude (rad): "+sunPosition.altitude);
    console.log("Sun azimuth (rad): "+sunPosition.azimuth);
    console.log("----------------------------------------- ");
}


/*
  Print info about sun calculated values for MOON
*/
function printMoonReport(chosenDate, moonPosition, moonPhase, moonRise){

    console.log("----------- MOON INFO REPORT: ----------- ");
    console.log("moonPosition altitude: "+moonPosition.altitude);
    console.log("moonPosition azimuth: "+moonPosition.azimuth);
    console.log("moonPosition distance: "+moonPosition.distance);
    console.log("Fraction: "+ moonPhase.fraction);
    console.log("moonPosition parallacticAngle: "+moonPosition.parallacticAngle);
    console.log("Phase: "+ moonPhase.phase);
    console.log("Angle: "+ moonPhase.angle);
    console.log("MoonRise:"+Dateutils.getTimeFromDate(moonRise.rise));
    console.log("MoonSet:"+Dateutils.getTimeFromDate(moonRise.set));
    console.log("----------------------------------------- ");

}



/* Utility function to get hour, minutes, seconds, from a javascript date (hour are doubled digit, default is one in js)
   Example return time like: hh:mm:ss
   eg: 12:10:05
*/
function getTimeFromDate(date)
{

   var hh = addZeroBefore(date.getHours());
   var mm = addZeroBefore(date.getMinutes());
   var ss = addZeroBefore(date.getSeconds());

   return (hh+":"+mm+":"+ss);
}


/* Utility to return values with double digit format */
function addZeroBefore(n) {
   return (n < 10 ? '0' : '') + n;
}
