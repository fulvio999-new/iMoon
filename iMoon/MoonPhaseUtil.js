
/*
  Various utility functions to decode the Moon Phase numeric value to an human readable value
  NOTE: the comparison values are the ones from SuncalcLibray bu with adjustements due to precison error
*/
function  decodeMoonPhaseValue(moonPhase) {

    //if(moonPhase <= 0.22)
    if(moonPhase <= 0.22)
        return "New Moon"; //ok

    else if(moonPhase >= 0.93)
        return "New Moon"; //ok

    else if(moonPhase >= 0.223 && moonPhase <= 0.265) //ok
         return "First Quarter";

    else if(moonPhase >= 0.48 && moonPhase <= 0.515 )  //ok
         return "Full Moon";

    else if(moonPhase >= 0.73 && moonPhase <= 0.765)  //ok
         return "Last Quarter";

    else if(moonPhase > 0 && moonPhase < 0.25)
         return "Waxing Crescent"; //luna crecente or Evening Crescent

    else if(moonPhase > 0.25 && moonPhase < 0.5)
         return "Waxing Gibbous";

    else if(moonPhase > 0.516 && moonPhase < 0.75)
         return "Waning Gibbous"; //gibbosa calante or Morning Crescent

    else if(moonPhase > 0.766)
         return "Waning Crescent"; //crescente or Evening Crescent
}
