
    /* Depending on the Pagewidht of the Page (ie: the Device type) decide the Height of the scrollable */
    function getContentHeight(){

        if(root.width > units.gu(110))
            return mainPage.height + mainPage.height/2 + units.gu(23)
        else
            return mainPage.height + mainPage.height/2 + units.gu(29) //phone
    }
