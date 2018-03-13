
/*
  Various utility functions to decode the Moon phase numeric value to an human readable value
*/
function decodeMoonPhaseValue(moonPhase) {

    if(moonPhase === 0)
        return "New Moon";

    else if(moonPhase === 0.25)
         return "First Quarter";

    else if(moonPhase === 0.5)
         return "Full Moon";

    else if(moonPhase === 0.75)
         return "Last Quarter";

    else if(moonPhase > 0 && moonPhase < 0.25)
         return "Waxing Crescent"; //luna crecente or Evening Crescent

    else if(moonPhase > 0.25 && moonPhase < 0.5)
         return "Waxing Gibbous";

    else if(moonPhase > 0.5 && moonPhase < 0.75)
         return "Waning Gibbous"; //gibbosa calante or Morning Crescent

    else if(moonPhase > 0.75)
         return "Waning Crescent"; //crescente or Evening Crescent
}

