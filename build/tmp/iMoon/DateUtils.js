
/* -------------------- Various utility functions -------------------- */

    /* utility functions to decide what value display in case of missing field value from DB */
    function getValueTodisplay(val) {

       if (val === undefined)
          return ""
       else
          return val;
    }

    /* used to check if a mandatory field is provided by the user */
    function isInputTextEmpty(fieldTxtValue)
    {
        if (fieldTxtValue.length <= 0 )
           return true
        else
           return false;
    }

    /* check if mandatory field is valid and present */
    function checkinputText(fieldTxtValue)
    {
        if (fieldTxtValue.length <= 0 || hasSpecialChar(fieldTxtValue))
           return false
        else
           return true;
    }

    /* return true if the input parametr contains comma sign */
    function containsComma(fieldTxtValue) {
        return /[,]|&#/.test(fieldTxtValue) ? true : false;
    }

    /* If regex matches, then string contains (at least) one special char. NOTE: '.' is allowed, is the decimal separators */
    function hasSpecialChar(fieldTxtValue) {
        /* dot sign is allowed because is the decimal separator */
        return /[<>?%#,;]|&#/.test(fieldTxtValue) ? true : false;
    }


    /* Depending on the Pagewidht of the Page (ie: the Device type) decide the Height of the scrollable */
    function getContentHeight(){

        if(root.width > units.gu(80))
            return addCategoryPage.height + addCategoryPage.height/2 + units.gu(20)
        else
            return addCategoryPage.height + addCategoryPage.height/2 + units.gu(10) //phone
    }

    /* Return the todayDate with UTC values set to zero */
    function getTodayDate(){

        var today = new Date();
        today.setUTCHours(0);
        today.setUTCMinutes(0);
        today.setUTCSeconds(0);
        today.setUTCMilliseconds(0);

        return today;
    }


    /* Add the provided amount of days at the input date, if amount is negative, subtract them. The returned data has
       minutse,seconds,millisecond set to zero because are not important to track them
    */
    function addDaysToDate(date, days) {
        return new Date(
            date.getFullYear(),
            date.getMonth(),
            date.getDate() + days,
            0,
            0,
            0,
            0
        );
    }


    /* Utility function to format the javascript date to have double digits for day and month (default is one digit in js)
       Example return date like: YYYY-MM-DD hh:mm:ss
       eg: 2017-04-28 12:10:05
    */
    function formatDateToStringTimeStamp(date)
    {
       var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
       var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
       var yyyy = date.getFullYear();

       var hh = addZeroBeforeHour(date.getHours());
       var mm = date.getMinutes();
       var ss = date.getSeconds();

       return (yyyy + "-" + MM + "-" + dd+ " "+hh+":"+mm+":"+ss);
    }


    /* Utility function to get hour, minutes, seconds, from a javascript date (hour are doubled digit, default is one in js)
       Example return time like: hh:mm:ss
       eg: 12:10:05
    */
    function getTimeFromDate(dat)
    {
       var date = new Date (dat);

       var hh = addZeroBefore(date.getHours());
       var mm = addZeroBefore(date.getMinutes());
       var ss = addZeroBefore(date.getSeconds());

       return (hh+":"+mm+":"+ss);
    }


    /* Utility to return values with double digit format */
    function addZeroBefore(n) {
       return (n < 10 ? '0' : '') + n;
    }


    /*
      To get the city local time
      utc offset can be a negative or positice value
    */
    function getLocalCityTime(dateToConvert,utcOffset) {

        // create Date object for current location
        //var d = dateToConvert; //new Date();
        var d = new Date(dateToConvert);

        // convert to msec
        // add local time zone offset
        // get UTC time in msec
        var utc = d.getTime() + (d.getTimezoneOffset() * 60000);

        // create new Date object for different city
        // using supplied offset
        var nd = new Date(utc + (3600000*utcOffset));


        // return time as a string
        //return "The local time in " + city + " is " + nd.toLocaleString();
        return nd;
    }


    /* Utility to convert time chosen by user in the gui to local time of the city applying the utcOffset ot the city */
    function getLocalTime(dateToConvert, utcOffset){

       return Dateutils.getTimeFromDate( Dateutils.getLocalCityTime(dateToConvert,utcOffset) );
    }


    /* Used for debug: print rise and set times for sun and moon */
    function printDateLocalTime(sunRiseDate, sunSetDate, moonRiseDate, moonSetDate, utcOffset){

        console.log("-local sunRiseDate: "+Dateutils.getTimeFromDate( Dateutils.getLocalCityTime(sunRiseDate,utcOffset)) );
        console.log("-local sunSetDate: "+Dateutils.getTimeFromDate( Dateutils.getLocalCityTime(sunSetDate,utcOffset)) );

        console.log("-local moonRiseDate: "+Dateutils.getTimeFromDate( Dateutils.getLocalCityTime(moonRiseDate,utcOffset)) );
        console.log("-local moonSetDate: "+Dateutils.getTimeFromDate( Dateutils.getLocalCityTime(moonSetDate,utcOffset)) );
    }

    /*
      Utility function that check if for the chosen time (the one set in the DatePicker) is in use or not the DLS (Day light saving).
      return true if in the provided date DLS is applyed.
      No filter for country that apply DLS

      Problem: the list of country that apply DSL can change every year: is necessary update the App
      Solution: use always solar time and add a warning label

      NOT USED: seems does not work

    */
    function isDayLightSaving(dateToCheck){

        Date.prototype.stdTimezoneOffset = function() {
           var jan = new Date(this.getFullYear(), 0, 1);
           var jul = new Date(this.getFullYear(), 6, 1);
           return Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset());
        }

        Date.prototype.dst = function() {
          return this.getTimezoneOffset() < this.stdTimezoneOffset();
        }

        if(dateToCheck.dst())
        {
           return true; //console.log("YEs is DLS");
        } else {
           return false; //console.log("NO DLS");
        }
    }
