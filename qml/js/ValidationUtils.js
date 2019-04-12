
/**
  Various utility to validate user input
*/

    /* to check if a mandatory field is provided by the user. return true if empty */
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

    /* return false if the input is not a number */
    function isNotNumeric(valueToCheck){
        return isNaN(valueToCheck);
    }

